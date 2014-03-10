Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaCJSqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:46:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaCJSqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:46:20 -0400
Date: Mon, 10 Mar 2014 13:44:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140310184440.GC32363@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <a39ce44a-2f92-4067-be6d-7311a78bb195@VA3EHSMHS013.ehs.local>
 <20140221153905.GE31902@saruman.home>
 <CALHRZuouwUh398PkmatQMyZNzrEreH-kGwJTTC7CsY_gdq8dbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <CALHRZuouwUh398PkmatQMyZNzrEreH-kGwJTTC7CsY_gdq8dbQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 10, 2014 at 07:06:19PM +0530, sundeep subbaraya wrote:
> On Fri, Feb 21, 2014 at 9:09 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Feb 21, 2014 at 11:27:07AM +0000, Subbaraya Sundeep Bhatta wrot=
e:
> >> > From the looks of it, I doubt this was actually tested, you need a l=
ot
> >> > of work on this driver.
> >> Tested on both ARM and Microblaze architectures with Mass storage gadg=
et.
> >> Will send a v2 after addressing all your comments.
> >
> > clearly you didn't try to remove and reinsert the module or you would
> > see a whole bunch of errors.
> >
>=20
> Yes you are correct. My console hung up as soon as i rmmod my driver.
> Could you please point me where am wrong.

Many of your mistakes have already been pointed out here:

http://marc.info/?l=3Dlinux-usb&m=3D139292068028649&w=3D2

Please fix those and see if following script works:

#!/bin/sh

MODULE=3D"xilinx_udc"

for i in $(seq 500); do
	modprobe $MODULE > /dev/null 2>&1;
	modprobe -r $MODULE > /dev/null 2>&1;
	if [ $? -eq 0 ]; then
		echo -n "."
	else
		echo -n "F"
	fi
done

echo "Finished"

you shouldn't see any F characters and your machine shouldn't crash or
hang or reboot...

Also make sure to run g_zero testcases and mass storage tescases. I
wrote, long ago, a small tool to help testing UDC drivers running with
the mass storage gadget, which you can find in [1]. There's a runner
script which makes it easy to full test suite which you can find in [2].

[1] https://gitorious.org/usb/usb-tools/source/7eb7ef21de6cd124e0e0d0e7df9d=
dfff0e2f548e:msc.c
[2] https://gitorious.org/usb/usb-tools/source/7eb7ef21de6cd124e0e0d0e7df9d=
dfff0e2f548e:msc.sh

--=20
balbi

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHggYAAoJEIaOsuA1yqREDx8QAIOL7NX7AOSJpFFsw/IkCsdg
2MDjokLJkG5VJ1nMJcjPJrE6D5neFMO06sTDRjtVnAqTr85qPDM2e0/SkEIKgKsq
V8E2FpSI2bZK5yODRZMREuWFaM9E0N1bU6WqoTzftmUbIy+uqwhhwqw7E9vDo1uH
zb2spRbm113hOGCs7L0t4LjaAIwLG0td+Q6uOidKB3pZWClEFcRzetTEewMrR/gj
mnIeSSIHUMaOdyJBi5T5U5+HD8O0UKG8p4eTD9mxznq95KWPq/xFgxxFxy5PfP9T
r3mppyBMIVDKhRBDpsa7iC4BfYzF1FMlbKifhoZnIzDFWwbPr70negQEy8TdbuA1
SlLzZGdEhw/nsrjP7/zkXbTC7qaZxShi1coS74rw4jDzygQHliboRgp7Zia2d9Uq
QwVZzrRsg3Flak9ToXN6aNtb5vHNFjni/VsMA72xTXt4YJ3HWOwGb8QCJaKnwNyt
jy55fD+mKzB2cyOI4jv7oraBWr0MSwSFNUOhH4MsoJM8i1WYnMgY5+osF+DMCokr
w4CfSG/b3Z86xaW8AtTfEcJp/Arja158gftAT+qg2UFzOitOlI3pS+osUj12liu9
asvtzYwZUpZOmnV27tOhLOpxmYiLnUM9THL4KZNGy/q7xoguZ8Vu1hjnMb/YHqxQ
dIt6Dx6Wt0Qtob+LA3gZ
=kJfR
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
