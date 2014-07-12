Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaGLWSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:18:20 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:35966 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaGLWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgf0jfUVCycZBWMB4X5NobVqn7vU_6eh-9vi3LbzDZ=bQ@mail.gmail.com>
References: <CAPDOMVgf0jfUVCycZBWMB4X5NobVqn7vU_6eh-9vi3LbzDZ=bQ@mail.gmail.com>
Date: Sat, 12 Jul 2014 18:18:18 -0400
Message-ID: <CAPDOMVgOHAs93VFUWFn3jQ3zJ0BWf2QDNQiFsggf+YJbof55jg@mail.gmail.com>
Subject: Re: Blackfin Build fixs
From: Nick Krause <xerofoify@gmail.com>
To: Miao Steven <realmz6@gmail.com>, adi-buildroot-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e011618ce59c66c04fe066f19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e011618ce59c66c04fe066f19
Content-Type: text/plain; charset=UTF-8

On Fri, Jul 11, 2014 at 12:18 PM, Nick Krause <xerofoify@gmail.com> wrote:
> Hey Steven,
> I having been testing what builds are still failing from Steven
> Rothwell's tests and there seem to be two failing
> still for blackfin. I am tracing the issues to make it easier for you
> as a maintainer.  BF561-ACVILON_defconfig
> is failing in acvlion.c due to BFIN_NAND_PLAT_READY not being defined
> when calling gpio request in
> bfin_plat_nand_init. I would recommend defining it to the correct
> value to initialize nand on this board.
> There also seems to be some undefined syscalls for this board I would
> can either remove them or you can
> tell me how to clean them up.
>
> I also am hitting a build failure still for blackstamp defconfig. The
> issue seems to be that when calling functions
> that need GPIO_PF0 that it's undefined as it fails whenc calling
> gpio_request that needs it be defined on line 318
> of file , arch/blackfin/mach-bf533/boards/blackstamp.c on line 480 and
> again on line 481 when calling gpio_free.
> Like the other build there seems to be undefined syscalls and they
> need to be either removed or cleaned up. I
> would like recommendations or how you want to clean up these system calls.
>
> I am also attaching the log files for these failing builds.
>
> Cheers Nick
Sorry about my grammar. I attached the same file twice. I will attach
my build log for Blackstamp
defconfig.
Cheers Nick

--089e011618ce59c66c04fe066f19
Content-Type: application/octet-stream; name=Blackstamp_defconfig
Content-Disposition: attachment; filename=Blackstamp_defconfig
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxjhvnek2

PHN0ZGluPjoxMjIzOjI6IHdhcm5pbmc6ICN3YXJuaW5nIHN5c2NhbGwga2NtcCBub3QgaW1wbGVt
ZW50ZWQgWy1XY3BwXQo8c3RkaW4+OjEyMjY6Mjogd2FybmluZzogI3dhcm5pbmcgc3lzY2FsbCBm
aW5pdF9tb2R1bGUgbm90IGltcGxlbWVudGVkIFstV2NwcF0KPHN0ZGluPjoxMjI5OjI6IHdhcm5p
bmc6ICN3YXJuaW5nIHN5c2NhbGwgc2NoZWRfc2V0YXR0ciBub3QgaW1wbGVtZW50ZWQgWy1XY3Bw
XQo8c3RkaW4+OjEyMzI6Mjogd2FybmluZzogI3dhcm5pbmcgc3lzY2FsbCBzY2hlZF9nZXRhdHRy
IG5vdCBpbXBsZW1lbnRlZCBbLVdjcHBdCjxzdGRpbj46MTIzNToyOiB3YXJuaW5nOiAjd2Fybmlu
ZyBzeXNjYWxsIHJlbmFtZWF0MiBub3QgaW1wbGVtZW50ZWQgWy1XY3BwXQphcmNoL2JsYWNrZmlu
L21hY2gtYmY1MzMvYm9hcmRzL2JsYWNrc3RhbXAuYzogSW4gZnVuY3Rpb24g4oCYYmxhY2tzdGFt
cF9pbml04oCZOgphcmNoL2JsYWNrZmluL21hY2gtYmY1MzMvYm9hcmRzL2JsYWNrc3RhbXAuYzo0
Nzg6MjogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmGdwaW9fcmVx
dWVzdOKAmSBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0KICByZXQgPSBn
cGlvX3JlcXVlc3QoR1BJT19QRjAsICJlbmV0X2NwbGQiKTsKICBeCmFyY2gvYmxhY2tmaW4vbWFj
aC1iZjUzMy9ib2FyZHMvYmxhY2tzdGFtcC5jOjQ4MDozOiBlcnJvcjogaW1wbGljaXQgZGVjbGFy
YXRpb24gb2YgZnVuY3Rpb24g4oCYZ3Bpb19kaXJlY3Rpb25fb3V0cHV04oCZIFstV2Vycm9yPWlt
cGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQogICBncGlvX2RpcmVjdGlvbl9vdXRwdXQoR1BJ
T19QRjAsIDEpOwogICBeCmFyY2gvYmxhY2tmaW4vbWFjaC1iZjUzMy9ib2FyZHMvYmxhY2tzdGFt
cC5jOjQ4MTozOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYZ3Bp
b19mcmVl4oCZIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQogICBncGlv
X2ZyZWUoR1BJT19QRjApOwogICBeCmNjMTogc29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFz
IGVycm9ycwptYWtlWzFdOiAqKiogW2FyY2gvYmxhY2tmaW4vbWFjaC1iZjUzMy9ib2FyZHMvYmxh
Y2tzdGFtcC5vXSBFcnJvciAxCm1ha2U6ICoqKiBbYXJjaC9ibGFja2Zpbi9tYWNoLWJmNTMzL2Jv
YXJkc10gRXJyb3IgMgptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLgo=
--089e011618ce59c66c04fe066f19--
