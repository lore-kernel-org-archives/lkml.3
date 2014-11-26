Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKZQWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:22:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKZQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:22:40 -0500
Date: Wed, 26 Nov 2014 17:22:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Huang Bo <huangbobupt@163.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] HID: add BETOP game controller force feedback
 support
In-Reply-To: <5475E0C7.9020500@163.com>
Message-ID: <alpine.LNX.2.00.1411261721010.23174@pobox.suse.cz>
References: <3e9f782f.a7fa.149df95fef7.Coremail.huangbobupt@163.com> <alpine.LNX.2.00.1411251534010.23174@pobox.suse.cz> <3497222f.2152a.149ec27f2c1.Coremail.huangbobupt@163.com> <alpine.LNX.2.00.1411261414160.23174@pobox.suse.cz> <5475D7CC.1080606@163.com>
 <alpine.LNX.2.00.1411261449140.23174@pobox.suse.cz> <5475E0C7.9020500@163.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Huang Bo wrote:

> On 11/26/2014 09:49 PM, Jiri Kosina wrote:
> > On Wed, 26 Nov 2014, Huang Bo wrote:
> >
> >>> It's unfortunately whitespace damaged again. If it's not possible to set 
> >>> up your e-mail client not to cause whitespace damage to patches (please 
> >>> see Documentation/email-clients.txt for some hints), attach the patch as 
> >>> an e-mail attachment.
> >>>
> >> From: Huang Bo <huangbobupt@163.com>
> >>
> >> Adds force feedback support for BETOP USB game controllers.
> >> These devices are mass produced in China.
> > Alright, so you apparently wrote the code with incorrect formatting, as 
> > even the version you attached doesn't have the formatting right.
> >
> > Please reformat the code according to Documentation/CodingStyle and 
> > resubmit.
> >
> > Thanks,
> >
> From: Huang Bo <huangbobupt@163.com>
> 
> Adds force feedback support for BETOP USB game controllers.
> These devices are mass produced in China.

The inline version is still whitespace-damaged, but the version you 
attached looks good.

[ ... snip ... ]
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 4113999..a0546ca 100755
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_HID_CHERRY)    += hid-cherry.o
>  obj-$(CONFIG_HID_CHICONY)    += hid-chicony.o
>  obj-$(CONFIG_HID_CYPRESS)    += hid-cypress.o
>  obj-$(CONFIG_HID_DRAGONRISE)    += hid-dr.o
> +obj-$(CONFIG_HID_BETOP_FF)    += hid-betopff.o

Please try to keep the list ordered.

[ ... snip ... ]
> +static int betopff_init(struct hid_device *hid)
> +{
> +    struct betopff_device *betopff;
> +    struct hid_report *report;
> +    struct hid_input *hidinput;
> +    struct list_head *report_list =
> +            &hid->report_enum[HID_OUTPUT_REPORT].report_list;
> +    struct list_head *report_ptr = report_list;
> +    struct input_dev *dev;
> +    int error;
> +    int i, j;
> +    int field_count = 0;
> +
> +    if (list_empty(report_list)) {
> +        hid_err(hid, "no output reports found\n");
> +        return -ENODEV;
> +    }
> +
> +    list_for_each_entry(hidinput, &hid->inputs, list) {
> +
> +        report_ptr = report_ptr->next;
> +
> +        if (report_ptr == report_list) {
> +            hid_err(hid, "required output report is missing\n");
> +            return -ENODEV;
> +        }
> +
> +        report = list_entry(report_ptr, struct hid_report, list);
> +        if (report->maxfield < 1) {
> +            hid_err(hid, "no fields in the report\n");
> +            return -ENODEV;
> +        }
> +
> +        for (i = 0; i < report->maxfield; i++) {
> +            for (j = 0; j < report->field[i]->report_count; j++) {
> +                report->field[i]->value[j] = 0x00;
> +                field_count++;

It's not obvious why this is needed, so a comment before the loop would be 
nice.

-- 
Jiri Kosina
SUSE Labs
