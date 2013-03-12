Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab3CLStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:49:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36273 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933241Ab3CLStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:49:15 -0400
Date: Tue, 12 Mar 2013 18:49:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH 17/25] wm97xx: don't use [delayed_]work_pending()
Message-ID: <20130312184912.GQ19942@opensource.wolfsonmicro.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-18-git-send-email-tj@kernel.org>
 <20121223095450.GA17407@core.coreip.homeip.net>
 <20121224161827.GR30837@opensource.wolfsonmicro.com>
 <20130309235336.GA22734@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SlnaBQtdWG0gYnqZ"
Content-Disposition: inline
In-Reply-To: <20130309235336.GA22734@core.coreip.homeip.net>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SlnaBQtdWG0gYnqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 09, 2013 at 03:53:36PM -0800, Dmitry Torokhov wrote:
> On Mon, Dec 24, 2012 at 04:18:27PM +0000, Mark Brown wrote:

> > I'm a bit nervous about the fact that currently both the pen down IRQ
> > and the coordinate read are pushed through a single workqueue so are
> > serialised but after your patch they'll be split into the IRQ thread and
> > the workqueue.  It *should* be fine but I'd have to sit there and study
> > it to convince myself that it's safe.

> Mark,

> Did yo have a chance to review the patch?

> Thanks!

Sort of.  I'd be much happier keeping them serialised, it's too much
work on legacy code to convince myself otherwise.

--SlnaBQtdWG0gYnqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3iiAAoJELSic+t+oim9pEUP/1Rhg57ttorzU1PxnieMqh9c
H4f/GmzqIoaw/7JnKfkHQXD7Y+WahAvgdw4MLhU4qFq6T6pSunF1gOr+IilBoY3z
uSzfmqk4nP4BVk/lzKwGWm5Qb5QtNSqd/azTSOmg0AJOljONbT4eM0zJHaSJGcDc
+64DImwQQHp3kP9cdsqAoPPk/WeYOU8jBTJSPBeBKU9gn3j/jl+TDWteKnZcoDkN
PIOKIRh149dRjQm5mcYsaokufGWTkgBJx5CUOOc+6/uZGYQY5DbUGZS3/dXWaK3c
6DvtB/QXNlwy7Uu4Iv2+dESBu+t3MG1R8ESNhvNsHwtyniCzeZQ9stmyHxpvMeRB
4Qo64WKMIHPgJpT7ipcqLBEKD3RmJrGSD+AlCrl7ZL2BiKdceJfOHyL42G9EaIcX
/PPMGj6K1/NQmeSeAN51fWJrKcyCn15SjQ+5kVLY/j4U3h/hYlN04Lt2YgCMFq+S
Q//Ebs9FFrPQyZ9NHBRhKQ5DhqlWY1Ul1sb171WCoMrb+oahuiOSOrZBxv18u1zf
A2BJUmZM9zJeX7KGa5wNe4nItLgCyOv+sP0k1R+Y5UwuYhIPE+j+B+YdoOB2ZzQo
WFwUGDnZq1gBKAJ3PooAffR6cEqyZlaJqC3HWcGh1LWASKvnVByGc1BXmjrfipf3
3/O15u7My0fx6u1dVhXy
=KID1
-----END PGP SIGNATURE-----

--SlnaBQtdWG0gYnqZ--
