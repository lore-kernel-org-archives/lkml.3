Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3ASWEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 17:04:25 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:46516 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3ASWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 17:04:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyd032g4CYQfS8Woz+qZHvXAQa3s_cj7TOC=XVO1-HONw@mail.gmail.com>
References: <CAFLxGvyd032g4CYQfS8Woz+qZHvXAQa3s_cj7TOC=XVO1-HONw@mail.gmail.com>
Date: Sat, 19 Jan 2013 14:04:23 -0800
X-Google-Sender-Auth: Ohx84PsxWXMQCM0oV30dNzPSLaw
Message-ID: <CAE9FiQUQo2LOE=kmgQd_6A9YpkVzUZdS+MZYLzqg=SVc52LfUw@mail.gmail.com>
Subject: Re: Linux detects only 2.6GiB RAM in legacy boot
From: Yinghai Lu <yinghai@kernel.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae93406f32bac4804d3ab6962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93406f32bac4804d3ab6962
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Jan 19, 2013 at 10:43 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> Hi,
>
> My shiny new Thinkpad T430u comes with UEFI.
> To avoid broken bootloaders/distros I've enabled legacy boot mode.
>
> But Linux seems to detect only 2.6GB of RAM.
> [    0.000000] On node 0 totalpages: 1008669
> vs.
> [    0.000000] On node 0 totalpages: 701239
>
> Both dmesg logs are attached.
> This happens also with 3.7.x.
>
> Is there anything I can do or is this a plain UEFI/BIOS bug?

looks like BIOS problem:

UEFI one:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008f465fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008f466000-0x000000008f667fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f668000-0x00000000d829efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d829f000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011e5fffff] usable

legacy one:

[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008cfaafff] usable
[    0.000000] BIOS-e820: [mem 0x000000008cfab000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011e5fffff] usable

So difference:

[    0.000000] BIOS-e820: [mem 0x000000008f466000-0x000000008f667fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f668000-0x00000000d829efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d829f000-0x00000000dae9efff] reserved

to

[    0.000000] BIOS-e820: [mem 0x000000008cfab000-0x00000000dae9efff] reserved

at least about 1G get lost in e820.

Can you please apply attached patch to see the raw e820?

Thanks

Yinghai

--14dae93406f32bac4804d3ab6962
Content-Type: application/octet-stream; name="print_raw_e820.patch"
Content-Disposition: attachment; filename="print_raw_e820.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc5b1fmb2

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
--14dae93406f32bac4804d3ab6962--
