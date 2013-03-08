Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3CHHXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:23:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3CHHXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:23:06 -0500
Date: Fri, 8 Mar 2013 08:23:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130308072300.GB5772@avionic-0098.mockup.avionic-design.de>
References: <1362590238-27692-1-git-send-email-achew@nvidia.com>
 <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
 <513867CD.4030201@nvidia.com>
 <20130307112723.GA2593@avionic-0098.mockup.avionic-design.de>
 <643E69AA4436674C8F39DCC2C05F7638629CA50EB4@HQMAIL03.nvidia.com>
 <51394B10.5070903@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <51394B10.5070903@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:voZFFg0EfoRdrV3cu6/bTFB0y/ahIC9kWyBsmI0v75k
 mHdX0PkGplP9zjqeCQkj9tN64tDuy+n9Fl0yv06liDOYmbXERX
 vri18f0UHAp/O8x1pySCrqBEfd3am7zRyFD6vMisd9Bxf1iw/u
 o7EbpbyusOFYYuK+vb+kAvlN2aaTVlti2H7JffeDfttO5FJ8rk
 9+pSh0TnPRPAzWFPry9yp5FRL+vw4Q39+YPkHG63B8vp6bkp0L
 ETojCU1uySawh9Gbnrkkl5RVYE3gohTo3Cb4Mfghxo0wGlZPr0
 6Vis1lRrxEcPIT5L9JaYMUfZb2WArNzZDuBK1kv/zmpE8OJv4b
 VYs5IXDD0pvVTYl5ZdVZCVHbpKuv48wev1Krc5YL17VWgcMp9O
 Lup72MvD4JnAOegNq3XYpO+RDhX+R+lIFQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2013 at 11:21:04AM +0900, Alex Courbot wrote:
> On 03/08/2013 06:07 AM, Andrew Chew wrote:
> >>From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
> >>Sent: Thursday, March 07, 2013 3:27 AM
> >>To: Alex Courbot
> >>Cc: Andrew Chew; linux-kernel@vger.kernel.org
> >>Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable
> >>regulator
> >>
> >>* PGP Signed by an unknown key
> >>
> >>On Thu, Mar 07, 2013 at 07:11:25PM +0900, Alex Courbot wrote:
> >>>On 03/07/2013 04:11 PM, Thierry Reding wrote:
> >>>>>+	bool			en_supply_enabled;
> >>>>
> >>>>This boolean can be dropped. As discussed in a previous thread, the
> >>>>pwm-backlight driver shouldn't need to know about any other uses of
> >>>>the regulator.
> >>>
> >>>Sorry for being obstinate - but I'm still not convinced we can get rid
> >>>of it. I checked the regulator code, and as you mentioned in the
> >>>previous version, calls to regulator_enable() and
> >>>regulator_disable() *must* be balanced in this driver.
> >>>
> >>>Without this variable we would call regulator_enable() every time
> >>>pwm_backlight_enable() is called (and same thing when disabling).
> >>>Now imagine the driver is asked to set the following intensities: 5,
> >>>12, then 0. You would have two calls to regulator_enable() but only
> >>>one to regulator_disable(), which would result in the enable GPIO
> >>>remaining active even though it would be shut down. Or I missed
> >>>something obvious.
> >>>
> >>>The regulator must be enabled/disabled on transitions from/to 0, and
> >>>AFAICT there is no way for this driver to detect them.
> >>
> >>Yes, that's true, but I don't think it should be solved for just this o=
ne
> >>regulator. Instead if we need to track the enable state we might as wel=
l track
> >>it for *any* resource so that the PWM isn't enabled/disabled twice eith=
er.
> >
> >That makes sense, but I'm confused due to previous comments.  The most
> >obvious way to do this seems to be to have a bool track the enable state.
> >Do you still want me to do away with this bool?  I can satisfy your very
> >last comment by keeping the bool (renaming it to something more generic)
> >and encapsulating the pwm_enable()/pwm_disable() call within.
>=20
> I think that's what Thierry meant, yes.

Yes, it is. =3D)

> >>I expect that if the changes are split up then the board-setup code cha=
nges
> >>need to be done prior to the driver change. Using the lookup tables sho=
uld
> >>make this easy because they aren't tied to the platform data and can be
> >>added independently. The patches should probably go through the same
> >>subsystem tree to take care of the dependencies.
> >>
> >>Keeping everything in one patch would work too, but it's certainly more
> >>chaotic.
> >
> >Am I supposed to handle those patches?  I'm concerned that I don't have
> >hardware to test properly, but I can give it a shot if it's my responsib=
ility.
>=20
> Yes, if you introduce incompatibilities you have the burden of
> performing the transition without breaking things at any single
> point of the git history. Since this is just about adding a dummy
> regulator, it should go fine even without testing. And in the event
> it does not, that's what linux-next is for.

Right. We'll need an Acked-by from the board/machine maintainers anyway
and if something still breaks we can always fix it after somebody's
actually done the testing.

> Make sure you also update the dts of current device tree users, as
> they will break, too.
>=20
> What I don't know is if you should update all users in one big
> patch, or instead provide one patch per platform changed. Maybe
> Thierry can provide some guidance here.

I think it'd be good to split them up into per-architecture and
per-machine. Per-board would probably be too much. That'll allow the
respective maintainers to ack patches that touch their machines or
boards without having them go through all other hunks too.

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJROZHUAAoJEN0jrNd/PrOh3DIQALblQKJoDC5MjAc5Y+xuv7Hq
Vj9JsuXqhkhh92mCa+IqUI0RcPuRJX2FeqwhavlcYV41w2JCdtvr6xdtoqgR032c
ZidVEAtiv30Q9nRa8YaZR2csYmIadMVGIsJZBNFLOqbiVNKqJX7PL/0/Jy5dqIbv
Gr3aAGQGTj8ElwpCoqobKDM//bsQFlQhPuD47zJT4wDa80+J/UvRMxG0/7FJPmCs
qk77MaX+4gxu1fUrFxnW/8s7cBHobMyGtiV+EX86nm8TxW+tQK9l+aMPtAZJrEUF
fgdxIfhZgGe+EeTm6w6hoAFlr5Tj16FwAmbLPjNAHzGRi1u/zWluHIANfqOluV9O
lUeIXuq2ueuZpC+eAXourdH38bQkaqCBygWXQt98yXXKUYXOc4f0t0pnabvgdCMd
bAh7ptmRabA11xpB32r/td55rIjVOqRBiHLtY/VFb1nH7B0S+kN7qUZgZNk3CFM6
WAEMRWQp5x7mw/bNPhSqsMpPOEStVEIztxMsZtolubCpFpmj8KHaFyWG8U0Jna7a
GZRzIHVHdpbAUA4BrKG6ecPIz8RHPDf2AUmILT+sbHEaIH396rGqB6i+vADD9byq
KI3FXEPNBkTNtBzBeNdwRGHD+4155K3hJ7fZtSxHhuuqQqyHi5RDnOygopd/2gIL
GU+3btbAQlfJR8kIXxCF
=ix0X
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
