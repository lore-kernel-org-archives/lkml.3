Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3CLOnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:43:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3CLOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:43:09 -0400
Message-ID: <513F3EF0.3030609@pengutronix.de>
Date: Tue, 12 Mar 2013 15:42:56 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, tony@atomide.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de> <513F37DD.9030301@ti.com> <513F38DF.5040404@pengutronix.de> <513F3B7E.8000002@ti.com>
In-Reply-To: <513F3B7E.8000002@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2JFKJCWOQMMBTRRLLAEMG"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JFKJCWOQMMBTRRLLAEMG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/12/2013 03:28 PM, Roger Quadros wrote:
> On 03/12/2013 04:17 PM, Marc Kleine-Budde wrote:
>> On 03/12/2013 03:12 PM, Roger Quadros wrote:
>>> On 03/12/2013 01:54 PM, Marc Kleine-Budde wrote:
>>>> On 03/12/2013 12:24 PM, Roger Quadros wrote:
>>>>> Add clk_rate parameter to platform data. If supplied, the
>>>>> NOP phy driver will program the clock to that rate during probe.
>>>>>
>>>>> Also add 2 flags, needs_vcc and needs_reset.
>>>>> If the flag is set and the regulator couldn't be found
>>>>> then the driver will bail out with -EPROBE_DEFER.
>>>>
>>>> Is there a platform which fills out pdata.needs_vcc and
>>>> pdata.needs_reset? IMHO it makes no sense to add features for the no=
n DT
>>>> case, if there isn't any user for it.
>>>>
>>>
>>> There can be a user in the non DT case as well. Consider the followin=
g example:
>>
>> I'm just saying, let the implementation up to a real user for the non =
DT
>> case. Beagleboard is ARM and there's no point of implementing non DT
>> fall backs for ARM, IMHO.
>>
>=20
> Why do you say so?
>=20
> It doesn't depend on the CPU architecture. It depends on how the board =
designer
> wired the board. A non ARM platform could also face the same problem as=
 beagle.

Using -EPROBE_DEFER ist the way to solve the problem.

> It is not a non DT fallback. I believe many are still using non DT boot=
 and it
> needs to work at least till we move all functionality to purely DT.

=46rom my point of view, it makes no sense today to implement new feature=
s
which have a fallback for the non-DT case, if there isn't a real user of
this feature. So IMHO don't add needs_vcc and needs_reset flags to the
pdata, just take the information from the DT. As soon as there is a
non-DT user of this feature she/he can implement it or even better
switch to DT.

just my 2=A2,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2JFKJCWOQMMBTRRLLAEMG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlE/PvMACgkQjTAFq1RaXHOogQCfXzW2ObsELUYpeuzM+av4oltJ
anMAn1qTdhMvcao14GJcr1LIwu+xAE03
=5H+S
-----END PGP SIGNATURE-----

------enig2JFKJCWOQMMBTRRLLAEMG--
