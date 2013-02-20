Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3BTSMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:12:24 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64746 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab3BTSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:12:19 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 10:12:18 -0800
Message-ID: <CAMe9rOrE4okBffqCE0mAK_ogc76Ty12OvBJGy69kLebGGXmM=Q@mail.gmail.com>
Subject: [PATCH] DMI: Always call dmi_present with DMI structure
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Content-Type: multipart/mixed; boundary=e89a8ff1c56a186c6b04d62be6ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1c56a186c6b04d62be6ba
Content-Type: text/plain; charset=ISO-8859-1

Hi,

This patch:

commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377
Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Date:   Thu Dec 20 15:05:14 2012 -0800

    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

    The right dmi version is in SMBIOS if it's zero in DMI region

    This issue was originally found from an oracle bug.
    One customer noticed system UUID doesn't match between dmidecode & uek2.

     - HP ProLiant BL460c G6 :
       # cat /sys/devices/virtual/dmi/id/product_uuid
       00000000-0000-4C48-3031-4D5030333531
       # dmidecode | grep -i uuid    drivers/firmware/dmi_scan.c:
fetch dmi version from SMBIOS if it exists

    The right dmi version is in SMBIOS if it's zero in DMI region

    This issue was originally found from an oracle bug.
    One customer noticed system UUID doesn't match between dmidecode & uek2.

     - HP ProLiant BL460c G6 :
       # cat /sys/devices/virtual/dmi/id/product_uuid
       00000000-0000-4C48-3031-4D5030333531
       # dmidecode | grep -i uuid
       UUID: 00000000-0000-484C-3031-4D5030333531

    From SMBIOS 2.6 on, spec use little-endian encoding for UUID other than
    network byte order.

    So we need to get dmi version to distinguish.  If version is 0.0, the
    real version is taken from the SMBIOS version.  This is part of original
    kernel comment in code.

       UUID: 00000000-0000-484C-3031-4D5030333531

    From SMBIOS 2.6 on, spec use little-endian encoding for UUID other than
    network byte order.

    So we need to get dmi version to distinguish.  If version is 0.0, the
    real version is taken from the SMBIOS version.  This is part of original
    kernel comment in code.

causes a regression in 3.7, 3.8 and 3.9 kernels.   Before the change,
we only scan DMI structure.  Now smbios_present scans SMBIOS
entry point.  I have a machine which has invalid checksum in
SMBIOS entry point.  We wind up calling dmi_present with SMBIOS
entry point instead of DMI structure.  This patch changes smbios_present
to always call dmi_present with DMI structure.


-- 
H.J.

--e89a8ff1c56a186c6b04d62be6ba
Content-Type: application/octet-stream; 
	name="0001-DMI-Always-call-dmi_present-with-DMI-structure.patch"
Content-Disposition: attachment; 
	filename="0001-DMI-Always-call-dmi_present-with-DMI-structure.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdesm1o70

RnJvbSA5ZGUzNzY5NTQzYmQzNWI3NWQ4YTRjNTQ5YTIzYWE2MWFiYzM3MDVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiSC5KLiBMdSIgPGhqbC50b29sc0BnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMjAgRmViIDIwMTMgMTA6MDA6MDYgLTA4MDAKU3ViamVjdDogW1BBVENIXSBETUk6IEFs
d2F5cyBjYWxsIGRtaV9wcmVzZW50IHdpdGggRE1JIHN0cnVjdHVyZQoKSWYgU01CSU9TIGVudHJ5
IHBvaW50IGhhcyBpbnZhbGlkIGNoZWNrc3VtLCBzbWJpb3NfcHJlc2VudCB3aWxsIGNhbGwKZG1p
X3ByZXNlbnQgd2l0aCB3cm9uZyBvZmZzZXQgb2YgRE1JIHN0cnVjdHVyZTogMCwgaW5zdGVhZCBv
ZiAxNi4gIFdlCnNob3VsZCBhbHdheXMgY2FsbCBkbWlfcHJlc2VudCB3aXRoIERNSSBzdHJ1Y3R1
cmUuCi0tLQogZHJpdmVycy9maXJtd2FyZS9kbWlfc2Nhbi5jIHwgNSArKy0tLQogMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2Zpcm13YXJlL2RtaV9zY2FuLmMgYi9kcml2ZXJzL2Zpcm13YXJlL2RtaV9zY2FuLmMKaW5k
ZXggOTgyZjFmNS4uMTcwNzNhOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9maXJtd2FyZS9kbWlfc2Nh
bi5jCisrKyBiL2RyaXZlcnMvZmlybXdhcmUvZG1pX3NjYW4uYwpAQCAtNDQyLDcgKzQ0Miw2IEBA
IHN0YXRpYyBpbnQgX19pbml0IGRtaV9wcmVzZW50KGNvbnN0IGNoYXIgX19pb21lbSAqcCkKIHN0
YXRpYyBpbnQgX19pbml0IHNtYmlvc19wcmVzZW50KGNvbnN0IGNoYXIgX19pb21lbSAqcCkKIHsK
IAl1OCBidWZbMzJdOwotCWludCBvZmZzZXQgPSAwOwogCiAJbWVtY3B5X2Zyb21pbyhidWYsIHAs
IDMyKTsKIAlpZiAoKGJ1Zls1XSA8IDMyKSAmJiBkbWlfY2hlY2tzdW0oYnVmLCBidWZbNV0pKSB7
CkBAIC00NjEsOSArNDYwLDkgQEAgc3RhdGljIGludCBfX2luaXQgc21iaW9zX3ByZXNlbnQoY29u
c3QgY2hhciBfX2lvbWVtICpwKQogCQkJZG1pX3ZlciA9IDB4MDIwNjsKIAkJCWJyZWFrOwogCQl9
Ci0JCW9mZnNldCA9IDE2OwogCX0KLQlyZXR1cm4gZG1pX3ByZXNlbnQoYnVmICsgb2Zmc2V0KTsK
KwkvKiAxNiBpcyB0aGUgb2Zmc2V0IG9mIF9ETUlfIHN0cmluZy4gICovCisJcmV0dXJuIGRtaV9w
cmVzZW50KGJ1ZiArIDE2KTsKIH0KIAogdm9pZCBfX2luaXQgZG1pX3NjYW5fbWFjaGluZSh2b2lk
KQotLSAKMS43LjExLjcKCg==
--e89a8ff1c56a186c6b04d62be6ba--
