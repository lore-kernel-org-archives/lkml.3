Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3ARX1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:27:30 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:55685 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3ARX13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:27:29 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUW_-3Bg9PSBoht0mqikVb1wn+21BNFy8Fsm5thZfNunXw@mail.gmail.com>
References: <CA+icZUV+ewSfwdGv+XjzVMF+V5d1t3r6MWGvoBgf08CN=KpBgQ@mail.gmail.com>
	<CA+icZUXNbhX4a0ZG039O5dWiZHpuVM-mwOSD_4g+f==xWD=4Zw@mail.gmail.com>
	<5156.1358549663@warthog.procyon.org.uk>
	<CA+icZUW_-3Bg9PSBoht0mqikVb1wn+21BNFy8Fsm5thZfNunXw@mail.gmail.com>
Date: Sat, 19 Jan 2013 00:27:27 +0100
Message-ID: <CA+icZUUjVdO9CBirU7j3kJbGGa6mRw2P46piZUpopqvPGzCU_A@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [MODSIGN: KEYS:]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: multipart/mixed; boundary=0016e68eebaf667daf04d398748b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e68eebaf667daf04d398748b
Content-Type: text/plain; charset=UTF-8

On Sat, Jan 19, 2013 at 12:04 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jan 18, 2013 at 11:54 PM, David Howells <dhowells@redhat.com> wrote:
>> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>>> Culprit seems to be...
>>>
>>> commit d6941c0c6bd42c725e45240a86c4add92e9bfb3e
>>> "KEYS: Separate the kernel signature checking keyring from module signing"
>>
>> Try updating.  I pushed a new version out today.  This is now at commit ID
>> c82af351e270e0d95059d09a1975b61494fbbcd7.
>>
>
> Thanks for the information!
>
> OK, I see... s/select/depends on...
>
>  +config SYSTEM_TRUSTED_KEYRING
>  +      bool "Provide system-wide ring of trusted keys"
> -+      select KEYS
> ++      depends on KEYS
>
> That should fix it :-).
> I set SYSTEM_TRUSTED_KEYRING=y in kernel-config.
>
> BAD: http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=d6941c0c6bd42c725e45240a86c4add92e9bfb3e
>
> GOOD: http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=patch;h=c82af351e270e0d95059d09a1975b61494fbbcd7
>

I tried to revert the bad commit and replace it with the good one, but
this seems to be more work.
So, I fixed it up like in the attached patch.

- Sedat -

> - Sedat -
>
>> David

--0016e68eebaf667daf04d398748b
Content-Type: application/octet-stream; 
	name="0001-KEYS-Fix-build-error-when-SYSTEM_TRUSTED_KEYRING-n.patch"
Content-Disposition: attachment; 
	filename="0001-KEYS-Fix-build-error-when-SYSTEM_TRUSTED_KEYRING-n.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc3ykiez0

RnJvbSAyZDc0NDU0OGVkMWNjNjhlOWVkM2YwOGFlZjE1MjllOTA0ZWIyODEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDE5IEphbiAyMDEzIDAwOjExOjQwICswMTAwClN1YmplY3Q6IFtQQVRDSF0gS0VZ
UzogRml4IGJ1aWxkLWVycm9yIHdoZW4gU1lTVEVNX1RSVVNURURfS0VZUklORz1uCgpXaGVuIFNZ
U1RFTV9UUlVTVEVEX0tFWVJJTkc9biBteSBidWlsZCBmYWlscyBsaWtlIHRoaXM6CgprZXJuZWwv
bW9kdWxlX3NpZ25pbmcuYzogSW4gZnVuY3Rpb24gJ3JlcXVlc3RfYXN5bW1ldHJpY19rZXknOgpr
ZXJuZWwvbW9kdWxlX3NpZ25pbmcuYzoxNjE6MzY6IGVycm9yOiAnc3lzdGVtX3RydXN0ZWRfa2V5
cmluZycgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pCmtlcm5lbC9tb2R1
bGVfc2lnbmluZy5jOjE2MTozNjogbm90ZTogZWFjaCB1bmRlY2xhcmVkIGlkZW50aWZpZXIgaXMg
cmVwb3J0ZWQgb25seSBvbmNlIGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4KCkZpeCB0
aGlzIGJ5IHJlcGxhY2luZyAic2VsZWN0IiB3aXRoICJkZXBlbmRzIG9uIiBLRVlTIEtjb25maWcu
CgpGb3IgbW9yZSBkZXRhaWxzIGZvbGxvdyB0aGUgdGhyZWFkIGluIFsxXS4KClsxXSBodHRwOi8v
bWFyYy5pbmZvLz90PTEzNTg1NDU0NTAwMDAwMSZyPTEmdz0yCgpUZXN0ZWQgYWdhaW5zdCBMaW51
eC1OZXh0IChuZXh0LTIwMTMwMTE4KS4KClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRh
dC5kaWxla0BnbWFpbC5jb20+Ci0tLQogaW5pdC9LY29uZmlnIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW5pdC9LY29u
ZmlnIGIvaW5pdC9LY29uZmlnCmluZGV4IGZiMjk1OWQuLmY3ZTFiMzIgMTAwNjQ0Ci0tLSBhL2lu
aXQvS2NvbmZpZworKysgYi9pbml0L0tjb25maWcKQEAgLTE2MDcsNyArMTYwNyw3IEBAIGNvbmZp
ZyBCQVNFX1NNQUxMCiAKIGNvbmZpZyBTWVNURU1fVFJVU1RFRF9LRVlSSU5HCiAJYm9vbCAiUHJv
dmlkZSBzeXN0ZW0td2lkZSByaW5nIG9mIHRydXN0ZWQga2V5cyIKLQlzZWxlY3QgS0VZUworCWRl
cGVuZHMgb24gS0VZUwogCWhlbHAKIAkgIFByb3ZpZGUgYSBzeXN0ZW0ga2V5cmluZyB0byB3aGlj
aCB0cnVzdGVkIGtleXMgY2FuIGJlIGFkZGVkLiAgS2V5cyBpbgogCSAgdGhlIGtleXJpbmcgYXJl
IGNvbnNpZGVyZWQgdG8gYmUgdHJ1c3RlZC4gIEtleXMgbWF5IGJlIGFkZGVkIGF0IHdpbGwKLS0g
CjEuOC4xLjEKCg==
--0016e68eebaf667daf04d398748b--
