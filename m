Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbaGYQsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:48:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:47398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934489AbaGYQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,732,1400050800"; 
   d="asc'?scan'208";a="579002504"
Date: Fri, 25 Jul 2014 22:12:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA
 Controller
Message-ID: <20140725164218.GW8181@intel.com>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
 <20140725163746.GC20328@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <20140725163746.GC20328@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> > Can you please send follow patches for these:
> > - don't recall if I pointed earlier, but can we use direct conversion f=
or
> >   calculating convert_burst() and convert_buswidth(), latter one at lea=
st
> >   seem doable
>=20
> Ok. Do you still want the error reporting for the invalid width and
> burst size?
I think for convert_buswidth() we can do away with a switch case and convert
the numbers directly

> > - don't use devm_request_irq(). You have irq enabled and you have killed
> >   tasklet. This is too racy. You need to ensure no irqs can be generate=
d before killing
> >   tasklets.
>=20
> Ok, would calling disable_irq before killing the tasklet an option for
> you ? that would allow to keep the devm_request_irq.
disable_irq also does syncronize, so it might work. But then again if the
probe fails after registering irq due to some other reason, and you get into
races with unitialized driver as well.

I think it might be easier to amnge by working with plain old request_irq()

> I'll also send patches for the various breakages and warnings spotted
> by the autobuilders.
Yes please, I havent seen the reports in detail yet, but they are reporting
mainly due COMPILE_TEST. DO you really want that?

Yes it did help me to compile for ARM, i didnt see any defconfig which has
this MACH in arm/configs

--=20
~Vinod

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT0ojqAAoJEHwUBw8lI4NH1hcP/2M79gbU1dKMQjeJczE17TYm
iGDQLmzWjqT4f5j3ILEp8egQdpB2YnW+h9T9yNMuAh3ykA1Ujum33mH6FygwAXa6
LIMVKvTCxfyhRldXXryoDMyjasZBBBVCkQC83vzk+R/WyEO8y79jhEFzlx99c6O8
7QZUxiJR8odRXzHygLaingZQm/nG9zkdMUfUDystmEf/oRnDrl6oI/D96/ptJ+Qg
2xIg08QFyKiRAxyjdx4IGPPkpqV7+x3oHX4pAS8Ftfv9U16y5sPoqCam9AI6MeGQ
qP9pp4RIcYWG33ybNS8r96DZrl+hL8QjjM/BTZw+fxbM6AklnsA9dVAePrs4sA4D
TSTJqexAgxhW/t8rZjkap05xRvSO44gI7SqmN7WPDtnsfyex8TrMim5nCLrVmZ0h
T3kKAVK13xw5BK1skbce2KXVLICQkZs02gudlenNYiNM3IGXL8yf04TgsNj5PvZR
3mxh3yVvgEHh6m6jIgsVHo4HDugByU1uN8DAI1HEBWg8J93TF1Isyo4yDrrxtsGs
rqvKSMATIXtcGg/ASwsxHlId/Yan/XOiwhMSzTWqVEDrM0PAlFjwagWWWBJhKE4X
0Ns9dmJMfAm0HsfRW7prnZWSCpXm/oRJfEav3M6uZFxLQeC6dKQPFHTMkrKsNthh
n3G5I/PsX46h+L8KISWJ
=jXkd
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
