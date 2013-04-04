Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011Ab3DDHQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:16:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58157 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763988Ab3DDHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:16:12 -0400
Date: Thu, 4 Apr 2013 10:15:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <sylvester.nawrocki@gmail.com>,
        <rob@landley.net>, <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <mchehab@redhat.com>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/6] drivers: phy: add generic PHY framework
Message-ID: <20130404071534.GC30287@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364993634-6378-1-git-send-email-kishon@ti.com>
 <1364993634-6378-2-git-send-email-kishon@ti.com>
 <515CC123.4060402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <515CC123.4060402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 05:54:11PM -0600, Stephen Warren wrote:
> struct phy {
> 	struct device *dev;
> 	struct module *owner;
> 	int	(*init)(struct phy *phy);
> 	int	(*exit)(struct phy *phy);
> 	int	(*suspend)(struct phy *phy);
> 	int	(*resume)(struct phy *phy);

I wonder whether it makes sense to provide ->suspend/->resume callbacks
here. We already have dev_pm_ops providing those methods and we can just
wrap pm_runtime_* calls to be called by consumers.

--=20
balbi

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXSiWAAoJEIaOsuA1yqREFXkQAIP3OrjLQw12ylU/UHkhNtSJ
B9qlFZyTCIGB0Vt9B3LZj5E3Vr7+GjR6UVbgC4FrYGJ57kFM7bzF/s+4r/8IjHzQ
OrVRwpQButjAQZ6AgOd3rWMl2GvV60Eq6qlaWxWnjYLlzyBon1ThFPcOqBwDXaxi
FwADvC1Yi1RqPDyvAUz+awgwZI11F4PRv+CQtf2kzDrbSdyrM64IykFGzhe9SrMJ
50A6YUZ2DSniypLc53dYFgaLQSatCBPVT5MAMrvGABE7XyiAN4WHYpWco75FfaM2
/FGsGfp2JBewuWYOV/M2ARnE8YVYYMQYaBMlf1i0wdFmW4VWRbcRYeMPAKpjAOJn
QLfhRyfDUeKb8L6IZxRLHo0LnF3UUXy27EmtZBAFGXDa2fTIieJSE1KE3nR9K9CF
AKFdNwBxW54Z/FBn9atxJQzZcWaoVkp3iQhdZK3Nqhg5k5AaO5eZssm+YEPRMiZ0
yjSintNTJDLR1JCwX6f4fgXgPhrKt48y7XdReHpeqFPZVnSCB4W+Y4STHI4sw6N8
975ACZvbnw5NA+FpNwrBxcwsyQ7CdodsLsRDDlRrKRlu3jedXy5dhtIVu9Q7bCNn
g5DK/nQ7mrVAZMpGN240eAdZszGR78RgZAL7+90YcoKJT7Kns667clNN2giJ6Tn9
QbXnLOdkrSFA1+UF2k8E
=jF/V
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
