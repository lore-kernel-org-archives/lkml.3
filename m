Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3AKDkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:40:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3AKDkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:40:23 -0500
Date: Fri, 11 Jan 2013 04:40:15 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130111034015.GA28094@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
 <50EF54B6.6010100@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <50EF54B6.6010100@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6qRNFh3Yk+QQpBMJUV9DTy62+xl1OteNXh4D4LVwEaC
 Fe2j3FiB+gDsoVnU4t7DgILomQbzwjO8qI9QBZnZYr2bnI460P
 pHOUJLh3rrrRIaPGsbH8ceGlBMDPzkW96zpw5utSxOMVnraM5G
 BG7etmgCptaRps0qkKbavdfjly76ZD7XFxOHmrb8sl5Tua4y4i
 GThuvOycqQHSX4HaWcH7S0VEOBBiXu41PhLWVOwDtzy7VCACZR
 RK4vF1Yt+/dTWCdr4oJVWfOiWTtEr7fvzycUqbTIid32FjZicN
 mC98reXLZiWmCFWH2ZmCCMTIq1dC3W+2o74r2gy9avBnLE27A8
 UFOU9p/nvpMHqHD8eNMRPyB0R35SuL0bU+n4u+zeUukg1g1GMT
 rDEKg/Yv7WXtzHDY8cSk4X5kqBhJACEnhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 04:54:30PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> > directory. The motivation is to collect various host controller drivers
> > in the same location in order to facilitate refactoring.
> >=20
> > The Tegra PCIe driver has been largely rewritten, both in order to turn
> > it into a proper platform driver and to add MSI (based on code by
> > Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
>=20
> This driver doesn't compile unless CONFIG_PCI_MSI is also enabled.
> Should it select that, or contain a few ifdefs?
>=20
> drivers/pci/host/pci-tegra.c:900: undefined reference to `write_msi_msg'

Right, it'll need #ifdefs around the arch_{setup,teardown}_msi_irq(). Or
select PCI_MSI unconditionally. Once this is merged I was going to post
a patch that enables PCI_MSI in tegra_defconfig anyway. But it might be
better to keep it optional anyway since the remainder of the code copes
with it properly.

Thierry

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ74mfAAoJEN0jrNd/PrOhjbsP/2W/s/cNZbYyUEqt7o5TBlFQ
fthSHLtiGCfJ3L+20feBFQ0gS6sQqC4uqvBPJG28g0hwXnAuJrIpzvu0JXfTH+cZ
USPeEIV/pJBhZV15b3v53wFbNvGAAr/44nm1XEyjtmNd/HEXH4hlupBWs+xzUA+z
cJJPtu8HaMvS67D93cj5IEDHaC6YMs12xK52/IQThOxqV50sa6bsnwqB4X99W0bj
TdJZBnUcVpOzHc2HXcuyqzMjwlH0k8RVJLq5sBz9+mjUwkLjrHy5a8DBQ0pnOQEF
y7BmSEpwpqMl5aHN/7zr9WM5WWlmLNN0puTc0s81Xb8bEm6HfXjbLY1YEYQbOmTb
+maRcSNKKwmp7EPun7iTHxLOFCIKqSRUe4erV8SsG1IfRPFoc3LCmznNC6He+YaQ
bu3H3+IcgId75p6fQ883TEWHlrYbzkaAgeudmVZguDTE8UbDw23C7YDeOP0UQMT1
PAJNLCv5vDdcG++TqBa2T5gLQ1L6mrDu1HzYq+YyLnvOu+af+6NN/UakdDg7qHy8
yXIhG0COBPc35fM0e/3UTp2fenEpGI9nNGk01tiRXCw0uURES/F7sw0MspQ0IgxF
Y8z8cw8cQwIVSx11+qJOIhIRFNR/IsGOViMUZsyx2g1JPvzwXP2OgcCNv6gu0bgN
j8Lgr4VVNq943c+Y6ds4
=nSC6
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
