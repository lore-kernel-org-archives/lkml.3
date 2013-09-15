Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3IOJT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab3IOJTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:19:25 -0400
Date: Sun, 15 Sep 2013 14:49:05 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Export initial ramdisk compression config
Message-ID: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1091184577-1494639324-1379236756=:7830"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1091184577-1494639324-1379236756=:7830
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

   Hello,

While building the 3.11 kernel recently, I bumped into this issue.

Menuconfig allows one to choose compression format of an initial ramdisk 
image. But this selection does not result in creation of a duly compressed 
initramfs image. Because - $ make install - does not pass on the selected 
compression option to dracut(8) tool, which generates the initramfs file. This 
leads to a situation wherein the initramfs file is gzip(1) compressed, but the 
kernel knows only to decompress the user's chosen compression format.

The attached patch herein, attempts to fix this issue by exporting the 
compression configuration option to an environment variable of a sub-shell 
spawned by Make(1) with the invocation of installkernel(8) during the 
installation process.

The dracut(8) & new-kernel-pkg(8) tools need to be patched to recognise and 
read such an environment variable and use the selected compression algorithm 
while creating the initial ramdisk image files.

Could someone please review this one too?

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
--1091184577-1494639324-1379236756=:7830
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0002-Export-initial-ramdisk-compression-config-option.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.03.1309151449050.7830@erqung.pbz>
Content-Description: 
Content-Disposition: attachment; filename=0002-Export-initial-ramdisk-compression-config-option.patch

