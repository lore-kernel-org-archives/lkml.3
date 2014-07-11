Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaGKRyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:54:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaGKRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:54:10 -0400
Message-ID: <53C024B2.60404@pengutronix.de>
Date: Fri, 11 Jul 2014 19:53:54 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: wg@grandegger.com, shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
References: <1405075933-22317-1-git-send-email-stefan@agner.ch> <53BFD401.8030101@pengutronix.de> <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
In-Reply-To: <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wmTGV3w1tD3FfUTd6RROeUavTVfDdFEEQ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wmTGV3w1tD3FfUTd6RROeUavTVfDdFEEQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/11/2014 03:58 PM, Stefan Agner wrote:
> Hi Marc,
>=20
> Am 2014-07-11 14:09, schrieb Marc Kleine-Budde:
>> IMHO it should be 4 seperate patches:
>> - dt
>> - clocks
>> - flexcan_get_berr_counter fixes
>> - your flexcan enhancements
>=20
> Ok, will split.
>=20
>>> @@ -362,7 +374,7 @@
>>>
>>>  			esdhc1: esdhc@400b2000 {
>>>  				compatible =3D "fsl,imx53-esdhc";
>>> -				reg =3D <0x400b2000 0x4000>;
>>> +				reg =3D <0x400b2000 0x1000>;
>>
>> What's that doing here? :)
>=20
> That's an error I just stumbled upon. I know it's not related but it's
> such a small change... Do I need to make a separate patch for that or
> can I include it in the FlexCAN dt commit?

Yes, please post it to Shawn (& linux-arm) directly.

>=20
>>> @@ -150,18 +171,20 @@
>>>   * FLEXCAN hardware feature flags
>>>   *
>>>   * Below is some version info we got:
>>> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
>>> - *                                Filter?   connected?
>>> - *   MX25  FlexCAN2  03.00.00.00     no         no
>>> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
>>> - *   MX35  FlexCAN2  03.00.00.00     no         no
>>> - *   MX53  FlexCAN2  03.00.00.00    yes         no
>>> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
>>> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
>>> + *                                Filter?   connected?  detection
>>> + *   MX25  FlexCAN2  03.00.00.00     no         no	   no
>>> + *   MX28  FlexCAN2  03.00.04.00    yes        yes	   no
>>> + *   MX35  FlexCAN2  03.00.00.00     no         no	   no
>>> + *   MX53  FlexCAN2  03.00.00.00    yes         no	   no
>>> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes	   no
>>> + *   VFxx  FlexCAN3  ?		     no		no	  yes
>>
>> Please use either tabs or space to indent in this table.
>=20
> Ok, btw, do you know how I can obtain the IP version?

Get in touch with a freescale engineer with VHDL access, meet in a
bar...ask her/him....Something like this :)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--wmTGV3w1tD3FfUTd6RROeUavTVfDdFEEQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPAJLIACgkQjTAFq1RaXHOL2wCbBK35sXmf6GlHj+JTifZc3UoX
rs0AnRoiBGYz54hOwl0U3NZ6YP1/LmJu
=VJ1l
-----END PGP SIGNATURE-----

--wmTGV3w1tD3FfUTd6RROeUavTVfDdFEEQ--
