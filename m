Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3CEHDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:03:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3CEHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:03:11 -0500
Date: Tue, 5 Mar 2013 08:03:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
Message-ID: <20130305070308.GA7212@avionic-0098.mockup.avionic-design.de>
References: <1362433790-22560-1-git-send-email-achew@nvidia.com>
 <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de>
 <51355FA4.1090909@nvidia.com>
 <643E69AA4436674C8F39DCC2C05F7638629BFE1B02@HQMAIL03.nvidia.com>
 <5135774D.6080708@nvidia.com>
 <643E69AA4436674C8F39DCC2C05F7638629BFE1B11@HQMAIL03.nvidia.com>
 <51357B9A.8080004@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <51357B9A.8080004@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QqMF+TNHtSh0+DLZSNlyd+2ANcpJGjTQVblEVCZfLTk
 +nQnuBl4S5dOqL9tygtR3O7DbttHbBhvYOJjU03ArVUm6thlSC
 rcqVFG3tDJWhYyr2tsRiCC1vijTKm70Pt7+wq9VDFudESgjHb7
 6dEZrMSbFC/Y4bvT1Yjb3Othsp9McTn5txGREtvf5/cwUXK9KO
 u2Nq63YXUoFTO6avTy6xR+K9N2gmgmbU49D7tUJTRqK8yGeFLT
 4O2kRGFzUmNckVDI+OYIMJpEsNM3EyYuOPLug32l+qubTqQSRO
 iVZgLNK9JjcO2UF9H99doOjqLsy5EerY/xdjc44YfjP7QkFJqS
 CVehuESxuRpoXYVIRJCFBFXl2FodrlYDxgn8J420joHIfVEiUF
 J2S6wA9H0MPLxyJ/A18ORPctIBcbpqz0UjRrJ6vkepuxeyJk9K
 ZFX8/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 01:59:06PM +0900, Alex Courbot wrote:
> On 03/05/2013 01:48 PM, Andrew Chew wrote:
> >I sent out a new patch that enables/disables the backlight enable gpio.
> >
> >>On 03/05/2013 01:00 PM, Andrew Chew wrote:
> >>>I did come to the same conclusion regarding the platform data breakage.
> >>>I'm expecting that the use of platform data will go away, at least on
> >>>ARM, since we are all aggressively moving what used to be in platform
> >>>data into the device tree.  Do other platforms use this driver?
> >>
> >>I can see at least 29 users of platform_pwm_backlight_data, all ARM wit=
h the
> >>exception of one unicore32. I guess at least for the foreseeable future
> >>platform data will remain.
> >
> >I'm not sure how to solve this, then.  Any suggestions?
>=20
> In one of my (many) attempts to add power sequencing to
> pwm-backlight, I just added a boolean to the platform data that must
> be explicitly set in order to enable control by GPIO. I.e.
>=20
> 	bool			use_enable_gpio
> 	int			enable_gpio;
> 	unsigned int		enable_gpio_flags;
>=20
> enable_gpio and enable_gpio_flags would then only be considered if
> use_enable_gpio is true. Granted, it's not the best solution here
> but that's the only way to handle this correctly with integer GPIOS,
> and it does not pollute the DT anyway (use_enable_gpio will only be
> set by pwm_backlight_parse_dt() if of_get_named_gpio() returned a
> valid GPIO. Btw, you also want to check if the enable-gpio property
> exists first because otherwise probe() will fails if no GPIO is
> specified).

There are two more options that I can see. The first involves updating
all users to initialize the GPIO to -1 in the platform data, which will
remove the requirement for an extra flag field. Another option would be
to make this feature DT only, so that the GPIO can always be assumed to
be -1 for non-DT and DT without an enable-gpio property.

There's a third alternative, namely using a regulator for this, which
has better lookup support and therefore should be easier to make
optional. And as Alex mentioned it already has support for always-on
functionality and such.

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNZisAAoJEN0jrNd/PrOhya0P/0uT5dkPzPnVbT4+C2Zj67aV
Is+wUGkurEH9tEzMgodnx2CEEUrZ9pqn94MaAZ2+T3RP6wae1kAIV03eyZ6BBQRc
9pCYfKqhp5d8cbixey9B7rpq2fRTjDVhM49ICtBOe5YYNIjE9sGSSM/C6j8Ni0/a
+bfaNWwdjmweGXslfm53GvVvVfoZZ76AgtHi8Bj65QxECKJ6vM7UG5SV/VdCE/bb
52GZH3gGbrzwz2RTQI8XgrYcj1A765My0/tvSSFIrj9CVeM7VKTMu2QIoD+gvcw1
fIRBUjoJKDAmW2xdYZmfe/np07FPiLWLk+jsRkNfIMv2eNx/SAhs8ow9m+GjBboI
Ah9sytlGUMtc9rB6iqHeOdanpyxb+4j+XqSVLeyYYWQ1AlVUsi66ZMs+h4cqQMsq
Gho3w0F0/9rRBCwIQTdnU/INqk/qKmsfA5I9XvKQD9psOdkzAXAoUuTRHVx68Iwl
tJWPWpDO4iQnWewWU3CHzMnBNoR2/rCPOPpgAJh5AAcwwq56SViWJB6t3GEoa4lq
WYEGm5MV9lC+y2fRDIeIU2PbomjjXR3fjhs1njycJd+efwmqiSdji0SiEZ0BjYpy
zRLee56tIAdzkSi3vKTyqXJEpyND3G6GnWjBX/GxBLcfblE3PL5SUUIvPMMmIlHJ
3lK5rrqP0GnbHLinW2Tk
=sPsZ
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
