Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AQLs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:48:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57276 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab3AQLs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:48:26 -0500
Date: Thu, 17 Jan 2013 13:48:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 17/22] mfd: omap-usb-host: clean up omap_usbhs_init()
Message-ID: <20130117114804.GG18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-18-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-18-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MrRUTeZlqqNo1jQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 01:30:26PM +0200, Roger Quadros wrote:
> +	if (is_omap_usbhs_rev1(omap))
> +		reg =3D omap_usbhs_rev1_hostconfig(omap, reg);
> +	else if (is_omap_usbhs_rev2(omap))
> +		reg =3D omap_usbhs_rev2_hostconfig(omap, reg);

Any way you could maybe:

rev =3D omap_usbhs_revision(omap)
switch(rev) {
case REV1:
	foo();
	break;
case REV2:
	bar();
	break;
default:	/* highest revision */
	baz();
}

could be done in a later patch however.

--=20
balbi

--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+T0AAoJEIaOsuA1yqREIjYP/0MwVK3/8tBSFYq9jWQwelTh
Ywxm/c1CTa0Mng29+qltNQ1+e9rKS2onT+GfzQp3UBrJrDmMFlJmO0VfUl3GU6m8
YS3MAI0PUCgzmIpHcYDn1XfSZwlepylMVVDwZIHgCwEHDZrQwqd/PEK5g+n3Yj+d
a9RoQ1o7RPvZFrNMRY6HORKJ36DUGQHoB4Ki/K2BxW9efiyjkexBqDHXrocXR+zD
y6LGxz9X4J9LS1RgimMDoymJ96eywC02yXJbW42Ju52wJcEIG2Syq7P4INC9KWko
6IilpQNVZiEAb8C80lqOLpMDMNQXI79kpkVdmPD71Lsf6itIPzJI820sM/gznhJW
McOp9E5jg7BdOwd5oUb78I+p6CtYretNBmHDLizgTTEB4XsjgigvQTUQeEiN1wQT
OUBITVPSVXRoAztMuS1kpNcOXCmRHWJhV4Ib1xssW/7E39jMiQUBUG549E2gW5gj
cI++gVZzzX0OdjO2pgkyzIT1U9bsSnQaKN4OMSC+XEumaYi17eaSgBG+Br+aX7sO
ix8RLDDKR41WcXBKLZ/i6GAqCuzjFo7BWeXonJWKm5T9EZtg8fuzf01ObeoMDTM+
g1vahshl02RFy5c84J4ei9fBLExPCKynS7FEvfBFRDW3RUQmlTTdYIF+LCXpg5Hv
3zGDyqR1s2AMe+hfhRaI
=CKXh
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--
