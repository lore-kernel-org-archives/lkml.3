Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3APHMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:12:00 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51645 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3APHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <50F606A8.2080804@palosanto.com>
References: <50F606A8.2080804@palosanto.com>
Date: Tue, 15 Jan 2013 23:11:57 -0800
X-Google-Sender-Auth: 5Xbk9PzemIrRBYHCn4dwsW-22jo
Message-ID: <CAE9FiQXg29gdrC8RK0Z8vLexju3yNpu9MvJcYHUoPnCNceSWkw@mail.gmail.com>
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range - is
 this safe?
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015173fe8fe0b320d04d362985e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015173fe8fe0b320d04d362985e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 5:47 PM, Alex Villac=EDs Lasso
<a_villacis@palosanto.com> wrote:
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff] usa=
ble
> [    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACP=
I
> NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACP=
I
> data
> [    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
> reserved
> [    0.000000] NX (Execute Disable) protection: active
..
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 4GB, range: 512MB, type WB
> [    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
> [    0.000000] reg 2, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 3, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 4, base: 3GB, range: 256MB, type WB
> [    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
> [    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
> [    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
> [    0.000000] total RAM covered: 4086M

Can you apply attached debug patch to see if the raw e820 is right from BIO=
S ?

Yinghai

--0015173fe8fe0b320d04d362985e
Content-Type: application/octet-stream; name="print_raw_e820.patch"
Content-Disposition: attachment; filename="print_raw_e820.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc04q09e0

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAxOSArKysrKysrKysrKysrLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCkluZGV4OiBs
aW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
b3JpZy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVs
L2U4MjAuYwpAQCAtMTU1LDIwICsxNTUsMjQgQEAgc3RhdGljIHZvaWQgX19pbml0IGU4MjBfcHJp
bnRfdHlwZSh1MzIgdAogCX0KIH0KIAotdm9pZCBfX2luaXQgZTgyMF9wcmludF9tYXAoY2hhciAq
d2hvKQorc3RhdGljIHZvaWQgX19pbml0IF9fZTgyMF9wcmludF9tYXAoc3RydWN0IGU4MjBlbnRy
eSAqbWFwLCBpbnQgbnJfbWFwLCBjaGFyICp3aG8pCiB7CiAJaW50IGk7CiAKLQlmb3IgKGkgPSAw
OyBpIDwgZTgyMC5ucl9tYXA7IGkrKykgeworCWZvciAoaSA9IDA7IGkgPCBucl9tYXA7IGkrKykg
ewogCQlwcmludGsoS0VSTl9JTkZPICIlczogW21lbSAlIzAxOEx4LSUjMDE4THhdICIsIHdobywK
LQkJICAgICAgICh1bnNpZ25lZCBsb25nIGxvbmcpIGU4MjAubWFwW2ldLmFkZHIsCisJCSAgICAg
ICAodW5zaWduZWQgbG9uZyBsb25nKSBtYXBbaV0uYWRkciwKIAkJICAgICAgICh1bnNpZ25lZCBs
b25nIGxvbmcpCi0JCSAgICAgICAoZTgyMC5tYXBbaV0uYWRkciArIGU4MjAubWFwW2ldLnNpemUg
LSAxKSk7Ci0JCWU4MjBfcHJpbnRfdHlwZShlODIwLm1hcFtpXS50eXBlKTsKKwkJICAgICAgICht
YXBbaV0uYWRkciArIG1hcFtpXS5zaXplIC0gMSkpOworCQllODIwX3ByaW50X3R5cGUobWFwW2ld
LnR5cGUpOwogCQlwcmludGsoS0VSTl9DT05UICJcbiIpOwogCX0KIH0KIAordm9pZCBfX2luaXQg
ZTgyMF9wcmludF9tYXAoY2hhciAqd2hvKQoreworCV9fZTgyMF9wcmludF9tYXAoZTgyMC5tYXAs
IGU4MjAubnJfbWFwLCB3aG8pOworfQogLyoKICAqIFNhbml0aXplIHRoZSBCSU9TIGU4MjAgbWFw
LgogICoKQEAgLTEwNzQsOSArMTA3OCwxMiBAQCB2b2lkIF9faW5pdCBzZXR1cF9tZW1vcnlfbWFw
KHZvaWQpCiB7CiAJY2hhciAqd2hvOwogCisJcHJpbnRrKEtFUk5fSU5GTyAiUGh5c2ljYWwgUkFN
IG1hcDpcbiIpOworCV9fZTgyMF9wcmludF9tYXAoYm9vdF9wYXJhbXMuZTgyMF9tYXAsIGJvb3Rf
cGFyYW1zLmU4MjBfZW50cmllcywgInJhdyIpOworCiAJd2hvID0geDg2X2luaXQucmVzb3VyY2Vz
Lm1lbW9yeV9zZXR1cCgpOwogCW1lbWNweSgmZTgyMF9zYXZlZCwgJmU4MjAsIHNpemVvZihzdHJ1
Y3QgZTgyMG1hcCkpOwotCXByaW50ayhLRVJOX0lORk8gImU4MjA6IEJJT1MtcHJvdmlkZWQgcGh5
c2ljYWwgUkFNIG1hcDpcbiIpOworCXByaW50ayhLRVJOX0lORk8gImU4MjA6IEJJT1MtcHJvdmlk
ZWQgcGh5c2ljYWwgUkFNIG1hcCAoc2FuaXRpemVkIGJ5IHNldHVwKTpcbiIpOwogCWU4MjBfcHJp
bnRfbWFwKHdobyk7CiB9CiAK
--0015173fe8fe0b320d04d362985e--
