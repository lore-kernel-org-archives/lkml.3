Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3DWVb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:31:58 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40604 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3DWVb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <5176F364.1080101@infradead.org>
References: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg>
	<alpine.DEB.2.00.1304232132050.11155@ayla.of.borg>
	<5176F364.1080101@infradead.org>
Date: Tue, 23 Apr 2013 14:31:56 -0700
X-Google-Sender-Auth: EQC2TAO0Syoi9vLUHA_DO6LqY48
Message-ID: <CA+55aFzKqVWCQjwGUNzU-Xy_pdK9KAFR11s+8wPrNQ4zHiXwgg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.9-rc8
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-cris-kernel@axis.com, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: multipart/mixed; boundary=089e0163406428629204db0deaa3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0163406428629204db0deaa3
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 23, 2013 at 1:47 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/23/13 12:35, Geert Uytterhoeven wrote:
>>   + error: "vm_iomap_memory" [drivers/video/fb.ko] undefined!:  => N/A
>>
>> bfin/BF537-STAMP_defconfig
>
>
> This is a result of the recent iomap changes (I think).
>
> Can Blackfin and others handle a change to FB that says:
>
>         depends on MMU

Hmm. I guess we can do a no-MMU vm_iomap_memory(). Without any of the
checks, since without a MMU none of them really matter. Something like
the appended.

Does anybody have an actual test-case?

                 Linus

--089e0163406428629204db0deaa3
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfvl9x8u0

IG1tL25vbW11LmMgfCAxMCArKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL21tL25vbW11LmMgYi9tbS9ub21tdS5jCmluZGV4IDJmM2VhNzQ5
YzMxOC4uZTAwMTc2OGIxNGU4IDEwMDY0NAotLS0gYS9tbS9ub21tdS5jCisrKyBiL21tL25vbW11
LmMKQEAgLTE4MzgsNiArMTgzOCwxNiBAQCBpbnQgcmVtYXBfcGZuX3JhbmdlKHN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hLCB1bnNpZ25lZCBsb25nIGFkZHIsCiB9CiBFWFBPUlRfU1lNQk9MKHJl
bWFwX3Bmbl9yYW5nZSk7CiAKK2ludCB2bV9pb21hcF9tZW1vcnkoc3RydWN0IHZtX2FyZWFfc3Ry
dWN0ICp2bWEsIHBoeXNfYWRkcl90IHN0YXJ0LCB1bnNpZ25lZCBsb25nIGxlbikKK3sKKwl1bnNp
Z25lZCBsb25nIHBmbiA9IHN0YXJ0ID4+IFBBR0VfU0hJRlQ7CisJdW5zaWduZWQgbG9uZyB2bV9s
ZW4gPSB2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQ7CisKKwlwZm4gKz0gdm1hLT52bV9wZ29m
ZjsKKwlyZXR1cm4gaW9fcmVtYXBfcGZuX3JhbmdlKHZtYSwgdm1hLT52bV9zdGFydCwgcGZuLCB2
bV9sZW4sIHZtYS0+dm1fcGFnZV9wcm90KTsKK30KK0VYUE9SVF9TWU1CT0wodm1faW9tYXBfbWVt
b3J5KTsKKwogaW50IHJlbWFwX3ZtYWxsb2NfcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2
bWEsIHZvaWQgKmFkZHIsCiAJCQl1bnNpZ25lZCBsb25nIHBnb2ZmKQogewo=
--089e0163406428629204db0deaa3--
