Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaEHDVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:21:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753121AbaEHDVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:21:11 -0400
Date: Wed, 7 May 2014 22:19:49 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140508031949.GQ7047@lukather>
References: <20140430070408.GR32284@intel.com>
 <20140430215322.GH3000@lukather>
 <20140502163429.GA32284@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZqRzwd/9tauJXEMK"
Content-Disposition: inline
In-Reply-To: <20140502163429.GA32284@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZqRzwd/9tauJXEMK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 10:04:29PM +0530, Vinod Koul wrote:
> On Wed, Apr 30, 2014 at 02:53:22PM -0700, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Wed, Apr 30, 2014 at 12:34:08PM +0530, Vinod Koul wrote:
> > > On Thu, Apr 24, 2014 at 04:22:44PM +0200, Maxime Ripard wrote:
> > > > +static inline void sun6i_dma_free(struct sun6i_dma_dev *sdc)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	for (i =3D 0; i < NR_MAX_VCHANS; i++) {
> > > > +		struct sun6i_vchan *vchan =3D &sdc->vchans[i];
> > > > +
> > > > +		list_del(&vchan->vc.chan.device_node);
> > > > +		tasklet_kill(&vchan->vc.task);
> > > > +	}
> > > > +
> > > > +	tasklet_kill(&sdc->task);
> > > This is again not good. see http://lwn.net/Articles/588457/
> > > At this point HW can still generate interrupts or you can have irq ru=
nning!
> >=20
> > I'm not sure to fully understand the issue here, but what is not good?
> > the first or the second tasklet_kill calls, or both?
> >=20
> > From what I understood, the issue is only there whenever you are
> > calling tasklet_disable without making sure that no one will schedule
> > your tasklet before disabling it.
> >=20
> > But the point is I don't actually use either _enable/_disable. I might
> > be wrong in not using those functions, but I don't really see how I
> > can be impacted.
>=20
> Well that was one part of it. How do you ensure the tasklet is not schedu=
led
> while and after you are killing it. You need to ensure irq is disabled an=
d pending irqs
> have finished processing. I dont see that bit.

Ok. I'll change that.

Do you want me to use tasklet_enable and tasklet_disable as well?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZqRzwd/9tauJXEMK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTavfUAAoJEBx+YmzsjxAg1GUQAIJvJo2FmLNpbOUmzVPWz5wY
LFZYV/aWwzoMqH1ArnU3XaSht3I9rAu9xtthccqfYRP9OqGSFkhqUcLWq4vxqiKr
tIE5YFofDMPeQQkj712+gspRQuk69SeIZzC7U2Q1qlylseiozYR3we/ycEc1YzdO
BmV5q7kcsed3Aq/22bBqrK2qSi8pU3HRA3pUA7GHZyH9+QM2i4c90q8zkQtn9xZD
F1fsSUp+HBPrd7KvryaFWKraWnW4EcgXFVgLrk4YolX3i9nZd2g5hFESZeGbSzYF
yVFP0zjct0jyycp2FmdUyYm4MvnqCKRl7Hm8z3h3PwxSyvpA6qZsTcp6tf0XBdFe
1eJJQTFRN1cd35bzdnF125iOf7GqwETu48gK51UC88BCdQr9mYYNtEqUct0m7yNd
HnFL3eQnSeTrY0ec2TGrh9tCBmVdADiTFkXS6wWzPMVhLlPzRFU+zNA/3MxdWEG0
/Q1Tv2ooZnafL7L5/vrRe1DXa6Bt2LsgCJwwKFwscbtn4QMw6uCpWVbnER07NMAx
Yg/jSUGTWSx6CP/DjP1jqjAeykqph2vFZOgVQsD1cXWuyz5FixyYkmoWDV2suXtx
7Q0ACxI2VwFlRNoqkGNcls/kW2vEiUSDlUlDlojISv7Sr/jNebLc0Mss9st8aZfs
LHU8giirt3wsn1Cr4hEj
=mX76
-----END PGP SIGNATURE-----

--ZqRzwd/9tauJXEMK--