RnJvbSA4ODg3OGM3ZGZiMDRlNjliNzVmMTUxOGZlODA5YjkxNzA5NWEzM2I4
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogUCBKIFAgPHByYXNh
ZEByZWRoYXQuY29tPg0KRGF0ZTogU3VuLCAxNSBTZXAgMjAxMyAxMzozNzo0
MyArMDUzMA0KU3ViamVjdDogW1BBVENIIDIvMl0gRXhwb3J0IGluaXRpYWwg
cmFtZGlzayBjb21wcmVzc2lvbiBjb25maWcgb3B0aW9uDQoNCk1ha2UgbWVu
dWNvbmZpZyBhbGxvd3Mgb25lIHRvIGNob29zZSBjb21wcmVzc2lvbiBmb3Jt
YXQgb2YgYW4NCmluaXRpYWwgcmFtZGlzayBpbWFnZS4gQnV0IHRoaXMgY2hv
aWNlIGRvZXMgbm90IHJlc3VsdCBpbiBkdWx5DQpjb21wcmVzc2VkIHJhbWRp
c2sgaW1hZ2UuIEJlY2F1c2UgLSAkIG1ha2UgaW5zdGFsbCAtIGRvZXMgbm90
DQpwYXNzIG9uIHRoZSBzZWxlY3RlZCBjb21wcmVzc2lvbiBjaG9pY2UgdG8g
dGhlIGRyYWN1dCg4KSB0b29sLA0Kd2hpY2ggY3JlYXRlcyB0aGUgaW5pdHJh
bWZzIGZpbGUuIGRyYWN1dCg4KSBnZW5lcmF0ZXMgdGhlIGltYWdlDQp3aXRo
IHRoZSBkZWZhdWx0IGNvbXByZXNzaW9uLCBpZS4gZ3ppcCgxKS4NCg0KVGhp
cyBwYXRjaCBleHBvcnRzIHRoZSBzZWxlY3RlZCBjb21wcmVzc2lvbiBvcHRp
b24gdG8gYSBzdWItc2hlbGwNCmVudmlyb25tZW50LCBzbyB0aGF0IGl0IGNv
dWxkIGJlIHVzZWQgYnkgZHJhY3V0KDgpIHRvb2wgdG8gZ2VuZXJhdGUNCmFw
cHJvcHJpYXRlbHkgY29tcHJlc3NlZCBpbml0cmFtZnMgaW1hZ2VzLg0KDQpU
aGVyZSBpc24ndCBhIHN0cmFpZ2h0IGZvcndhcmQgd2F5IHRvIHBhc3Mgb24g
b3B0aW9ucyB0byBkcmFjdXQoOCkNCnZpYSBwb3NpdGlvbmFsIHBhcmFtZXRl
cnMuIEJlY2F1c2UgaXQgaXMgaW5kaXJlY3RseSBpbnZva2VkIGF0IHRoZQ0K
ZW5kIG9mIGEgJCBtYWtlIGluc3RhbGwgc2VxdWVuY2UuDQoNCiAjIG1ha2Ug
aW5zdGFsbA0KICAgLT4gYXJjaC8kYXJjaC9ib290L01ha2VmaWxlDQogICAg
LT4gYXJjaC8kYXJjaC9ib290L2luc3RhbGwuc2gNCiAgICAgLT4gL3NiaW5n
L2luc3RhbGxrZXJuZWwgLi4uDQogICAgICAtPiAvc2Jpbi9uZXcta2VybmVs
LXBrZyAuLi4NCiAgICAgICAtPiAvc2Jpbi9kcmFjdXQgLi4uDQoNClNpZ25l
ZC1vZmYtYnk6IFAgSiBQIDxwcmFzYWRAcmVkaGF0LmNvbT4NCg0KZGlmZiAt
LWdpdCBhL2FyY2gveDg2L01ha2VmaWxlIGIvYXJjaC94ODYvTWFrZWZpbGUN
CmluZGV4IDQxMjUwZmIuLjlmNGNkZjFkIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYvTWFrZWZpbGUNCisrKyBiL2FyY2gveDg2L01ha2VmaWxlDQpAQCAtMTEs
NiArMTEsMjMgQEAgZWxzZQ0KICAgICAgICAgS0JVSUxEX0RFRkNPTkZJRyA6
PSAkKEFSQ0gpX2RlZmNvbmZpZw0KIGVuZGlmDQogDQorIyBTZWxlY3QgaW5p
dGlhbCByYW1kaXNrIGNvbXByZXNzaW9uIGZvcm1hdCwgZGVmYXVsdCBpcyBn
emlwKDEpLg0KKyMgVGhpcyBzaGFsbCBiZSB1c2VkIGJ5IHRoZSBkcmFjdXQo
OCkgdG9vbCB3aGlsZSBjcmVhdGluZyBhbiBpbml0cmFtZnMgaW1hZ2UuDQor
Iw0KK0lOSVRSRF9DT01QUkVTUz1nemlwDQoraWZlcSAoJChDT05GSUdfUkRf
QlpJUDIpLCB5KQ0KKyAgICAgICAgSU5JVFJEX0NPTVBSRVNTPWJ6aXAyDQor
ZWxzZSBpZmVxICgkKENPTkZJR19SRF9MWk1BKSwgeSkNCisgICAgICAgIElO
SVRSRF9DT01QUkVTUz1sem1hDQorZWxzZSBpZmVxICgkKENPTkZJR19SRF9Y
WiksIHkpDQorICAgICAgICBJTklUUkRfQ09NUFJFU1M9eHoNCitlbHNlIGlm
ZXEgKCQoQ09ORklHX1JEX0xaTyksIHkpDQorICAgICAgICBJTklUUkRfQ09N
UFJFU1M9bHpvDQorZWxzZSBpZmVxICgkKENPTkZJR19SRF9MWjQpLCB5KQ0K
KyAgICAgICAgSU5JVFJEX0NPTVBSRVNTPWx6NA0KK2VuZGlmDQorZXhwb3J0
IElOSVRSRF9DT01QUkVTUw0KKw0KICMgQklUUyBpcyB1c2VkIGFzIGV4dGVu
c2lvbiBmb3IgZmlsZXMgd2hpY2ggYXJlIGF2YWlsYWJsZSBpbiBhIDMyIGJp
dA0KICMgYW5kIGEgNjQgYml0IHZlcnNpb24gdG8gc2ltcGxpZnkgc2hhcmVk
IE1ha2VmaWxlcy4NCiAjIGUuZy46IG9iai15ICs9IGZvb18kKEJJVFMpLm8N
CmRpZmYgLS1naXQgYS9pbml0L2RvX21vdW50c19yZC5jIGIvaW5pdC9kb19t
b3VudHNfcmQuYw0KaW5kZXggNzZmYWVjMS4uYjNkNmMzOCAxMDA2NDQNCi0t
LSBhL2luaXQvZG9fbW91bnRzX3JkLmMNCisrKyBiL2luaXQvZG9fbW91bnRz
X3JkLmMNCkBAIC01Nyw2ICs1NywxMSBAQCBzdGF0aWMgaW50IF9faW5pdCBj
cmRfbG9hZChpbnQgaW5fZmQsIGludCBvdXRfZmQsIGRlY29tcHJlc3NfZm4g
ZGVjbyk7DQogICoJY3JhbWZzDQogICoJc3F1YXNoZnMNCiAgKglnemlwDQor
ICoJYnppcDINCisgKglsem1hDQorICoJeHoNCisgKglsem8NCisgKglsejQN
CiAgKi8NCiBzdGF0aWMgaW50IF9faW5pdA0KIGlkZW50aWZ5X3JhbWRpc2tf
aW1hZ2UoaW50IGZkLCBpbnQgc3RhcnRfYmxvY2ssIGRlY29tcHJlc3NfZm4g
KmRlY29tcHJlc3NvcikNCi0tIA0KMS44LjMuMQ0KDQo=

--1091184577-1494639324-1379236756=:7830--
