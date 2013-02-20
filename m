Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401Ab3BTNLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:11:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37311 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935129Ab3BTNLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:11:16 -0500
Date: Wed, 20 Feb 2013 13:11:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130220131112.GE2726@opensource.wolfsonmicro.com>
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
 <5123C18A.9010604@wwwdotorg.org>
 <5124C18F.6070108@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <5124C18F.6070108@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 05:59:03PM +0530, Laxman Dewangan wrote:
> On Tuesday 19 February 2013 11:46 PM, Stephen Warren wrote:

> >In the older Tegra SPI drivers, the PM runtime logic was was of
> >master->{un,}prepare_transfer. I'm curious why it's implemented
> >differently here.

> The prepare  is called in atomic context and in this we are calling
> pm_runtime_get_sync() which is blocking and it can cause issue.

> I have already bug reported by you that sometimes you saw locking in
> tegra20 slink driver which we need to fix. When testing this, I ran
> into similar case and hence now moving this out or prepare.

> I will push the change for fixing this in tegra20_slink driver also.

As I think I've said before I keep thinking we ought to just have some
basic runtime PM code in the core - a substantial proportion of drivers
end up following the same pattern, it'd be surprising to see hardware
that needed a different pattern.

> >>+	tspi->clk = devm_clk_get(&pdev->dev, "spi");

> >Does this HW block use multiple clocks? If not, I think s/"spi"/NULL/
> >there, just like the Tegra20 driver.

> No, spi controller uses the only one clock. I will change to NULL.

I'm never convinced that NULL is a helpful clock name to pick, it's not
awesome if you ever acquire a second clock.

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJMtpAAoJELSic+t+oim9kBsQAJY+ECq8UzL+o+K4tOJd1dnm
3NpsTeMXCZeitEN2HKqTZxHsX/CBKP/59m9ZVQzoF49bH7bIsxOW1V+DE8xT6vmC
JNQc+3yda9YdIzzBDwi+lQ29DfnxEUmLKlIwPIRnOpUzNPSTjQdJh7PgbwkAAIxW
ivVMo4UdqKkzhj3db3eIrUNlFDFVfdZqBmn83hGN9A2+jB65E66btbeH+DprrEyY
KsKGw4lX3xQ7XjdeAICraKlEXcdrmJ+zMsZSxHkZb6p2zWMnLknku0rDE4l9l192
CXgruSsyqiPEMo/SFSfKbbgE8Ls0qjFcyDzN18tCUuFnqLpXpxYlxFgHzGK5+1iy
w1MCODkBzpJwxxq6dPPZ1+3QGQUqzYk2YCTJfJ195n2/DXXa46bsff6bozoJvXWM
7Hnhl16hWkAdeC2+2+Q6lWd9573sC/wccyhCe02HjiVEOnYpgrqmSVMn/EOC6dpG
K6xpfhH2Qp+gveX/1QgJDkfW5QFWWyuPRf5CwEUduXgGhKDU5jrRpoU0///Tip9I
EAzaBHRyXKklbXS6GkCUjIh1dwUiqgcU/j8iZOPSIz600n9hpBCLfZpgLwUF7pBb
Nk1aofsSwgEh2HSESXQngQvItks4RSA9W326ysWcyhYlbauSC9N+a265aDG896ii
60M8Ex5wnO51wyr+DeKB
=AR5w
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
