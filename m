Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaGaNuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:50:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaGaNur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:50:47 -0400
Date: Thu, 31 Jul 2014 08:49:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tero Kristo <t-kristo@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Nishanth Menon <nm@ti.com>, dt list <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <jason@lakedaemon.net>, Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, <tglx@linutronix.de>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140731134945.GB19512@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140729141522.GB17808@saruman.home>
 <20140729152052.GV29045@atomide.com>
 <20140729154057.GE17808@saruman.home>
 <20140729163345.GF17808@saruman.home>
 <20140730060420.GY29045@atomide.com>
 <20140730144059.GA7272@saruman.home>
 <CAGo_u6ou+MoKOE_tTTmjxyFNW=jTaN9vnTsHrxR6sQHsieJyLA@mail.gmail.com>
 <20140730162038.GH7272@saruman.home>
 <20140731062843.GA29045@atomide.com>
 <53D9F6D5.1080307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <53D9F6D5.1080307@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 31, 2014 at 10:57:09AM +0300, Tero Kristo wrote:
> On 07/31/2014 09:28 AM, Tony Lindgren wrote:
> >* Felipe Balbi <balbi@ti.com> [140730 09:23]:
> >>Hi,
> >>
> >>On Wed, Jul 30, 2014 at 10:45:41AM -0500, Nishanth Menon wrote:
> >>>On Wed, Jul 30, 2014 at 9:40 AM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>HI,
> >>>>
> >>>>On Tue, Jul 29, 2014 at 11:04:21PM -0700, Tony Lindgren wrote:
> >>>>>* Felipe Balbi <balbi@ti.com> [140729 09:36]:
> >>>>>>Hi,
> >>>>>>
> >>>>>>On Tue, Jul 29, 2014 at 10:40:57AM -0500, Felipe Balbi wrote:
> >>>>>>>On Tue, Jul 29, 2014 at 08:20:52AM -0700, Tony Lindgren wrote:
> >>>>>>>>* Felipe Balbi <balbi@ti.com> [140729 07:18]:
> >>>>>>>>>Hi,
> >>>>>>>>>
> >>>>>>>>>On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> >>>>>>>>>>* Felipe Balbi <balbi@ti.com> [140728 14:19]:
> >>>>>>>>>>>now that we don't need to support legacy board-files,
> >>>>>>>>>>>we can completely switch over to a linear irq domain
> >>>>>>>>>>>and make use of irq_alloc_domain_generic_chips() to
> >>>>>>>>>>>allocate all generic irq chips for us.
> >>>>>>>>>>
> >>>>>>>>>>This patch seems to somehow break off-idle for omap3
> >>>>>>>>>>where it no longer wakes up.
> >>>>>>>>>
> >>>>>>>>>Sure your bisection is correct ? This patch just switches from l=
egacy
> >>>>>>>>>irq domain to linear irq domain.
> >>>>>>>>
> >>>>>>>>Yes, I tried it a few times. Just enabling
> >>>>>>>>retention idle hangs too with this patch.
> >>>>>>>>
> >>>>>>>>Maybe it's omap3_prcm_irq_setup that relies on
> >>>>>>>>11 + OMAP_INTC_START? There may be other such issues
> >>>>>>>
> >>>>>>>lol.
> >>>>>>>
> >>>>>>>OMAP4 has the same nonsense.
> >>>>>>
> >>>>>>made me think why (if) OMAP4 works with that same setup. Does wake =
=66rom
> >>>>>>OFF work with OMAP4 ?
> >>>>>
> >>>>>Not without similar changes, omap4+ has the same issue.. There's a R=
FC
> >>>>>series from Nishant to fix some of this, and Tero is moving the PRCM
> >>>>>into a driver.
> >>>>>
> >>>>>>Anyway, here's a quick little hack to check if that's the reason fo=
r the
> >>>>>>regression:
> >>>>>
> >>>>>OK yeah that's along the same lines with Nishant's RFC series in thr=
ead
> >>>>>"[RFC PATCH 0/7] ARM: OMAP4+: PRM: minor cleanups and dt support of
> >>>>>interrupts"
> >>>>>
> >>>>>FYI, it did not compile, needs to include linux/of_irq.h. But yes,
> >>>>
> >>>>I might have sent the wrong version as I had that same build error and
> >>>>fixed it localy.
> >>>>
> >>>>>it fixes the regression for me, Also now the whole series works for
> >>>>>me :)
> >>>>
> >>>>good to know.
> >>>>
> >>>>What do you want to do now ? Wait for PRCM to become a driver ? Wait =
for
> >>>>Nishanth's series to get accepted ? I guess the same thing could be d=
one
> >>>>for OMAP3 and AM33, then we would have a chance of having working wake
> >>>>from idle with the new irqchip.
> >>>
> >>>I can repost the current series as it stands now once 17-rc1 comes out
> >>>(without the build failure ofcourse).. if that helps to move it out of
> >>>RFC status.
> >>
> >>That'd be great. It would be ever greater if you could add support for
> >>OMAP3 on that too.
> >
> >Yeah sounds good to me. Tero, does that work OK for your PRCM changes?
>=20
> Well, this set seems to break PM. suspend-resume on omap3-beagle just han=
gs
> after this set is applied. Works fine without it with 3.16-rc5 tag.

did you apply the quick little hack to prm3xxx.c ? prcm IRQ is hardcoded
to 11, once we switch to a linear irq domain, irq_base may change.

--=20
balbi

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2kl5AAoJEIaOsuA1yqREiZIP/3AjKM9gbUNdAQNAg+9LNVOn
uXFbQ4ssgTGOlNzsAWY1QIG4Qz9H+rZA9JJEkl2phipZQkXFiGRuorHS/7dHwB8T
AaR5XNSu0vBL3LlVCivx7rY38BKT3+b8SNuYNsrxMuXO3dlo7JgkoQFyf2bSV/eX
HFBAeRRp4Dp/W9nTYa3k5ynoh+em2LThflyS8fZE4wM1F7pEypuBcoLs7Swq3w84
cb3soHBkoVktgKJDsXi0x1rasm6jYPfNy43jAFosrNY8G6cq5/REdNx86bQKGMKh
oBpV1vvJgTlcK+mo7pRwcHH7JcgzphA+aaIGaRBmauO1IMXsybxd2yi8aKuGVFaZ
rnhLUMoTVHvvyKkXw8peAVtE8TFoTh+CiPIzYd8AbnCvF1z5BQDRJOAgs2ji9JBX
Myj813XYANYw6XB604aue1D6MhtuMtqn9Vdz/+8I9Pon9UesXW95KwAhvu00/cKM
uapz5my2nF/8+NcQSrwJ13jDE80OH6RtZadVfClDyevVAjXMw4cNS221zfuFb0tf
xg7zsD141azp2hbiWMLT3a+lpYswxtT/oqLPxbNWAp9fssd6qC+pkn4gnptGcy67
ZjgoCP4C646Edr2CCdyK0WBjeIGwoSu+KJNbsqfHMnWLeRsoKN/wtTH4jKN56FN4
O9dRnS1yjjrLU+PyEPv9
=MxKN
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
