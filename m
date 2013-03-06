Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3CFHA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:00:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3CFHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:00:23 -0500
Date: Wed, 6 Mar 2013 08:00:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130306070019.GA2436@avionic-0098.mockup.avionic-design.de>
References: <1362527485-8611-1-git-send-email-achew@nvidia.com>
 <5136A781.2050303@nvidia.com>
 <643E69AA4436674C8F39DCC2C05F7638629BFE1DB7@HQMAIL03.nvidia.com>
 <5136CBC7.3030803@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <5136CBC7.3030803@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4m0gcu1E42aybQJEPRu4TaqPgfUmRxC94ChvcpJq2gB
 IVuuC6pC/Jnx8rnr40IFuSjaINvuMoJJVFy04HHAbKRZ878RSi
 bcWbjQ+XouZuW6+Y2AeJVYKPkzNPH6zI4qZL6wLMy3X+PiuPxb
 4KVQjfcpYLzh+7eKiG4T4eisgck2/Z5MxFgA/uwkM57lAw9hMZ
 rfVrNwuufWppCXX43k5Bx1Hn2UkIisfiO+gNNrzVA8ZlTRT9+w
 /pOoQDuJrwE+l/m9FJNfs1we7CvRLEZEfv1NgmlZC3qYOIgbt/
 hwy0Mru8DFg30WOgSVTdemEhfAM18lh3EzFe21EVzd73A1qb2/
 IypskxtctV4SEorzTbCXRQEPJjH8GTy06dQUwTVjTUrw4YqItO
 n3DPXyjv3EQB0VvJ67pUQDfAzk/n4V0j38=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2013 at 01:53:27PM +0900, Alex Courbot wrote:
> On 03/06/2013 11:41 AM, Andrew Chew wrote:
> >>>   struct pwm_bl_data {
> >>>   	struct pwm_device	*pwm;
> >>>   	struct device		*dev;
> >>>+	struct regulator	*en_supply;
> >>>+	bool			en_supply_enabled;
> >>
> >>Couldn't you use regulator_is_enabled() and get rid of en_supply_enable=
d?
> >>It would also ensure the driver performs correctly no matter what the i=
nitial
> >>state of the regulator is.
> >
> >Are you sure this works?  I'm concerned about the (bizarre and unlikely)=
 case
> >where this supply is shared with another driver, so I use en_supply_enab=
led
> >to track the state of the supply such that I can ignore that case.
>=20
> You're right, consumers can share regulators and the calls to
> enable/disable need to be balanced. Also there is no way to check
> the intensity of the backlight prior to the change to detect a
> transition, so I guess your approach is indeed the most appropriate
> here.

I think the right thing to do here is just enable the regulator when
the pwm-backlight driver needs it. If it is shared with other devices
they'll have to do the same and the reference counting should only
disable the regulator when there are no users.

Tracking this via platform data won't work because platform data is
statically defined at compile time. So if indeed there was another user
of the regulator it enable/disable the regulator at any time and your
en_supply_enabled would be wrong.

Thierry

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNumDAAoJEN0jrNd/PrOhw6kP/0Ef22LpeaeFP7sRUFi8GJS4
VSMORjXtySJJY7ChBVLe4SvdlAJ5NAUbDbkuhACus/DoOKHIG582/V1SCnFBaJPi
Kk1gJ9mlmOdkb0jS0IficU4n+E19X30gxo4c8OKb0k20dbiMZcbdtffjpiXYHO+Z
a3uqjH5rVtsjtkJ8k+5vv4Dg5G549qh5nurna2mqvBQnwVjdeDZ7O6jLE0V1Osxs
lz17e6AKN7YlYaxeB2M4qDPIHLM5uxbBWx7c1IMOGSfgZqC+Tv4LP3JEX9T5xFHK
pANzyNf1gFd4fNbxuUXJ0dngcWJh4XGVIlr8htb70rNCSd3uPYO3jEfgwnGTuTww
rYl2Lh8fG6eff0msIR6bPNnik1YjdijkJ2jum5GFabwt5JqGxE/gYq0YVtRZZzas
TV/KNN+H13Zs7JE7J7IDlIBB9urr5VYr2MrlSA8LHnQKmQzYzDHAPwOjle9VFb21
HxUUr2/7P2zGRsZiquBw8iViy07+o4Ghkqsw0K1AUxuzwNCkfivNxGFWSIy1MBva
tn1e8nYnSAm5pl6wXecD80O8qWGLQKAEj5ZxszvmyAAhy3ILmd3ScKeBC3B6zp8I
S97pN4l2bG8n99ansbYielqmpmMNFFWl1YVNkEJFjBkKlhC9l6J1ubVpoDpilW2N
7PPVTgwT4ENykG/xzf5f
=6dxa
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
