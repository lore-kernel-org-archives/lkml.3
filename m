Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3IXSpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3IXSpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:45:52 -0400
Date: Wed, 25 Sep 2013 00:15:38 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
In-Reply-To: <20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org>
Message-ID: <alpine.LFD.2.03.1309250015210.5312@erqung.pbz>
References: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz> <20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1091184577-675958421-1380048347=:5312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1091184577-675958421-1380048347=:5312
Content-Type: TEXT/PLAIN; charset=US-ASCII

   Hello Andrew,

Thank you so much for reviewing these patches.

+-- On Mon, 23 Sep 2013, Andrew Morton wrote --+
| A few things here.
| - the coding style is very unconventional.  We'd do it like this:
| 	if (!deco) {
| 		pr_emerg("Invalid decompression routine address: %p\n", deco);
| 		panic("Could not decompress initial ramdisk image.");
| 	}
 
   Done; Please see an updated new patch attached herein.
 

| - There isn't much point in printing the value of `deco' - we already
|   know it's NULL.

   True, I just thought displaying 'deco' would help the person seeing the 
panic screen. Maybe while reporting an issue or trying to debug it.

|   Isn't there some more useful message we can display
|   which will tell the user what he/she did wrong, and which explains
|   how to fix it?

   Yes, the message from 'decompress_method()' says which compression method 
is required, but is not defined. I've also added a hint to select appropriate 
config option.
 
| - Is anyone working on fixing up Kconfig/dracut(8) so the correct
|   decompression method is used?

   Yes, I plan to do that.


Thank you so much!
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
--1091184577-675958421-1380048347=:5312
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-Fix-NULL-pointer-dereference-while-loading-initramfs.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.03.1309250015100.5312@erqung.pbz>
Content-Description: 
Content-Disposition: attachment; filename=0001-Fix-NULL-pointer-dereference-while-loading-initramfs.patch

RnJvbSA4NDJkMzI4YmE1MmNiNTNlYzA1N2IwNzAzZmJjOGZiYzJhMmQ2ZjFh
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogUCBKIFAgPHByYXNh
ZEByZWRoYXQuY29tPg0KRGF0ZTogVHVlLCAyNCBTZXAgMjAxMyAyMzo1OToy
MSArMDUzMA0KU3ViamVjdDogW1BBVENIXSBGaXggTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIHdoaWxlIGxvYWRpbmcgaW5pdHJhbWZzDQoNCk1ha2UgbWVu
dWNvbmZpZyBhbGxvd3Mgb25lIHRvIGNob29zZSBjb21wcmVzc2lvbiBmb3Jt
YXQgb2YgYW4NCmluaXRpYWwgcmFtZGlzayBpbWFnZS4gQnV0IHRoaXMgY2hv
aWNlIGRvZXMgbm90IHJlc3VsdCBpbiBkdWx5DQpjb21wcmVzc2VkIGluaXRp
YWwgcmFtZGlzayBpbWFnZS4gQmVjYXVzZSAtICQgbWFrZSBpbnN0YWxsIC0g
ZG9lcw0Kbm90IHBhc3Mgb24gdGhlIHNlbGVjdGVkIGNvbXByZXNzaW9uIGNo
b2ljZSB0byB0aGUgZHJhY3V0KDgpIHRvb2wsDQp3aGljaCBjcmVhdGVzIHRo
ZSBpbml0cmFtZnMgZmlsZS4gZHJhY3V0KDgpIGdlbmVyYXRlcyB0aGUgaW1h
Z2UNCndpdGggdGhlIGRlZmF1bHQgY29tcHJlc3Npb24sIGllLiBnemlwKDEp
Lg0KDQpJZiBhIHVzZXIgY2hvc2UgYW55IG90aGVyIGNvbXByZXNzaW9uIGlu
c3RlYWQgb2YgZ3ppcCgxKSwgaXQgbGVhZHMNCnRvIGEgY3Jhc2ggZHVlIHRv
IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBjcmRfbG9hZCgpLCBjYXVz
ZWQgYnkNCmEgTlVMTCBmdW5jdGlvbiBwb2ludGVyIHJldHVybmVkIGJ5IHRo
ZSAnZGVjb21wcmVzc19tZXRob2QoKScgcm91dGluZS4NCkJlY2F1c2UgdGhl
IGluaXRyYW1mcyBpbWFnZSBpcyBnemlwKDEpIGNvbXByZXNzZWQsIHdoZXJl
YXMgdGhlIGtlcm5lbA0Ka25vd3Mgb25seSB0byBkZWNvbXByZXNzIHRoZSBj
aG9zZW4gZm9ybWF0IGFuZCBub3QgZ3ppcCgxKS4NCg0KVGhpcyBwYXRjaCBy
ZXBsYWNlcyB0aGUgY3Jhc2ggYnkgYW4gZXhwbGljaXQgcGFuaWMoKSBjYWxs
IHdpdGggYW4NCmFwcHJvcHJpYXRlIGVycm9yIG1lc3NhZ2UuIFRoaXMgc2hh
bGwgcHJldmVudCB0aGUga2VybmVsIGZyb20NCmV2ZW50dWFsbHkgcGFuaWNr
aW5nIGluOiBpbml0L2RvX21vdW50cy5jOiBtb3VudF9ibG9ja19yb290KCkg
d2l0aA0KICAtPiBwYW5pYygiVkZTOiBVbmFibGUgdG8gbW91bnQgcm9vdCBm
cyBvbiAlcyIsIGIpOw0KDQpTaWduZWQtb2ZmLWJ5OiBQIEogUCA8cHJhc2Fk
QHJlZGhhdC5jb20+DQoNCmRpZmYgLS1naXQgYS9pbml0L2RvX21vdW50c19y
ZC5jIGIvaW5pdC9kb19tb3VudHNfcmQuYw0KaW5kZXggNmJlMjg3OS4uYmRh
YTM0NSAxMDA2NDQNCi0tLSBhL2luaXQvZG9fbW91bnRzX3JkLmMNCisrKyBi
L2luaXQvZG9fbW91bnRzX3JkLmMNCkBAIC0zNDIsNiArMzQyLDEzIEBAIHN0
YXRpYyBpbnQgX19pbml0IGNyZF9sb2FkKGludCBpbl9mZCwgaW50IG91dF9m
ZCwgZGVjb21wcmVzc19mbiBkZWNvKQ0KIAlpbnQgcmVzdWx0Ow0KIAljcmRf
aW5mZCA9IGluX2ZkOw0KIAljcmRfb3V0ZmQgPSBvdXRfZmQ7DQorDQorCWlm
ICghZGVjbykgew0KKwkJcHJfZW1lcmcoIkludmFsaWQgZGVjb21wcmVzc2lv
biByb3V0aW5lOiAlcDsgIg0KKwkJCQkgIlNlbGVjdCBhcHByb3ByaWF0ZSBj
b25maWcgb3B0aW9uLlxuIiwgZGVjbyk7DQorCQlwYW5pYygiQ291bGQgbm90
IGRlY29tcHJlc3MgaW5pdGlhbCByYW1kaXNrIGltYWdlLiIpOw0KKwl9DQor
DQogCXJlc3VsdCA9IGRlY28oTlVMTCwgMCwgY29tcHJfZmlsbCwgY29tcHJf
Zmx1c2gsIE5VTEwsIE5VTEwsIGVycm9yKTsNCiAJaWYgKGRlY29tcHJlc3Nf
ZXJyb3IpDQogCQlyZXN1bHQgPSAxOw0KLS0gDQoxLjguMy4xDQoNCg==

--1091184577-675958421-1380048347=:5312--
