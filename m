Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3FXJDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:03:53 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62773 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3FXJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <51AF50CE.5050607@monstr.eu>
References: <f0df7e546368dbf705bd302cfe7f834476d00e3e.1369288979.git.michal.simek@xilinx.com>
	<51AF50CE.5050607@monstr.eu>
Date: Mon, 24 Jun 2013 11:03:51 +0200
X-Google-Sender-Auth: 9B-lKGWujgdR_uVkYaJ_aiQ_2nw
Message-ID: <CAMuHMdWnA0LiLc+aYhZyHGpykFc_Xb0j2MWSPKLKQKaH910pcA@mail.gmail.com>
Subject: Re: [PATCH] audit: Fix decimal constant description
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 4:53 PM, Michal Simek <monstr@monstr.eu> wrote:
> any comment on this?
>
> Geert: I fixes one warning reported in your regression log.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> On 05/23/2013 08:03 AM, Michal Simek wrote:
>> Use proper decimal type for comparison with u32.
>>
>> Compilation warning was introduced by:
>> "audit: Make testing for a valid loginuid explicit."
>> (sha1: 780a7654cee8d61819512385e778e4827db4bfbc)
>>
>> Warning:
>> kernel/auditfilter.c: In function 'audit_data_to_entry':
>> kernel/auditfilter.c:426:3: warning: this decimal constant
>> is unsigned only in ISO C90 [enabled by default]
>>    if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> CC: Al Viro <viro@zeniv.linux.org.uk>
>> CC: Eric Paris <eparis@redhat.com>
>> ---
>>  kernel/auditfilter.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> index 83a2970..cfa1f73 100644
>> --- a/kernel/auditfilter.c
>> +++ b/kernel/auditfilter.c
>> @@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>>               f->lsm_rule = NULL;
>>
>>               /* Support legacy tests for a valid loginuid */
>> -             if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
>> +             if ((f->type == AUDIT_LOGINUID) && (f->val == ~0U)) {
>>                       f->type = AUDIT_LOGINUID_SET;
>>                       f->val = 0;
>>               }
>> --
>> 1.8.2.3
>>
>
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
>
>



--
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
