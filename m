Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaFLNix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:38:53 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37992 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaFLNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:38:51 -0400
MIME-Version: 1.0
Date: Thu, 12 Jun 2014 14:38:49 +0100
Message-ID: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Handle non-secure L2C initialization on Exynos4
From: Daniel Drake <drake@endlessm.com>
To: t.figa@samsung.com
Cc: Kukjin Kim <kgene.kim@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: multipart/mixed; boundary=089e010d870c50d6f304fba3ae9b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e010d870c50d6f304fba3ae9b
Content-Type: text/plain; charset=UTF-8

Hi Tomasz,

Thanks for working on this!

I have just tried this, against Linus master
64b2d1fbbfda07765dae3f601862796a61b2c451.
Added patch "ARM: dts: Initial ODROID U2 support" and booted on
ODROID-U2. I believe this board has the security enabled.

Unfortunately, it hangs during early boot. With earlyprintk the last
messages seen are:

L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
L2C: platform provided aux values permit register corruption.
L2C: DT/platform modifies aux control register: 0x02070000 -> 0x3e470001
L2C-310 enabling early BRESP for Cortex-A9
L2C-310: enabling full line of zeros but not enabled in Cortex-A9
L2C-310 ID prefetch enabled, offset 1 lines
L2C-310 dynamic clock gating enabled, standby mode enabled
L2C-310 cache controller enabled, 16 ways, 1024 kB
L2C-310: CACHE_ID 0x4100c4c8, AUX_CTRL 0x7e470001

I then tried to go back to the earlier patch "ARM: EXYNOS: Add secure
firmware support for l2x0 init" (attached, needed a rebase) but that
one also now hangs at:

L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001

It did work on 3.14 though. Looking at the changelogs, many changes
have been made to l2x0 recently. Can you confirm that you have tested
your patches against a kernel with all of Russell King's recent
changes?

Thanks
Daniel

--089e010d870c50d6f304fba3ae9b
Content-Type: text/plain; charset=US-ASCII; 
	name="0001-ARM-EXYNOS-Add-secure-firmware-support-for-l2x0-init.txt"
Content-Disposition: attachment; 
	filename="0001-ARM-EXYNOS-Add-secure-firmware-support-for-l2x0-init.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwc42yce0

