Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaKSGKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:10:32 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:63417 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaKSGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:10:28 -0500
MIME-Version: 1.0
Date: Wed, 19 Nov 2014 14:10:27 +0800
Message-ID: <CAJRGBZwxcZX88KZAs_a9HtBBo-EuxTvi7jONtpo=4DVv+i8n+w@mail.gmail.com>
Subject: [RFC patch] I don't want to play with 64bit MMIO in 32bit kernel
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pengyu Ma <pengyu.ma@windriver.com>
Content-Type: multipart/mixed; boundary=001a11c2633a71ab550508301148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2633a71ab550508301148
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi LKML

There is an on-going development in bugzilla for a patch to move on in
another direction for people who want to play with 64bits PCI BAR on
32bit.

https://bugzilla.kernel.org/show_bug.cgi?id=3D88131

But I send the patch out here to solicit comments for a sable way to
play with pci devices on modern 64bit machine which usually features
64bit BAR in a stable 32bit kernel.

The patch attached forced the BAR  memory resource allocation back to
32bit adress space in acpi root bridge case, then xhci and ixgbe works
every well based on my testing. So I think it's not necessary to use
64Bit BAR in 32bit kernel for stable reason.

Thanks /l

signed-off-by=EF=BC=9A  Luming Yu <luming.yu@intel.com>

--001a11c2633a71ab550508301148
Content-Type: application/octet-stream; name=z
Content-Disposition: attachment; filename=z
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2oahyfr0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9hY3BpLmMgYi9hcmNoL3g4Ni9wY2kvYWNwaS5jCmlu
ZGV4IGNmZDFiMTMuLjcyZTc0NjUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3BjaS9hY3BpLmMKKysr
IGIvYXJjaC94ODYvcGNpL2FjcGkuYwpAQCAtMjUxLDcgKzI1MSw5IEBAIHN0YXRpYyBhY3BpX3N0
YXR1cyByZXNvdXJjZV90b19hZGRyKHN0cnVjdCBhY3BpX3Jlc291cmNlICpyZXNvdXJjZSwKIAkJ
cmV0dXJuIEFFX09LOwogCWNhc2UgQUNQSV9SRVNPVVJDRV9UWVBFX0FERFJFU1MxNjoKIAljYXNl
IEFDUElfUkVTT1VSQ0VfVFlQRV9BRERSRVNTMzI6CisjaWYgQklUU19QRVJfTE9ORyA9PSA2NAog
CWNhc2UgQUNQSV9SRVNPVVJDRV9UWVBFX0FERFJFU1M2NDoKKyNlbmRpZgogCQlzdGF0dXMgPSBh
Y3BpX3Jlc291cmNlX3RvX2FkZHJlc3M2NChyZXNvdXJjZSwgYWRkcik7CiAJCWlmIChBQ1BJX1NV
Q0NFU1Moc3RhdHVzKSAmJgogCQkgICAgKGFkZHItPnJlc291cmNlX3R5cGUgPT0gQUNQSV9NRU1P
UllfUkFOR0UgfHwKQEAgLTI1OSw2ICsyNjEsMTAgQEAgc3RhdGljIGFjcGlfc3RhdHVzIHJlc291
cmNlX3RvX2FkZHIoc3RydWN0IGFjcGlfcmVzb3VyY2UgKnJlc291cmNlLAogCQkgICAgYWRkci0+
YWRkcmVzc19sZW5ndGggPiAwKSB7CiAJCQlyZXR1cm4gQUVfT0s7CiAJCX0KKyNpZiBCSVRTX1BF
Ul9MT05HID09IDMyCisJY2FzZSBBQ1BJX1JFU09VUkNFX1RZUEVfQUREUkVTUzY0OgorCS8qIFdl
IGRvbid0IHdhbnQgdG8gcGxheSB3aXRoIDY0IGJpdHMgbW1pbyBvbiB4ODYtMzJiaXQgKi8KKyNl
bmRpZgogCQlicmVhazsKIAl9CiAJcmV0dXJuIEFFX0VSUk9SOwo=
--001a11c2633a71ab550508301148--
