Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3IOJEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3IOJEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:04:15 -0400
Date: Sun, 15 Sep 2013 14:33:53 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix NULL pointer dereference while loading initramfs 
Message-ID: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1091184577-768094632-1379235849=:7830"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1091184577-768094632-1379235849=:7830
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

   Hello,

While building the 3.11 kernel recently, I bumped into this issue.

Menuconfig allows one to choose compression format of an initial ramdisk 
image. If we select any compression other than the default gzip(1), it leads 
to a NULL pointer dereference while loading the initramfs image, at boot up.

Because - $ make install - does not pass on the selected compression format to 
dracut(8) tool, it generates the initramfs file compressed with the default 
gzip(1) format. But the kernel knows only to decompress the chosen format.

The attached patch herein, replaces the crash by an explicit panic() call with 
an appropriate error message. It keeps the kernel from eventually panicking in 
init/do_mounts.c: mount_root_block() with an inaccurate error message and 
which also looses the earlier printk output that hints about the missing 
gzip(1) decompression support.
   -> panic("VFS: Unable to mount root fs on %s", b);

Could someone please review this patch?

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
--1091184577-768094632-1379235849=:7830
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-NULL-pointer-dereference-while-loading-initramfs.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.03.1309151430580.7830@erqung.pbz>
Content-Description: 
Content-Disposition: attachment; filename=0001-NULL-pointer-dereference-while-loading-initramfs.patch

RnJvbSA0ZmYxZGRhZTM1OGRmZjAwMjA4MGQ3NTNlNDU3MjFhODlkMDdiM2Fm
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogUCBKIFAgPHByYXNh
ZEByZWRoYXQuY29tPg0KRGF0ZTogU3VuLCAxNSBTZXAgMjAxMyAxMzowMzox
NyArMDUzMA0KU3ViamVjdDogW1BBVENIIDEvMl0gTlVMTCBwb2ludGVyIGRl
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
YXMgdGhlIGtlcm5lbA0Ka25vd3MgaG93IGRlY29tcHJlc3MgdGhlIGNob3Nl
biBmb3JtYXQgYW5kIG5vdCBnemlwKDEpLg0KDQpUaGlzIHBhdGNoIHJlcGxh
Y2VzIHRoZSBjcmFzaCBieSBhbiBleHBsaWNpdCBwYW5pYygpIGNhbGwgd2l0
aCBhbg0KYXBwcm9wcmlhdGUgZXJyb3IgbWVzc2FnZS4gVGhpcyBzaGFsbCBw
cmV2ZW50IHRoZSBrZXJuZWwgZnJvbQ0KZXZlbnR1YWxseSBwYW5pY2tpbmcg
aW46IGluaXQvZG9fbW91bnRzLmM6IG1vdW50X2Jsb2NrX3Jvb3QoKSB3aXRo
DQogIC0+IHBhbmljKCJWRlM6IFVuYWJsZSB0byBtb3VudCByb290IGZzIG9u
ICVzIiwgYik7DQoNClNpZ25lZC1vZmYtYnk6IFAgSiBQIDxwcmFzYWRAcmVk
aGF0LmNvbT4NCg0KZGlmZiAtLWdpdCBhL2luaXQvZG9fbW91bnRzX3JkLmMg
Yi9pbml0L2RvX21vdW50c19yZC5jDQppbmRleCA2YmUyODc5Li43NmZhZWMx
IDEwMDY0NA0KLS0tIGEvaW5pdC9kb19tb3VudHNfcmQuYw0KKysrIGIvaW5p
dC9kb19tb3VudHNfcmQuYw0KQEAgLTM0Miw2ICszNDIsMTMgQEAgc3RhdGlj
IGludCBfX2luaXQgY3JkX2xvYWQoaW50IGluX2ZkLCBpbnQgb3V0X2ZkLCBk
ZWNvbXByZXNzX2ZuIGRlY28pDQogCWludCByZXN1bHQ7DQogCWNyZF9pbmZk
ID0gaW5fZmQ7DQogCWNyZF9vdXRmZCA9IG91dF9mZDsNCisNCisgICAgaWYg
KCFkZWNvKQ0KKyAgICB7DQorICAgICAgICBwcmludGsoS0VSTl9FTUVSRyAi
SW52YWxpZCBkZWNvbXByZXNzaW9uIHJvdXRpbmUgYWRkcmVzczogJXBcbiIs
IGRlY28pOw0KKyAgICAgICAgcGFuaWMoIkNvdWxkIG5vdCBkZWNvbXByZXNz
IGluaXRpYWwgcmFtZGlzayBpbWFnZS4iKTsNCisgICAgfQ0KKw0KIAlyZXN1
bHQgPSBkZWNvKE5VTEwsIDAsIGNvbXByX2ZpbGwsIGNvbXByX2ZsdXNoLCBO
VUxMLCBOVUxMLCBlcnJvcik7DQogCWlmIChkZWNvbXByZXNzX2Vycm9yKQ0K
IAkJcmVzdWx0ID0gMTsNCi0tIA0KMS44LjMuMQ0KDQo=

--1091184577-768094632-1379235849=:7830--
