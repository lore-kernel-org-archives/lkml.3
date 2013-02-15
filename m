Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638Ab3BOJ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:56:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:37145 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab3BOJ4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:56:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,672,1355126400"; 
   d="scan'208";a="263068393"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Andreas Mohr <andi@lisas.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
Thread-Topic: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
Thread-Index: AQHOCsHF9Z6vRnNAfUas0eTwR3aiyph6r6ww
Date: Fri, 15 Feb 2013 09:56:18 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926329ED84@SHSMSX101.ccr.corp.intel.com>
References: <20130214144404.GA20011@rhlx01.hs-esslingen.de>
In-Reply-To: <20130214144404.GA20011@rhlx01.hs-esslingen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_744357E9AAD1214791ACBA4B0B90926329ED84SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_744357E9AAD1214791ACBA4B0B90926329ED84SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



> -----Original Message-----
> From: Andreas Mohr [mailto:andi@lisas.de]
> Sent: Thursday, February 14, 2013 10:44 PM
> To: Zhang, Rui
> Cc: linux-kernel@vger.kernel.org
> Subject: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
> Importance: High
>=20
> Hi,
>=20
> I just had a
>=20
> # cat /sys/class/thermal/thermal_zone0/policy
> (null)
>=20
>=20
> When looking at the code (on my -rc7), I saw:
>=20
> drivers/thermal/thermal_sys.c
>=20
> static ssize_t
> policy_show(struct device *dev, struct device_attribute *devattr, char
> *buf)
> {
>         struct thermal_zone_device *tz =3D to_thermal_zone(dev);
>=20
>         return sprintf(buf, "%s\n", tz->governor->name);
> }
>=20
>=20
> (not sure though why I manage to get a "(null)" rather than a crash
> due to the dereferencing prior to output - possibly since I do have a
> valid governor allocated yet then only its name field is null?)
>=20
Hmm,

Please apply the debug patch and see what you can get here.

Thanks,
rui
>=20
> Seems we are missing a critical (and -rc-relevant) patch here
> (and perhaps at other locations in this file, too, given that
> this one was missed last time?).
>=20
> Currently trying to get acerhdf operation into a working state
> (and having some trouble with it - didn't know that I probably need
> some
> governor setup which seems to have just been available on my last setup,
> or so)
>=20
> Thanks,
>=20
> Andreas Mohr

--_002_744357E9AAD1214791ACBA4B0B90926329ED84SHSMSX101ccrcorpi_
Content-Type: application/octet-stream; name="acerhdf-debug-2.patch"
Content-Description: acerhdf-debug-2.patch
Content-Disposition: attachment; filename="acerhdf-debug-2.patch"; size=618;
	creation-date="Fri, 15 Feb 2013 09:54:58 GMT";
	modification-date="Fri, 15 Feb 2013 09:54:58 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC90aGVybWFsX3N5cy5jIGIvZHJpdmVycy90aGVy
bWFsL3RoZXJtYWxfc3lzLmMKaW5kZXggOGM4Y2U4MC4uNTdjODNhYSAxMDA2NDQKLS0tIGEvZHJp
dmVycy90aGVybWFsL3RoZXJtYWxfc3lzLmMKKysrIGIvZHJpdmVycy90aGVybWFsL3RoZXJtYWxf
c3lzLmMKQEAgLTY5Nyw3ICs2OTcsOSBAQCBwb2xpY3lfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYs
IHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICpkZXZhdHRyLCBjaGFyICpidWYpCiB7CiAJc3RydWN0
IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6ID0gdG9fdGhlcm1hbF96b25lKGRldik7CiAKLQlyZXR1
cm4gc3ByaW50ZihidWYsICIlc1xuIiwgdHotPmdvdmVybm9yLT5uYW1lKTsKKwlyZXR1cm4gc3By
aW50ZihidWYsICIlc1xuIiwgdHotPmdvdmVybm9yID8gKHR6LT5nb3Zlcm5vci0+bmFtZSA/IHR6
LT5nb3Zlcm5vci0+bmFtZSA6ICJOVUxMIG5hbWUiKSA6ICJOVUxMIGdvdmVybm9yIik7CisKKy8v
CXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVzXG4iLCB0ei0+Z292ZXJub3ItPm5hbWUpOwogfQogCiBz
dGF0aWMgREVWSUNFX0FUVFIodHlwZSwgMDQ0NCwgdHlwZV9zaG93LCBOVUxMKTsK

--_002_744357E9AAD1214791ACBA4B0B90926329ED84SHSMSX101ccrcorpi_--