RnJvbSAyZTY3MjMxZjEwZWQwYjA1YzJiYWNmZGQwNTc3NGZlMjEzMTVkNmRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHdTEgPGd1MUBhZXJveHRlYW0uZnI+CkRhdGU6IE1vbiwgMjEg
SmFuIDIwMTMgMDQ6MTM6NTYgKzAxMDAKU3ViamVjdDogW1BBVENIXSBBUk06IEVYWU5PUzogQWRk
IHNlY3VyZSBmaXJtd2FyZSBzdXBwb3J0IGZvciBsMngwIGluaXQKCkNvbmZsaWN0czoKCWFyY2gv
YXJtL21tL2NhY2hlLWwyeDAuYwotLS0KIGFyY2gvYXJtL21hY2gtZXh5bm9zL2Zpcm13YXJlLmMg
fCAxOSArKysrKysrKysrKysrKysrKysrCiBhcmNoL2FybS9tbS9jYWNoZS1sMngwLmMgICAgICAg
IHwgIDMgKysrCiAyIGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9hcmNoL2FybS9tYWNoLWV4eW5vcy9maXJtd2FyZS5jIGIvYXJjaC9hcm0vbWFjaC1leHlub3Mv
ZmlybXdhcmUuYwppbmRleCBlYjkxZDIzLi5jMjAwZjc3IDEwMDY0NAotLS0gYS9hcmNoL2FybS9t
YWNoLWV4eW5vcy9maXJtd2FyZS5jCisrKyBiL2FyY2gvYXJtL21hY2gtZXh5bm9zL2Zpcm13YXJl
LmMKQEAgLTE2LDYgKzE2LDcgQEAKIAogI2luY2x1ZGUgPGFzbS9maXJtd2FyZS5oPgogCisjaW5j
bHVkZSA8YXNtL2hhcmR3YXJlL2NhY2hlLWwyeDAuaD4KICNpbmNsdWRlIDxtYWNoL21hcC5oPgog
CiAjaW5jbHVkZSAiY29tbW9uLmgiCkBAIC02NCwxMCArNjUsMjggQEAgc3RhdGljIGludCBleHlu
b3Nfc2V0X2NwdV9ib290X2FkZHIoaW50IGNwdSwgdW5zaWduZWQgbG9uZyBib290X2FkZHIpCiAJ
cmV0dXJuIDA7CiB9CiAKK2V4dGVybiBzdHJ1Y3QgbDJ4MF9yZWdzIGwyeDBfc2F2ZWRfcmVnczsK
KyNkZWZpbmUgTDJfQVVYX1ZBTCAweDdDNDcwMDAxCisjZGVmaW5lIEwyX0FVWF9NQVNLIDB4QzIw
MGZmZmYKKworc3RhdGljIGludCBleHlub3NfbDJ4MF9pbml0KHZvaWQpCit7CisJZXh5bm9zX3Nt
YyhTTUNfQ01EX0wyWDBTRVRVUDEsIGwyeDBfc2F2ZWRfcmVncy50YWdfbGF0ZW5jeSwKKwkJCWwy
eDBfc2F2ZWRfcmVncy5kYXRhX2xhdGVuY3ksCisJCQlsMngwX3NhdmVkX3JlZ3MucHJlZmV0Y2hf
Y3RybCk7CisJZXh5bm9zX3NtYyhTTUNfQ01EX0wyWDBTRVRVUDIsIGwyeDBfc2F2ZWRfcmVncy5w
d3JfY3RybCwKKwkJCUwyX0FVWF9WQUwsIEwyX0FVWF9NQVNLKTsKKwlleHlub3Nfc21jKFNNQ19D
TURfTDJYMElOVkFMTCwgMCwgMCwgMCk7CisJZXh5bm9zX3NtYyhTTUNfQ01EX0wyWDBDVFJMLCAx
LCAwLCAwKTsKKwlyZXR1cm4gMDsKK30KKworCiBzdGF0aWMgY29uc3Qgc3RydWN0IGZpcm13YXJl
X29wcyBleHlub3NfZmlybXdhcmVfb3BzID0gewogCS5kb19pZGxlCQk9IGV4eW5vc19kb19pZGxl
LAogCS5zZXRfY3B1X2Jvb3RfYWRkcgk9IGV4eW5vc19zZXRfY3B1X2Jvb3RfYWRkciwKIAkuY3B1
X2Jvb3QJCT0gZXh5bm9zX2NwdV9ib290LAorCS5sMngwX2luaXQJCT0gZXh5bm9zX2wyeDBfaW5p
dCwKIH07CiAKIHZvaWQgX19pbml0IGV4eW5vc19maXJtd2FyZV9pbml0KHZvaWQpCmRpZmYgLS1n
aXQgYS9hcmNoL2FybS9tbS9jYWNoZS1sMngwLmMgYi9hcmNoL2FybS9tbS9jYWNoZS1sMngwLmMK
aW5kZXggZWZjNWNhYi4uNzM2N2JlZiAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vbW0vY2FjaGUtbDJ4
MC5jCisrKyBiL2FyY2gvYXJtL21tL2NhY2hlLWwyeDAuYwpAQCAtMjksNiArMjksNyBAQAogI2lu
Y2x1ZGUgPGFzbS9jcDE1Lmg+CiAjaW5jbHVkZSA8YXNtL2NwdXR5cGUuaD4KICNpbmNsdWRlIDxh
c20vaGFyZHdhcmUvY2FjaGUtbDJ4MC5oPgorI2luY2x1ZGUgPGFzbS9maXJtd2FyZS5oPgogI2lu
Y2x1ZGUgImNhY2hlLXRhdXJvczMuaCIKICNpbmNsdWRlICJjYWNoZS1hdXJvcmEtbDIuaCIKIApA
QCAtMTUwNCw2ICsxNTA1LDggQEAgaW50IF9faW5pdCBsMngwX29mX2luaXQodTMyIGF1eF92YWws
IHUzMiBhdXhfbWFzaykKIAkJaWYgKGRhdGEtPm9mX3BhcnNlKQogCQkJZGF0YS0+b2ZfcGFyc2Uo
bnAsICZhdXhfdmFsLCAmYXV4X21hc2spOwogCisJY2FsbF9maXJtd2FyZV9vcChsMngwX2luaXQp
OworCiAJaWYgKGNhY2hlX2lkX3BhcnRfbnVtYmVyX2Zyb21fZHQpCiAJCWNhY2hlX2lkID0gY2Fj
aGVfaWRfcGFydF9udW1iZXJfZnJvbV9kdDsKIAllbHNlCi0tIAoxLjkuMQoK
--089e010d870c50d6f304fba3ae9b--
