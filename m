Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3IIN5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:57:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54334 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3IIN5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:57:19 -0400
Message-ID: <522DD386.2080003@pengutronix.de>
Date: Mon, 09 Sep 2013 15:56:22 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Ronald Wahl <ronald.wahl@raritan.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, John Stultz <john.stultz@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Andres Salomon <dilinger@queued.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-ar@jasper.es
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de> <alpine.LFD.2.02.1304251618590.21884@ionos> <51794385.1030308@pengutronix.de> <51C31926.3060400@pengutronix.de> <522D843A.60401@raritan.com>
In-Reply-To: <522D843A.60401@raritan.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2DnFRu5IJqau5nuXsGoDK62rT8wJFTB13"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2DnFRu5IJqau5nuXsGoDK62rT8wJFTB13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/09/2013 10:18 AM, Ronald Wahl wrote:
> On 20.06.2013 17:00, Marc Kleine-Budde wrote:
>> Hello Thomas,
>>
>> On 04/25/2013 04:53 PM, Marc Kleine-Budde wrote:
>>> On 04/25/2013 04:21 PM, Thomas Gleixner wrote:
>>>> On Tue, 23 Apr 2013, Marc Kleine-Budde wrote:
>>>>> The commit
>>>>>
>>>>>      77cc982 clocksource: use clockevents_config_and_register()
>>>>> where possible
>>>>>
>>>>> switches from manually calculating min_delta_ns (and others) and
>>>>> clockevents_register_device() to automatic calculation via
>>>>> clockevents_config_and_register(). During this conversation the "+
>>>>> 1" in
>>>>>
>>>>>      min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clkevt) + 1;
>>>>>
>>>>> was lost. This leads to problems with schedule_delayed_work() with
>>>>> a delay of
>>>>> "1". Resulting in the work not scheduled in time.
>>>>
>>>> Errm. How is schedule_delayed_work() related to this?
>=20
> I also stumbled over this issue now after upgrading from 3.4.57 to
> 3.10.10. Even sleep() is unreliable - sleeping for 2 seconds often
> sleeps just more than 3 seconds.
>=20
> The now lost +1 has actually been added in 2007 to solve a rounding iss=
ue:
>=20
>   http://permalink.gmane.org/gmane.linux.kernel/549744
>=20
> So I think this should either be fixed by always rounding up in
> clockevent_delta2ns() or by adding +1 to the min_delta_ns in the
> clockevents_config_and_register() function. Dunno if rounding up will
> cause problems with the max_delta_ns as it might be too big then so
> probably the second approach is better.
>=20
> Opinions?

Thomas, any thoughts on this?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--2DnFRu5IJqau5nuXsGoDK62rT8wJFTB13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlIt04YACgkQjTAFq1RaXHOqnwCfZsYoy4tpbnBHdH7dqZsW4IKN
xU8AoJVKAdg5PlvaZJFUCD5+q5VjiAOa
=w0Jj
-----END PGP SIGNATURE-----

--2DnFRu5IJqau5nuXsGoDK62rT8wJFTB13--
