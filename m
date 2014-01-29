Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaA2XxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:53:14 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:52542 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA2XxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:53:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
	<CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
	<CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
Date: Wed, 29 Jan 2014 15:53:11 -0800
X-Google-Sender-Auth: 4rmk2XMTgL7QPPMxeBqR59G2EdE
Message-ID: <CAE9FiQX6CiumfOi2cgU1ODrKuaTHCZxo3zNmW01kn+GT1CAT3w@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec51a8946c3945d04f124a44f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51a8946c3945d04f124a44f
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 29, 2014 at 3:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Jan 29, 2014 at 3:07 PM, Tony Luck <tony.luck@gmail.com> wrote:
>> Hmmph.  ia64 is broken too.  git bisect says:
>>
>> commit ad6492b80f60a2139fa9bf8fd79b182fe5e3647c
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Mon Jan 27 17:06:49 2014 -0800
>>
>>     memblock, nobootmem: add memblock_virt_alloc_low()
>>
>> is to blame.  But this patch doesn't fix it.  Still dies with:
>>
>> PID hash table entries: 4096 (order: -1, 32768 bytes)
>> Sorting __ex_table...
>> kernel BUG at mm/bootmem.c:504!
>
> that's another path with memblock_virt wrapper for bootmem.

Please check attached patch.

Thanks

Yinghai

--bcaec51a8946c3945d04f124a44f
Content-Type: text/x-patch; charset=US-ASCII; name="fix_memblock_virt_alloc_ia64.patch"
Content-Disposition: attachment; 
	filename="fix_memblock_virt_alloc_ia64.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr193iau0

U3ViamVjdDogW1BBVENIXSBtZW1ibG9jaywgYm9vdG1lbTogUmVzdG9yZSBnb2FsIGZvciBhbGxv
Y19sb3cKCk5vdyB3ZSBoYXZlIG1lbWJsb2NrX3ZpcnRfYWxsb2NfbG93IHRvIHJlcGxhY2Ugb3Jp
Z2luYWwgYm9vdG1lbSBhcGkKaW4gc3dpb3RsYi4KCkJ1dCB3ZSBzaG91bGQgbm90IHVzZSBCT09U
TUVNX0xPV19MSU1JVCBmb3IgYXJjaCB0aGF0IGRvZXMgbm90IHN1cHBvcnQKQ09ORklHX05PQk9P
VE1FTSwgYXMgb2xkIGFwaSB0YWtlIDAuCgp8ICNkZWZpbmUgYWxsb2NfYm9vdG1lbV9sb3coeCkg
XAp8ICAgICAgICBfX2FsbG9jX2Jvb3RtZW1fbG93KHgsIFNNUF9DQUNIRV9CWVRFUywgMCkKfCNk
ZWZpbmUgYWxsb2NfYm9vdG1lbV9sb3dfcGFnZXNfbm9wYW5pYyh4KSBcCnwgICAgICAgIF9fYWxs
b2NfYm9vdG1lbV9sb3dfbm9wYW5pYyh4LCBQQUdFX1NJWkUsIDApCgphbmQgd2UgaGF2ZQogI2Rl
ZmluZSBCT09UTUVNX0xPV19MSU1JVCBfX3BhKE1BWF9ETUFfQUREUkVTUykKZm9yIENPTkZJR19O
T0JPT1RNRU0uCgpSZXN0b3JlIGdvYWwgdG8gMCB0byBmaXggaWE2NCBjcmFzaCwgdGhhdCBUb255
IGZvdW5kLgoKClJlcG9ydGVkLWJ5OiBUb255IEx1Y2sgPHRvbnkubHVja0BnbWFpbC5jb20+ClNp
Z25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogaW5jbHVk
ZS9saW51eC9ib290bWVtLmggfCAgICA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2luY2x1ZGUvbGludXgvYm9v
dG1lbS5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvYm9vdG1l
bS5oCisrKyBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9ib290bWVtLmgKQEAgLTI2NCw3ICsyNjQs
NyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgKiBfX2luaXQgbWVtYmxvY2tfdmlyCiB7CiAJaWYgKCFh
bGlnbikKIAkJYWxpZ24gPSBTTVBfQ0FDSEVfQllURVM7Ci0JcmV0dXJuIF9fYWxsb2NfYm9vdG1l
bV9sb3coc2l6ZSwgYWxpZ24sIEJPT1RNRU1fTE9XX0xJTUlUKTsKKwlyZXR1cm4gX19hbGxvY19i
b290bWVtX2xvdyhzaXplLCBhbGlnbiwgMCk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCAqIF9f
aW5pdCBtZW1ibG9ja192aXJ0X2FsbG9jX2xvd19ub3BhbmljKApAQCAtMjcyLDcgKzI3Miw3IEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCAqIF9faW5pdCBtZW1ibG9ja192aXIKIHsKIAlpZiAoIWFsaWdu
KQogCQlhbGlnbiA9IFNNUF9DQUNIRV9CWVRFUzsKLQlyZXR1cm4gX19hbGxvY19ib290bWVtX2xv
d19ub3BhbmljKHNpemUsIGFsaWduLCBCT09UTUVNX0xPV19MSU1JVCk7CisJcmV0dXJuIF9fYWxs
b2NfYm9vdG1lbV9sb3dfbm9wYW5pYyhzaXplLCBhbGlnbiwgMCk7CiB9CiAKIHN0YXRpYyBpbmxp
bmUgdm9pZCAqIF9faW5pdCBtZW1ibG9ja192aXJ0X2FsbG9jX2Zyb21fbm9wYW5pYygK
--bcaec51a8946c3945d04f124a44f--
