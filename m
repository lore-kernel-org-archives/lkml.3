Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaJFPfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:35:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47728 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaJFPfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:35:00 -0400
Date: Mon, 6 Oct 2014 17:34:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
Message-ID: <20141006153456.GB23362@ulmo>
References: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
 <5420731E.6040104@wwwdotorg.org>
 <1862760b05184b95948b5e4952db010d@bgmail103.nvidia.com>
 <54297E7E.1030306@wwwdotorg.org>
 <96955607a8414f75bb4110ebef5daa37@bgmail103.nvidia.com>
 <542C3E34.2060505@wwwdotorg.org>
 <bd1591558b59409faf9edfd3eba2523e@bgmail104.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <bd1591558b59409faf9edfd3eba2523e@bgmail104.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 08:49:35AM +0000, Vidya Sagar wrote:
>=20
>=20
> > -----Original Message-----
> > From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > Sent: Wednesday, October 01, 2014 11:18 PM
> > To: Vidya Sagar
> > Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
> > tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 dev=
ice
> > tree
> >=20
> > On 10/01/2014 11:13 AM, Vidya Sagar wrote:
> > >
> > >
> > >> -----Original Message-----
> > >> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > >> Sent: Monday, September 29, 2014 9:15 PM
> > >> To: Vidya Sagar
> > >> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
> > >> tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > >> kernel@vger.kernel.org
> > >> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1
> > >> device tree
> > >>
> > >> On 09/29/2014 04:25 AM, Vidya Sagar wrote:
> > >>>
> > >>>> -----Original Message-----
> > >>>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > >>>> Sent: Tuesday, September 23, 2014 12:36 AM
> > >>>> To: Vidya Sagar
> > >>>> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota;
> > >>>> linux- tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> > >>>> kernel@vger.kernel.org
> > >>>> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1
> > >>>> device tree
> > >>>>
> > >>>> On 09/22/2014 11:57 AM, Vidya Sagar wrote:
> > >>>>> sd4 is an always on regulator which is turned on at boot time.
> > >>>>> It is externally controller through gpio. This change reflects the
> > >>>>> same in Jetson TK1 device tree
> > >>>>
> > >>>> In the schematics, the "Power Sequencing" timing diagram says "S/W
> > >>>> controlled" for SD4/+1.05V_RUN. I also don't see an "ENABLE1" pin
> > >>>> on the AS3722, which would be required for ...
> > >>
> > >> Can you please comment on this aspect of the issue?
> > >>
> > >>>>> +					ams,ext-control =3D <1>;
> > >>>>
> > >>>> ... to be valid.
> > >>>>
> > >>>> What's the source of information behind this change?
> > >>>>
> > >>>> What symptoms does this patch correct?
> > >>>
> > >>> I'm seeing one issue when I add support for PCIe suspend/resume
> > >> functionality.
> > >>> The issue is that, when regulator_bulk_diable() is called, disabling
> > >>> one of
> > >> the power rails (which is deriving its voltage from SD4) of PCIe is =
failing.
> > >>> The reason being, I2C controller is getting power gated
> > >>
> > >> Why is the fix being applied to SD4 if the issue is with a power rail
> > >> derived from SD4? Shouldn't any fix be applied directly to the
> > >> problematic rail rather than some parent rail?
> > >>
> > >> Since the I2C controller is part of the SoC and we don't have power
> > >> domain support yet, the only way the I2C controller can get power
> > >> gated is when the SoC as a whole is turned off.
> > >>
> > >>   > before power rail disable is called.
> > >>
> > >> ... so without making SD4 dependant on ext-control, since no SW can
> > >> be running at this point, the only way SD4 could get turned off is
> > >> that the PMIC turns it off itself at the appropriate point in the
> > >> system power sequence based on its OTP programming, or the board HW
> > >> is already set up to turn off
> > >> SD4 at the appropriate time somehow. Is that not happening?
> > >> That would imply incorrect PMIC programming wouldn't it?
> > >>
> > >
> > > After some debugging, found that the I2C driver's suspend is getting
> > > called before the suspend of PCIe is called (BTW, PCie has
> > > suspend_noirq..!) Hence, when PCIe driver wants to disable regulators=
 it
> > fails because of I2C write failure, which is expected given I2C is alre=
ady
> > suspended.
> >=20
> > Ah. It sounds like the PCIe driver should have a regular suspend functi=
on not
> > a suspend_noirq function then. It's certainly expected that resources b=
ehind
> > an I2C bus (i.e. most regulators) can't be manipulated in a suspend_noi=
rq
> > function.
> >=20
>=20
> PCIe host controller driver can't have regular suspend function, because,
> PCI subsystem has its own suspend_noirq which tries to read Config regist=
ers of the connected PCIe devices, which
> in turn results in hang (because host controller would have been suspende=
d by then...!)

I'd consider it a bug for the PCI core to try to access configuration
space when the host controller has been suspended, so I'd say this needs
to be fixed somewhere else.

Can you point out which function does this so that I can help coming up
with a more suitable fix?

Thierry

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMragAAoJEN0jrNd/PrOh9r0P/22c7vfv71a0PoQ+DjmyKCey
DW7bT4yxA6Gq4ISNIbVEitBw8noHERuDEr6VpjPzpVao250KuOU0Au48i3hrmVZy
kMiXz2WNgWOIbxESvCIGKlLCn6LfppRsjAjkjnkgfonU+TNJ8OTvIOGzBDQyJqf+
hCKgm1SlrMavUJLI7qcCL2R85Vc5XOJ+PYQVvR6l9JahDAVO3Fp9pb5pHa6lmqBQ
g2qs32aSu9hzF1ytxiZF+wy3e+yY0s10TuQaeyErvJOUdzcdTIDPQgf56D3Ij4bM
qPVAzBMGFH+Y/BeIQAtYTWw54a8mFjXQM6vhswALc5+g4jHbcWEH3SW7efMhYDQQ
16lr2rnBZCZQ3XPUz+uyQkC+4/up9Q/bizejbIoiYP8TgAYo7gcuQnIyCBQOHmm3
mAGeW3HfKRRoEpbwFqPSzMo+mCiGFOwh8YaZcAlkNJmZCwCa1HA4E2INR5jFvi7F
V90WZEFRE+MWOObxYuEHBV8gomW1xk3k50CbKOkc0Si0GieZLBc461ybkw4j0RDN
THqGpd0mltXjoJXjwKXrcphJdHpnaWNHm12BBoFuU/aJxFzaJDdHlq3eVeTmbWsc
HDoBrRJSVSvHkdjx1vfWY2ckBkoI7wWk/goD/2NbfbPjUxOAXpTg7CO2pCl+TCCp
dcpxvLlACvCb+aiqAYzr
=iB3Y
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
