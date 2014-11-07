Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaKGKQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:16:42 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51600 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKGKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:16:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141107101406.GG24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	<CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	<20141107073720.GB24745@yliu-dev.sh.intel.com>
	<CAKv+Gu-rRMmcP4LF3oo5=6hf8m7fjzkzV14hfkjBPbPn34OZGA@mail.gmail.com>
	<20141107081344.GC24745@yliu-dev.sh.intel.com>
	<CAKv+Gu9u5ojSWarm2A5MeWOj1r1+W8U0d+icnx2rfAmiSaL8Ww@mail.gmail.com>
	<20141107084604.GD24745@yliu-dev.sh.intel.com>
	<CAKv+Gu_Xx9aKzNU2CfP20WR1ojwjUEvTKyD7L-S9bR_C8EOogQ@mail.gmail.com>
	<20141107092651.GE24745@yliu-dev.sh.intel.com>
	<CAKv+Gu_TEjtGkEA0PTdt7VC_v9uqOQT3jLFRwwuXFUtodttLSA@mail.gmail.com>
	<20141107101406.GG24745@yliu-dev.sh.intel.com>
Date: Fri, 7 Nov 2014 11:16:37 +0100
Message-ID: <CAKv+Gu8mPaeeBybH9cRJ2WyXvDPnf_TtDr40NxQ4A18yXHfE4g@mail.gmail.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 11:14, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> On Fri, Nov 07, 2014 at 10:35:44AM +0100, Ard Biesheuvel wrote:
>> On 7 November 2014 10:26, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> > On Fri, Nov 07, 2014 at 10:03:55AM +0100, Ard Biesheuvel wrote:
>> >> On 7 November 2014 09:46, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> >> > On Fri, Nov 07, 2014 at 09:23:56AM +0100, Ard Biesheuvel wrote:
>> >> >> On 7 November 2014 09:13, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> >> >> > On Fri, Nov 07, 2014 at 08:44:40AM +0100, Ard Biesheuvel wrote:
>> >> >> >> On 7 November 2014 08:37, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> >> >> >> > On Fri, Nov 07, 2014 at 08:17:36AM +0100, Ard Biesheuvel wrote:
>> >> >> >> >> On 7 November 2014 06:47, LKP <lkp@01.org> wrote:
>> >> >> >> >> > FYI, we noticed the below changes on
>> >> >> >> >> >
>> >> >> >> >> > https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
>> >> >> >> >> > commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")
>> >> >> >> >> >
>> >> >> >> >> >
>> >> >> >> >> > +-----------------------+------------+------------+
>> >> >> >> >> > |                       | 2fa165a26c | aacdce6e88 |
>> >> >> >> >> > +-----------------------+------------+------------+
>> >> >> >> >> > | boot_successes        | 20         | 10         |
>> >> >> >> >> > | early-boot-hang       | 1          |            |
>> >> >> >> >> > | boot_failures         | 0          | 5          |
>> >> >> >> >> > | PANIC:early_exception | 0          | 5          |
>> >> >> >> >> > +-----------------------+------------+------------+
>> >> >> >> >> >
>> >> >> >> >> >
>> >> >> >> >> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
>> >> >> >> >> > [    0.000000] bootconsole [earlyser0] enabled
>> >> >> >> >> > [    0.000000] NX (Execute Disable) protection: active
>> >> >> >> >> > PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
>> >> >> >> >> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
>> >> >> >> >> > [    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
>> >> >> >> >> > [    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
>> >> >> >> >> > [    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
>> >> >> >> >> > [    0.000000] Call Trace:
>> >> >> >> >> > [    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
>> >> >> >> >> > [    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
>> >> >> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> >> >> > [    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
>> >> >> >> >> > [    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
>> >> >> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> >> >> > [    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
>> >> >> >> >> > [    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
>> >> >> >> >> > [    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
>> >> >> >> >> > [    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
>> >> >> >> >> > [    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
>> >> >> >> >> > [    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
>> >> >> >> >> > [    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
>> >> >> >> >> > [    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
>> >> >> >> >> > [    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
>> >> >> >> >> > [    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
>> >> >> >> >> > [    0.000000] RIP 0x4
>> >> >> >> >> >
>> >> >> >> >>
>> >> >> >> >> This is most puzzling. Could anyone decode the exception?
>> >> >> >> >> This looks like the non-EFI path through dmi_scan_machine(), which
>> >> >> >> >> calls dmi_present() /after/ calling dmi_smbios3_present(), which
>> >> >> >> >> apparently has not found the _SM3_ header tag. Or could the call stack
>> >> >> >> >> be inaccurate?
>> >> >> >> >>
>> >> >> >> >> Anyway, it would be good to know the exact type of the platform,
>> >> >> >> >
>> >> >> >> > It's a Nehalem-EP machine, wht 16 CPU and 12G memory.
>> >> >> >> >
>> >> >> >> >> and
>> >> >> >> >> perhaps we could find out if there is an inadvertent _SM3_ tag
>> >> >> >> >> somewhere in the 0xF0000 - 0xFFFFF range?
>> >> >> >> >
>> >> >> >> > Sorry, how?
>> >> >> >> >
>> >> >> >>
>> >> >> >> That's not a brand new machine, so I suppose there wouldn't be a
>> >> >> >> SMBIOS 3.0 header lurking in there.
>> >> >> >>
>> >> >> >> Anyway, if you are in a position to try things, could you apply this
>> >> >> >>
>> >> >> >> --- a/drivers/firmware/dmi_scan.c
>> >> >> >> +++ b/drivers/firmware/dmi_scan.c
>> >> >> >> @@ -617,7 +617,7 @@ void __init dmi_scan_machine(void)
>> >> >> >>                 memset(buf, 0, 16);
>> >> >> >>                 for (q = p; q < p + 0x10000; q += 16) {
>> >> >> >>                         memcpy_fromio(buf + 16, q, 16);
>> >> >> >> -                       if (!dmi_smbios3_present(buf) || !dmi_present(buf)) {
>> >> >> >> +                       if (!dmi_present(buf)) {
>> >> >> >>                                 dmi_available = 1;
>> >> >> >>                                 dmi_early_unmap(p, 0x10000);
>> >> >> >>                                 goto out;
>> >> >> >>
>> >> >> >> and try again?
>> >> >> >


>> >> >> > kernel boots perfectly with this patch applied.
>> >> >> >
>> >> >> >         --yliu
>> >> >> >
>> >> >>
>> >> >> Thank you! Very useful to know
>> >> >>
>> >> >
>> >> > Sigh, I made a silly error, I speicified wrong commit while testing your
>> >> > patch. Sorry for that.
>> >> >
>> >> > And I tested it again, with your former patch, sorry, the panic still
>> >> > happens.
>> >> >
>> >> >         --yliu
>> >> >
>> >>
>> >> OK, no worries.
>> >>
>> >> Could you please try the attached patch? On my ARM system, it produces
>> >> something like this
>> >>
>> >>  ====== Decoding _DMI_ header:
>> >> 5f 44 4d 49 5f 89 62 02 00 c0 8a fe 0c 00 27 cf
>> >> ====== Remapped SMBIOS table 0xfe8ac000 at ffffff800001e000, size 0x262, num 0xc
>> >> ====== Processing SMBIOS table entry at ffffff800001e000, type 0x0, length 0x18
>> >> ====== Processing SMBIOS table entry at ffffff800001e043, type 0x1, length 0x1b
>> >> ====== Processing SMBIOS table entry at ffffff800001e09d, type 0x2, length 0x11
>> >> ====== Processing SMBIOS table entry at ffffff800001e105, type 0x3, length 0x18
>> >> ====== Processing SMBIOS table entry at ffffff800001e155, type 0x4, length 0x2a
>> >> ====== Processing SMBIOS table entry at ffffff800001e19a, type 0x7, length 0x13
>> >> ====== Processing SMBIOS table entry at ffffff800001e1b5, type 0x9, length 0x11
>> >> ====== Processing SMBIOS table entry at ffffff800001e1cf, type 0x10, length 0x17
>> >> ====== Processing SMBIOS table entry at ffffff800001e1e8, type 0x11, length 0x28
>> >> ====== Processing SMBIOS table entry at ffffff800001e22e, type 0x13, length 0x1f
>> >> ====== Processing SMBIOS table entry at ffffff800001e24f, type 0x20, length 0xb
>> >> ====== Processing SMBIOS table entry at ffffff800001e25c, type 0x7f, length 0x4
>> >> SMBIOS 2.7 present.
>> >> DMI: ARM Arm Versatile Express/Arm Versatile Express, BIOS 16:20:46 Oct 28 2014
>> >>
>> >> That should help us pinpoint what is going on here.
>> >>
>> >
>> > Here is the output:
>> >
>> > [    0.000000] NX (Execute Disable) protection: active
>> > [    0.000000] ====== Decoding _DMI_ header:
>> > [    0.000000] 5f 44 4d 49 5f 48 a3 0b 00 20 60 8f 3e 00 25 00
>> > [    0.000000] ====== Remapped SMBIOS table 0xffffffff8f602000 at ffffffffff240000, size 0xba3, num 0x3e
>>
>> OK, so that looks like more type promotion silliness.
>>
>> Could you apply this, and retry?
>
> Despites the long output like following, it fixes the hang: the kernel
> boots perfectly this time. Is that expected? ;)
>
> ....
> [   12.568459] ====== Processing SMBIOS table entry at ffffc900018ee1a2, type 0x8, length 0x9
> [   12.577941] ====== Processing SMBIOS table entry at ffffc900018ee1ba, type 0x8, length 0x9
> [   12.587433] ====== Processing SMBIOS table entry at ffffc900018ee1cf, type 0x8, length 0x9
> [   12.596918] ====== Processing SMBIOS table entry at ffffc900018ee1e4, type 0x8, length 0x9
> [   12.606400] ====== Processing SMBIOS table entry at ffffc900018ee1f9, type 0x8, length 0x9
> [   12.615904] ====== Processing SMBIOS table entry at ffffc900018ee20e, type 0x8, length 0x9
> [   12.625389] ====== Processing SMBIOS table entry at ffffc900018ee22c, type 0x8, length 0x9
> [   12.634871] ====== Processing SMBIOS table entry at ffffc900018ee24a, type 0x8, length 0x9
> [   12.644359] ====== Processing SMBIOS table entry at ffffc900018ee268, type 0x8, length 0x9
> [   12.653842] ====== Processing SMBIOS table entry at ffffc900018ee286, type 0x8, length 0x9
> [   12.663324] ====== Processing SMBIOS table entry at ffffc900018ee2a4, type 0x8, length 0x9
> [   12.672821] ====== Processing SMBIOS table entry at ffffc900018ee2c2, type 0x9, length 0xd
> [   12.682307] ====== Processing SMBIOS table entry at ffffc900018ee2e1, type 0x9, length 0xd
> [   12.691788] ====== Processing SMBIOS table entry at ffffc900018ee300, type 0x9, length 0xd
> [   12.701276] ====== Processing SMBIOS table entry at ffffc900018ee31f, type 0x9, length 0xd
> [   12.710757] ====== Processing SMBIOS table entry at ffffc900018ee33e, type 0xa, length 0x6
> [   12.720241] ====== Processing SMBIOS table entry at ffffc900018ee35c, type 0xa, length 0x6
> [   12.729729] ====== Processing SMBIOS table entry at ffffc900018ee37a, type 0xa, length 0x6
> [   12.739218] ====== Processing SMBIOS table entry at ffffc900018ee3a2, type 0xb, length 0x5
> [   12.748705] ====== Processing SMBIOS table entry at ffffc900018ee3b2, type 0xc, length 0x5
> [   12.758197] ====== Processing SMBIOS table entry at ffffc900018ee3da, type 0xc, length 0x5
> [   12.767687] ====== Processing SMBIOS table entry at ffffc900018ee401, type 0xc, length 0x5
> [   12.777173] ====== Processing SMBIOS table entry at ffffc900018ee429, type 0xc, length 0x5
> [   12.786634] ====== Processing SMBIOS table entry at ffffc900018ee458, type 0xd, length 0x16
> [   12.796220] ====== Processing SMBIOS table entry at ffffc900018ee47f, type 0x18, length 0x5
> [   12.805800] ====== Processing SMBIOS table entry at ffffc900018ee486, type 0x20, length 0x14
> [   12.815483] ====== Processing SMBIOS table entry at ffffc900018ee49c, type 0x10, length 0xf
> [   12.825066] ====== Processing SMBIOS table entry at ffffc900018ee4ad, type 0x13, length 0xf
> [   12.834630] ====== Processing SMBIOS table entry at ffffc900018ee4be, type 0x11, length 0x1b
> [   12.844321] ====== Processing SMBIOS table entry at ffffc900018ee527, type 0x14, length 0x13
> [   12.854000] ====== Processing SMBIOS table entry at ffffc900018ee53c, type 0x11, length 0x1b
> [   12.863688] ====== Processing SMBIOS table entry at ffffc900018ee598, type 0x11, length 0x1b
> [   12.873375] ====== Processing SMBIOS table entry at ffffc900018ee601, type 0x14, length 0x13
>
> ...
>
> And there are more of them .., if you need, I can attach the whole dmesg.
>

Yes, that is expected. Congratulations, we found the bug!

Thanks for helping me out here.

Regards,
Ard.
