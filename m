Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3AQXsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:48:38 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42004 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab3AQXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:48:36 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic85fh542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz17326ah8275bh8275dhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h34h1155h)
X-WSS-ID: 0MGSNGS-01-7BQ-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux 3.8-rc3 reboot and shutdown
Thread-Topic: linux 3.8-rc3 reboot and shutdown
Thread-Index: AQHN9OVfBOBCoX5Y/Ea73ubzySE7LJhN7CZQgAChWAD//6JnAA==
Date: Thu, 17 Jan 2013 23:48:27 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC30C27@sausexdag04.amd.com>
References: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC2FB3A@sausexdag04.amd.com>
 <CAKocOOMrTf9RMa17Zy_oK+uPJ_B7uNwxhsX7dOm4okVdnmwY5A@mail.gmail.com>
In-Reply-To: <CAKocOOMrTf9RMa17Zy_oK+uPJ_B7uNwxhsX7dOm4okVdnmwY5A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.124]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30C27sausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30C27sausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Thursday, January 17, 2013 6:21 PM
> To: Deucher, Alexander
> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: linux 3.8-rc3 reboot and shutdown
>=20
> On Thu, Jan 17, 2013 at 12:45 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Thursday, January 17, 2013 2:03 PM
> >> To: jglisse@redhat.com; Deucher, Alexander
> >> Cc: linux-kernel@vger.kernel.org; Shuah Khan
> >> Subject: linux 3.8-rc3 reboot and shutdown
> >>
> >> Alex,
> >>
> >> I started seeing hang during shutdown and reboot on my laptop that has
> >> ATI radeon VGA.
> >>
> >> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
> >> ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
> >> controller])
> >>
> >> My bisect narrowed it to the following commit.
> >
> > Should be fixed by this commit:
> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=3Ddrm-fixes-
> 3.8&id=3D19fc42ed9950d5fe17089c0a928121047c882092
> > Which should be finding its way upstream any day now.
> >
> > Alex
> >
>=20
> Alex,
>=20
> Applied this patch on 3.8-rc3 and tested it. reboot still hung. The
> only thing that fixes the problem is reverting
> 71e3d1578c954cf29f1f4db1c8930d3574025eb0

Does the attached patch applied in addition to:
http://cgit.freedesktop.org/~agd5f/linux/commit/?h=3Ddrm-fixes-3.8&id=3D19f=
c42ed9950d5fe17089c0a928121047c882092
fix the issue?

Alex

>=20
> I am also seeing DMAR errors on this device starting 3.8-rc3 and I am
> going to start bisecting that soon. Reverting
> 71e3d1578c954cf29f1f4db1c8930d3574025eb0 doesn't help solve the DMAR
> errors.
>=20
> -- Shuah


--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30C27sausexdag04amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch"
Content-Description: 0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch";
	size=1230; creation-date="Thu, 17 Jan 2013 23:46:11 GMT";
	modification-date="Thu, 17 Jan 2013 23:45:44 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1MTkyNmJkY2RmNDUwMmRkMWNhNjljOTllYWEzMmRmMzE3Y2ZiOWYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMTcgSmFuIDIwMTMgMTg6NDI6NTYgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBkb24ndCBhdHRlbXB0IHRvIHNvZnQgcmVzZXQgRE1BIHJpbmcgb24gcjZ4
eAoKRG9lcyBub3Qgc2VlbSB0byB3b3JrIHJlbGlhYmx5LiAgRml4ZXMgaGFuZ3Mgd2hlbiBhdHRl
bXB0aW5nCnRvIHNvZnQgcmVzZXQgdGhlIERNQSByaW5nLgoKUmVwb3J0ZWQtYnk6IFNodWFoIEto
YW4gPHNodWFoa2hhbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxl
eGFuZGVyLmRldWNoZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAu
YyB8ICAgIDkgKysrKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyBi
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jCmluZGV4IDNjYjlkNjAuLjY2NjFiOTMgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jCisrKyBiL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vcjYwMC5jCkBAIC0xNDUwLDkgKzE0NTAsMTIgQEAgYm9vbCByNjAwX2RtYV9p
c19sb2NrdXAoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYsIHN0cnVjdCByYWRlb25fcmluZyAq
cmluZykKIAogaW50IHI2MDBfYXNpY19yZXNldChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikK
IHsKLQlyZXR1cm4gcjYwMF9ncHVfc29mdF9yZXNldChyZGV2LCAoUkFERU9OX1JFU0VUX0dGWCB8
Ci0JCQkJCSAgUkFERU9OX1JFU0VUX0NPTVBVVEUgfAotCQkJCQkgIFJBREVPTl9SRVNFVF9ETUEp
KTsKKwl1MzIgcmVzZXRfbWFzayA9IFJBREVPTl9SRVNFVF9HRlggfCBSQURFT05fUkVTRVRfQ09N
UFVURTsKKworCWlmIChyZGV2LT5mYW1pbHkgPj0gQ0hJUF9SVjc3MCkKKwkJcmVzZXRfbWFzayB8
PSBSQURFT05fUkVTRVRfRE1BOworCisJcmV0dXJuIHI2MDBfZ3B1X3NvZnRfcmVzZXQocmRldiwg
cmVzZXRfbWFzayk7CiB9CiAKIHUzMiByNnh4X3JlbWFwX3JlbmRlcl9iYWNrZW5kKHN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2LAotLSAKMS43LjcuNQoK

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30C27sausexdag04amdc_--
