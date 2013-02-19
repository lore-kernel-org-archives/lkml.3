Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3BSMOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:14:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab3BSMOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:14:32 -0500
Date: Tue, 19 Feb 2013 14:14:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Afzal Mohammed <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 2/8] ARM: twd: register clock event for 1 core SMP
Message-ID: <20130219121400.GP23197@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361186097.git.afzal@ti.com>
 <51235076.8040200@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4IFtMBbmeqbTM/ox"
Content-Disposition: inline
In-Reply-To: <51235076.8040200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4IFtMBbmeqbTM/ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 19, 2013 at 03:44:14PM +0530, Santosh Shilimkar wrote:
> On Monday 18 February 2013 05:07 PM, Afzal Mohammed wrote:
> >Register percpu local timer for scheduler tick in the case of one core
> >SMP configuration. In other cases - secondary cpu's as well as boot
> >cpu's having more than one core, this is being registered as per
> >existing boot flow, with a difference that they happens after delay
> >calibration. Registering the clock for tick in case of one core should
> >be done before Kernel calibrates delay (this is required to boot,
> >unless local timer is the only one registered for tick). Registering
> >twd local timer at init_time (which platforms are doing now) helps
> >achieve that with the proposed change.
> >
> >This helps in an almost booting Kernel (minimal) by only relying on
> >ARM parts for an A9 one core SMP.
> >
> >Signed-off-by: Afzal Mohammed <afzal@ti.com>
> >---
> As mentioned in cover-letter, I don't think we have good
> reasoning to make TWD to work with UP configuration. Even
> you fix the timer code, there are more cascaded dependencies
> which is not worth the effort.

if CONFIG_SMP_ON_UP is enabled, smp_twd.c can still be compiled, right ?

--=20
balbi

--4IFtMBbmeqbTM/ox
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI2yIAAoJEIaOsuA1yqRE1NAP/iHA7+rdIXK5Az3QtnfGtUGD
ur37R32eIs++SF480l/QuOaUpj1FK+qkRYvbjbJ7h7Ud4RT+cOqPIIPzcqPr14iK
V/oi1g3nTRKlt+m1vi93HWsBRazt6ZTVUpT223aoUWrja7Zb99k8BnGDeNSahzse
AIMsTI0Tk7cSDeZj5LFZ418X2lkorGi2xOc3uUyo9hsce3IhkCEnNzHa5D8UpX1h
Ltq5ADuV919H5Ix8uYVXyhhmqHHkigEJPS6pFQ2QFpxEolakUSp+9k0FnSpnS+DX
g64S9f150FdlEe9SNayr7r0YRJK3CPM3bwKXFCHFEV/XICvgtxnr+06bYvs8aRtM
QL2ZSutdYjrwUM1x9+Q9ioOGmSgYH9qqejeBVhqe36DM5fiwo4WkOuksi84a0SLt
7L05iXeKlWA3fRdNymc966fafzaUvRuyq3/6GMRnHhTJ4eHsq13oMK7e8249ucr4
M1NDneCKbSZc2TVp7H7fr7bwBh+pKXLha22V1S7avMKdTQXdgPP5vaN8Zvi/s2f6
Xi0zMAifHCx4bOz37tnbWf6bYYMp8GGUeCAoFKM4cxW3rFY4flUKbTAi4B9mfQW9
/DZZzJWV3IMaax6VwtEXmWrHRZbr4D/f2oKIh7wGddISt/wo5PX0o74uC9h2AT/S
wF9PIl5EOq/2pau2tFa3
=kqVe
-----END PGP SIGNATURE-----

--4IFtMBbmeqbTM/ox--
