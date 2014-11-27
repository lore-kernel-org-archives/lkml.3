Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaK0JFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:05:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaK0JE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:04:59 -0500
Date: Thu, 27 Nov 2014 10:05:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Huang Bo <huangbobupt@163.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] HID: add BETOP game controller force feedback
 support
In-Reply-To: <54768284.4060201@163.com>
Message-ID: <alpine.LNX.2.00.1411271004260.23174@pobox.suse.cz>
References: <54768284.4060201@163.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Huang Bo wrote:

> From: Huang Bo <huangbobupt@163.com>
> 
> Adds force feedback support for BETOP USB game controllers.
> These devices are mass produced in China.

Thanks. We are almost there, except ...

[ ... snip ... ]
> +static int betopff_init(struct hid_device *hid)
> +{
> +    struct betopff_device *betopff;
> +    struct hid_report *report;
> +    struct hid_input *hidinput =
> +            list_first_entry(&hid->inputs, struct hid_input, list);
> +    struct list_head *report_list =
> +            &hid->report_enum[HID_OUTPUT_REPORT].report_list;
> +    struct input_dev *dev = hidinput->input;
> +    int field_count = 0;
> +    int error;
> +    int i, j;
> +
> +    if (list_empty(report_list)) {
> +        hid_err(hid, "no output reports found\n");
> +        return -ENODEV;
> +    }
> +
> +    report = list_first_entry(report_list, struct hid_report, list);
> +    for (i = 0; i < report->maxfield; i++) {
> +        for (j = 0; j < report->field[i]->report_count; j++) {
> +            report->field[i]->value[j] = 0x00;

I asked for a comment to be added here why you are zeroing those out.

Thanks,

-- 
Jiri Kosina
SUSE Labs
