Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375Ab3DEGEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:04:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3DEGEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:04:34 -0400
Date: Fri, 5 Apr 2013 08:03:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/12] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130405060351.GA15848@avionic-0098.mockup.avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
 <1365000318-28256-8-git-send-email-thierry.reding@avionic-design.de>
 <515DF096.2000703@wwwdotorg.org>
 <515DF0D9.40007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <515DF0D9.40007@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:61xdPHnasXlt1RvazNXKG8OWyhupSI92cNgKKRppmPd
 Gevect2i4Fg0jTm2drO70j/j0/PkPLXlHgvfXLPuNQF+nbDMes
 8xHrdg8fFyS3mxa9hahfzsYHlgCgPSxadEqYSyc7+e7a2tqzdO
 ApTeuLYKqJkFGvSEEdKVBqIhLywiV5dt/jCfT9faE/iXZcaD2T
 LzNEm4SPzWHpJJMBd64tyHE4/zm8YRgpua4xPiu4WFK6dD+2n+
 b80gpc6OzEaLCswGx8ZYcahau2TWTOHOUi+Yp2I73zOREodP7s
 zJTtO/jLkdV7AF9eXtRI8c8Wy0zvyUSS0WtPPTqzpn9v7sA1Ir
 mws+4Rh5LEfFNlv1f+V8P83WyA0CL1t/XP3Lsks2VA01pX25NN
 4V//GM+EwiqUeJdSF63Bnm2gNp9QyDQ/wbe+FR0wajpG5QkskK
 hB4Sd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 03:30:01PM -0600, Stephen Warren wrote:
> On 04/04/2013 03:28 PM, Stephen Warren wrote:
> > On 04/03/2013 08:45 AM, Thierry Reding wrote:
> >> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> >> directory. The motivation is to collect various host controller drivers
> >> in the same location in order to facilitate refactoring.
> >>
> >> The Tegra PCIe driver has been largely rewritten, both in order to turn
> >> it into a proper platform driver and to add MSI (based on code by
> >> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> >=20
> >>  arch/arm/boot/dts/tegra20.dtsi                     |   53 +
> >=20
> > I guess this has to touch both the driver and the dtsi file so that
> > bisectabilty isn't broken? I guess that's OK.
>=20
> Actually, can't you move all the *.dts/*.dtsi changes to the start of
> the series, then put the driver conversion patch last, to avoid any
> bisectability issues and still keep code and DT changes separate?

I'm not sure if that'll work. There's this oddity in the Harmony DTS
where the regulator@3 is disabled with a comment that this is a hack
required until board-harmony-pcie.c is removed. If we change the DTS
before the driver rewrite I think that would break requesting the GPIO
in the board file.

A possible workaround I can think of is accessing the regulator from
board-harmony-pcie.c instead of the GPIO directly. But perhaps such an
attempt already failed (deferred probing getting in the way?).

Since it looks like this series will not make it into 3.10, maybe we
should try and at least get these things ironed out so that the merge
can be done more easily in 3.11. One big step in that direction would
obviously be if we could get the DTS changes merged already which, as
you point out, should be independent of the driver rewrite itself.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXmlHAAoJEN0jrNd/PrOhm0EP/jaE+4AqxS3UniRXtEt5ooLB
HnAII6XrN3WWhIthBQHNPWZeWI0uRSAa7THfE+/x38TiG16pkm1l1RWUgY/dM+ma
6pty8WeO+wjx0CavfjBslDk0+yEZKdpKiNBnSvRlFkfqSw45cuszCz9JuV/ua3gK
akR44L1SnbroifdvJ4gJYo1RDl6eoV88njApi8BtnhssVgRW3TSPYjTD3OK1qB93
BPoEY3mGExBgRZi6wDXcddqP+pT2WUdKq5362zFHIiyNJl5rc7Bvhlv4vLu+KZFl
mql/B5RzYPFAwnw73eyEa+ak6v6m7uXETF3m0r4EySqG+1FDLv6C2if1GSqKk7HM
dJelC8wJLDSmZ5Yzo758HTvwlFAmGjHjmjYRUSfBHWL2C+kmBCGXdrJgS//6SEkx
d8F0JJGX1yvsyvOr0xNOcqbYhMzmaiwLaphCD9DMKKJGxzUW/i5i6LpFsOmdq14a
mh3ARP1YjjxelhAgh3kz0iBtBeeRy4/wdC7mO6X3hI33WRZazyIIa60T3zPAHFnW
UOG+zN15NJBJ//YyaLjqD2eEuMQlEHsHwyzJ+n+dX5RCR1D1wlAoFIedUSXFPYsS
z6+M9+qPofYovv1iDE/LYqR480vZ+kljGF+2s75qNMcJ45GwQZtxY/QJ0v9JUpVx
0dJFSH5J5yDNUin3HsNa
=Akm0
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
