Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3CFWoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:44:03 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:45525 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3CFWoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:44:02 -0500
MIME-Version: 1.0
In-Reply-To: <5137C2C7.3020302@linux.intel.com>
References: <20130306100743.GA407@polaris.bitmath.org>
	<CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
	<20130306193612.GA513@polaris.bitmath.org>
	<51379A4F.4020200@linux.intel.com>
	<20130306195457.GA449@polaris.bitmath.org>
	<CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
	<20130306204500.GA335@polaris.bitmath.org>
	<5137AE06.8060200@linux.intel.com>
	<CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
	<5137B9DB.6000605@linux.intel.com>
	<20130306220412.GA1064@polaris.bitmath.org>
	<5137C2C7.3020302@linux.intel.com>
Date: Wed, 6 Mar 2013 14:44:01 -0800
X-Google-Sender-Auth: -M96B2tQEWhO3Dih0P356Vls4nw
Message-ID: <CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9340e5b8dde7c04d74953dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340e5b8dde7c04d74953dd
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Mar 6, 2013 at 2:27 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/06/2013 02:04 PM, Henrik Rydberg wrote:
>>>
>>> Sigh.  This is why "keep the page tables together" is fundamentally the
>>> wrong strategy.
>>>
>>> 8M means that we won't even be able to boot on machines with less than
>>> 16M or so of RAM... I'm not sure if anyone still cares, but that is a
>>> pretty aggressive heuristic.
>>
>> Maybe this should be a config option, given the ad-hoc nature of the
>> chosen value? Anyway, the patch works.
>>
>
> Can we make a sensible argument for what the value *needs* to be?  2M at
> least makes a modicum of sense.  Either way, it's clear we still have
> plenty of cleaning up to do...

ok, let's stay with 2M.

Please check attached v1 with updated commit log.

Thanks

Yinghai

--14dae9340e5b8dde7c04d74953dd
Content-Type: application/octet-stream; name="fix_real_end_v1.patch"
Content-Disposition: attachment; filename="fix_real_end_v1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdz2pq930

U3ViamVjdDogW1BBVENIXSB4ODYsIG1tOiBGaXJzdCBtYXBwZWQgYXJlYSBuZWVkIHRvIGJlIDJN
IGZvciBzdXJlLgoKSGVucmlrIHJlcG9ydGVkIHRoYXQgaGlzIE1hY0FpciAzLjEgd291bGQgbm90
IGJvb3Qgd2l0aAoKfCBjb21taXQgOGQ1NzQ3MGQ4Zjg1OTYzNWRlZmZlMzkxOWQ3ZDQ4NjdiNDg4
Yjg1YQp8IERhdGU6ICAgRnJpIE5vdiAxNiAxOTozODo1OCAyMDEyIC0wODAwCnwKfCAgICB4ODYs
IG1tOiBzZXR1cCBwYWdlIHRhYmxlIGluIHRvcC1kb3duCgpJdCB0dXJucyBvdXQgdGhhdCB3ZSBk
byBub3QgY2FsY3VsYXRlIHRoZSByZWFsX2VuZCBwcm9wZXJseToKV2UgdHJ5IHRvIGdldCAyTSBz
aXplIHdpdGggNEsgYWxpZ25tZW50LCBhbmQgbGF0ZXIgd2lsbCByb3VuZCBkb3duCnRvIDJNLCBz
byB3ZSB3aWxsIGdldCBsZXNzIHRoZW4gMk0gZm9yIGZpcnN0IG1hcHBpbmcsIGluIGV4dHJlbWUK
Y2FzZSBjb3VsZCBiZSBvbmx5IDRLIG9ubHkuIEluIEhlbnJpaydzIHN5c3RlbSBpdCBoYXMgKDFN
LTMySykgYXMKbGFzdCB1c2FibGUgcmFnZSBpcyBbbWVtIDB4N2Y5ZGIwMDAtMHg3ZmVmOGZmZl0u
CgpUaGUgcHJvYmxlbSBpcyBleHBvc2VkIHdoZW4gRUZJIGJvb3RpbmcgaGF2ZSBzZXZlcmFsIGhv
bGVzIGFuZCBpdAp3aWxsIGZvcmNlIG1hcHBpbmcgdG8gdXNlIFBURSBpbnN0ZWFkIGFzIHdlIG9u
bHkgbWFwIHVzYWJsZSBhcmVhcy4KClRvIGZpeCBpdCwganVzdCBtYWtlIGl0IGJlIDJNIGFsaWdu
ZWQuCgpSZXBvcnRlZC1ieTogSGVucmlrIFJ5ZGJlcmcgPHJ5ZGJlcmdAZXVyb21haWwuc2U+CkJp
c2VjdGVkLWJ5OiBIZW5yaWsgUnlkYmVyZyA8cnlkYmVyZ0BldXJvbWFpbC5zZT4KVGVzdGVkLWJ5
OiBIZW5yaWsgUnlkYmVyZyA8cnlkYmVyZ0BldXJvbWFpbC5zZT4KU2lnbmVkLW9mZi1ieTogWWlu
Z2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9tbS9pbml0LmMgfCAg
ICA1ICsrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0LmMKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGlu
dXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0v
aW5pdC5jCkBAIC00MTAsOSArNDEwLDggQEAgdm9pZCBfX2luaXQgaW5pdF9tZW1fbWFwcGluZyh2
b2lkKQogCS8qIHRoZSBJU0EgcmFuZ2UgaXMgYWx3YXlzIG1hcHBlZCByZWdhcmRsZXNzIG9mIG1l
bW9yeSBob2xlcyAqLwogCWluaXRfbWVtb3J5X21hcHBpbmcoMCwgSVNBX0VORF9BRERSRVNTKTsK
IAotCS8qIHhlbiBoYXMgYmlnIHJhbmdlIGluIHJlc2VydmVkIG5lYXIgZW5kIG9mIHJhbSwgc2tp
cCBpdCBhdCBmaXJzdCAqLwotCWFkZHIgPSBtZW1ibG9ja19maW5kX2luX3JhbmdlKElTQV9FTkRf
QUREUkVTUywgZW5kLCBQTURfU0laRSwKLQkJCSBQQUdFX1NJWkUpOworCS8qIHhlbiBoYXMgYmln
IHJhbmdlIGluIHJlc2VydmVkIG5lYXIgZW5kIG9mIHJhbSwgc2tpcCBpdCBhdCBmaXJzdC4qLwor
CWFkZHIgPSBtZW1ibG9ja19maW5kX2luX3JhbmdlKElTQV9FTkRfQUREUkVTUywgZW5kLCBQTURf
U0laRSwgUE1EX1NJWkUpOwogCXJlYWxfZW5kID0gYWRkciArIFBNRF9TSVpFOwogCiAJLyogc3Rl
cF9zaXplIG5lZWQgdG8gYmUgc21hbGwgc28gcGd0X2J1ZiBmcm9tIEJSSyBjb3VsZCBjb3ZlciBp
dCAqLwo=
--14dae9340e5b8dde7c04d74953dd--
