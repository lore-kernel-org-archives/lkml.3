Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKGJED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:04:03 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51794 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKGJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141107084604.GD24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	<CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	<20141107073720.GB24745@yliu-dev.sh.intel.com>
	<CAKv+Gu-rRMmcP4LF3oo5=6hf8m7fjzkzV14hfkjBPbPn34OZGA@mail.gmail.com>
	<20141107081344.GC24745@yliu-dev.sh.intel.com>
	<CAKv+Gu9u5ojSWarm2A5MeWOj1r1+W8U0d+icnx2rfAmiSaL8Ww@mail.gmail.com>
	<20141107084604.GD24745@yliu-dev.sh.intel.com>
Date: Fri, 7 Nov 2014 10:03:55 +0100
Message-ID: <CAKv+Gu_Xx9aKzNU2CfP20WR1ojwjUEvTKyD7L-S9bR_C8EOogQ@mail.gmail.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0122930ab392b90507411727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0122930ab392b90507411727
Content-Type: text/plain; charset=UTF-8

On 7 November 2014 09:46, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> On Fri, Nov 07, 2014 at 09:23:56AM +0100, Ard Biesheuvel wrote:
>> On 7 November 2014 09:13, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> > On Fri, Nov 07, 2014 at 08:44:40AM +0100, Ard Biesheuvel wrote:
>> >> On 7 November 2014 08:37, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
>> >> > On Fri, Nov 07, 2014 at 08:17:36AM +0100, Ard Biesheuvel wrote:
>> >> >> On 7 November 2014 06:47, LKP <lkp@01.org> wrote:
>> >> >> > FYI, we noticed the below changes on
>> >> >> >
>> >> >> > https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
>> >> >> > commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")
>> >> >> >
>> >> >> >
>> >> >> > +-----------------------+------------+------------+
>> >> >> > |                       | 2fa165a26c | aacdce6e88 |
>> >> >> > +-----------------------+------------+------------+
>> >> >> > | boot_successes        | 20         | 10         |
>> >> >> > | early-boot-hang       | 1          |            |
>> >> >> > | boot_failures         | 0          | 5          |
>> >> >> > | PANIC:early_exception | 0          | 5          |
>> >> >> > +-----------------------+------------+------------+
>> >> >> >
>> >> >> >
>> >> >> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
>> >> >> > [    0.000000] bootconsole [earlyser0] enabled
>> >> >> > [    0.000000] NX (Execute Disable) protection: active
>> >> >> > PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
>> >> >> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
>> >> >> > [    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
>> >> >> > [    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
>> >> >> > [    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
>> >> >> > [    0.000000] Call Trace:
>> >> >> > [    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
>> >> >> > [    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
>> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> > [    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
>> >> >> > [    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
>> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> >> >> > [    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
>> >> >> > [    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
>> >> >> > [    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
>> >> >> > [    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
>> >> >> > [    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
>> >> >> > [    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
>> >> >> > [    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
>> >> >> > [    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
>> >> >> > [    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
>> >> >> > [    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
>> >> >> > [    0.000000] RIP 0x4
>> >> >> >
>> >> >>
>> >> >> This is most puzzling. Could anyone decode the exception?
>> >> >> This looks like the non-EFI path through dmi_scan_machine(), which
>> >> >> calls dmi_present() /after/ calling dmi_smbios3_present(), which
>> >> >> apparently has not found the _SM3_ header tag. Or could the call stack
>> >> >> be inaccurate?
>> >> >>
>> >> >> Anyway, it would be good to know the exact type of the platform,
>> >> >
>> >> > It's a Nehalem-EP machine, wht 16 CPU and 12G memory.
>> >> >
>> >> >> and
>> >> >> perhaps we could find out if there is an inadvertent _SM3_ tag
>> >> >> somewhere in the 0xF0000 - 0xFFFFF range?
>> >> >
>> >> > Sorry, how?
>> >> >
>> >>
>> >> That's not a brand new machine, so I suppose there wouldn't be a
>> >> SMBIOS 3.0 header lurking in there.
>> >>
>> >> Anyway, if you are in a position to try things, could you apply this
>> >>
>> >> --- a/drivers/firmware/dmi_scan.c
>> >> +++ b/drivers/firmware/dmi_scan.c
>> >> @@ -617,7 +617,7 @@ void __init dmi_scan_machine(void)
>> >>                 memset(buf, 0, 16);
>> >>                 for (q = p; q < p + 0x10000; q += 16) {
>> >>                         memcpy_fromio(buf + 16, q, 16);
>> >> -                       if (!dmi_smbios3_present(buf) || !dmi_present(buf)) {
>> >> +                       if (!dmi_present(buf)) {
>> >>                                 dmi_available = 1;
>> >>                                 dmi_early_unmap(p, 0x10000);
>> >>                                 goto out;
>> >>
>> >> and try again?
>> >
>> > kernel boots perfectly with this patch applied.
>> >
>> >         --yliu
>> >
>>
>> Thank you! Very useful to know
>>
>
> Sigh, I made a silly error, I speicified wrong commit while testing your
> patch. Sorry for that.
>
> And I tested it again, with your former patch, sorry, the panic still
> happens.
>
>         --yliu
>

OK, no worries.

Could you please try the attached patch? On my ARM system, it produces
something like this

 ====== Decoding _DMI_ header:
5f 44 4d 49 5f 89 62 02 00 c0 8a fe 0c 00 27 cf
====== Remapped SMBIOS table 0xfe8ac000 at ffffff800001e000, size 0x262, num 0xc
====== Processing SMBIOS table entry at ffffff800001e000, type 0x0, length 0x18
====== Processing SMBIOS table entry at ffffff800001e043, type 0x1, length 0x1b
====== Processing SMBIOS table entry at ffffff800001e09d, type 0x2, length 0x11
====== Processing SMBIOS table entry at ffffff800001e105, type 0x3, length 0x18
====== Processing SMBIOS table entry at ffffff800001e155, type 0x4, length 0x2a
====== Processing SMBIOS table entry at ffffff800001e19a, type 0x7, length 0x13
====== Processing SMBIOS table entry at ffffff800001e1b5, type 0x9, length 0x11
====== Processing SMBIOS table entry at ffffff800001e1cf, type 0x10, length 0x17
====== Processing SMBIOS table entry at ffffff800001e1e8, type 0x11, length 0x28
====== Processing SMBIOS table entry at ffffff800001e22e, type 0x13, length 0x1f
====== Processing SMBIOS table entry at ffffff800001e24f, type 0x20, length 0xb
====== Processing SMBIOS table entry at ffffff800001e25c, type 0x7f, length 0x4
SMBIOS 2.7 present.
DMI: ARM Arm Versatile Express/Arm Versatile Express, BIOS 16:20:46 Oct 28 2014

That should help us pinpoint what is going on here.

-- 
Ard.

--089e0122930ab392b90507411727
Content-Type: text/plain; charset=US-ASCII; name="dmi-debug.diff"
Content-Disposition: attachment; filename="dmi-debug.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i27bgkbt0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvZG1pX3NjYW4uYyBiL2RyaXZlcnMvZmlybXdh
cmUvZG1pX3NjYW4uYwppbmRleCBjNWY3YjRlOWViNmMuLjBmN2JjOWRiM2QwZCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9maXJtd2FyZS9kbWlfc2Nhbi5jCisrKyBiL2RyaXZlcnMvZmlybXdhcmUvZG1p
X3NjYW4uYwpAQCAtOTIsNiArOTIsOSBAQCBzdGF0aWMgdm9pZCBkbWlfdGFibGUodTggKmJ1Ziwg
aW50IGxlbiwgaW50IG51bSwKIAl3aGlsZSAoKGkgPCBudW0pICYmIChkYXRhIC0gYnVmICsgc2l6
ZW9mKHN0cnVjdCBkbWlfaGVhZGVyKSkgPD0gbGVuKSB7CiAJCWNvbnN0IHN0cnVjdCBkbWlfaGVh
ZGVyICpkbSA9IChjb25zdCBzdHJ1Y3QgZG1pX2hlYWRlciAqKWRhdGE7CiAKKwkJcHJfZXJyKCI9
PT09PT0gUHJvY2Vzc2luZyBTTUJJT1MgdGFibGUgZW50cnkgYXQgJXAsIHR5cGUgMHgleCwgbGVu
Z3RoIDB4JXhcbiIsCisJCQlkYXRhLCBkbS0+dHlwZSwgZG0tPmxlbmd0aCk7CisKIAkJLyoKIAkJ
ICogNy40NSBFbmQtb2YtVGFibGUgKFR5cGUgMTI3KSBbU01CSU9TIHJlZmVyZW5jZSBzcGVjIHYz
LjAuMF0KIAkJICovCkBAIC0xMjYsNiArMTI5LDkgQEAgc3RhdGljIGludCBfX2luaXQgZG1pX3dh
bGtfZWFybHkodm9pZCAoKmRlY29kZSkoY29uc3Qgc3RydWN0IGRtaV9oZWFkZXIgKiwKIAlpZiAo
YnVmID09IE5VTEwpCiAJCXJldHVybiAtMTsKIAorCXByX2VycigiPT09PT09IFJlbWFwcGVkIFNN
QklPUyB0YWJsZSAweCVsbHggYXQgJXAsIHNpemUgMHgleCwgbnVtIDB4JXhcbiIsCisJCWRtaV9i
YXNlLCBidWYsIGRtaV9sZW4sIGRtaV9udW0pOworCiAJZG1pX3RhYmxlKGJ1ZiwgZG1pX2xlbiwg
ZG1pX251bSwgZGVjb2RlLCBOVUxMKTsKIAogCWFkZF9kZXZpY2VfcmFuZG9tbmVzcyhidWYsIGRt
aV9sZW4pOwpAQCAtNDk1LDEwICs1MDEsMTcgQEAgc3RhdGljIGludCBfX2luaXQgZG1pX3ByZXNl
bnQoY29uc3QgdTggKmJ1ZikKIAlidWYgKz0gMTY7CiAKIAlpZiAobWVtY21wKGJ1ZiwgIl9ETUlf
IiwgNSkgPT0gMCAmJiBkbWlfY2hlY2tzdW0oYnVmLCAxNSkpIHsKKwkJaW50IGk7CisKIAkJZG1p
X251bSA9IGdldF91bmFsaWduZWRfbGUxNihidWYgKyAxMik7CiAJCWRtaV9sZW4gPSBnZXRfdW5h
bGlnbmVkX2xlMTYoYnVmICsgNik7CiAJCWRtaV9iYXNlID0gZ2V0X3VuYWxpZ25lZF9sZTMyKGJ1
ZiArIDgpOwogCisJCXByX2VycigiPT09PT09IERlY29kaW5nIF9ETUlfIGhlYWRlcjpcbiIpOwor
CQlmb3IgKGkgPSAwOyBpIDwgMTY7IGkrKykKKwkJCXByX2NvbnQoIiUwMnggIiwgYnVmW2ldKTsK
KwkJcHJfY29udCgiXG4iKTsKKwogCQlpZiAoZG1pX3dhbGtfZWFybHkoZG1pX2RlY29kZSkgPT0g
MCkgewogCQkJaWYgKHNtYmlvc192ZXIpIHsKIAkJCQlkbWlfdmVyID0gc21iaW9zX3ZlcjsKQEAg
LTYxNyw3ICs2MzAsNyBAQCB2b2lkIF9faW5pdCBkbWlfc2Nhbl9tYWNoaW5lKHZvaWQpCiAJCW1l
bXNldChidWYsIDAsIDE2KTsKIAkJZm9yIChxID0gcDsgcSA8IHAgKyAweDEwMDAwOyBxICs9IDE2
KSB7CiAJCQltZW1jcHlfZnJvbWlvKGJ1ZiArIDE2LCBxLCAxNik7Ci0JCQlpZiAoIWRtaV9zbWJp
b3MzX3ByZXNlbnQoYnVmKSB8fCAhZG1pX3ByZXNlbnQoYnVmKSkgeworCQkJaWYgKC8qIWRtaV9z
bWJpb3MzX3ByZXNlbnQoYnVmKSB8fCovICFkbWlfcHJlc2VudChidWYpKSB7CiAJCQkJZG1pX2F2
YWlsYWJsZSA9IDE7CiAJCQkJZG1pX2Vhcmx5X3VubWFwKHAsIDB4MTAwMDApOwogCQkJCWdvdG8g
b3V0Owo=
--089e0122930ab392b90507411727--
