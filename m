Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203Ab3GLRbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:31:14 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58641 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab3GLRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:31:12 -0400
Date: Fri, 12 Jul 2013 10:31:02 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
Message-ID: <20130712173101.GA9677@dhcp-172-17-186-34.nvidia.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <51DFD3F3.9050704@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <51DFD3F3.9050704@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2013 at 03:31:23PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
[...]
> >  	/* set the number of lines as 4 */
> > -	readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
> > +	dw_pcie_readl_rc(pp, dbi_base + PCIE_PORT_LINK_CONTROL, &val);
> >  	val &=3D ~PORT_LINK_MODE_MASK;
> >  	val |=3D PORT_LINK_MODE_4_LANES;
> > -	writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);
> > +	dw_pcie_writel_rc(pp, val, dbi_base + PCIE_PORT_LINK_CONTROL);
>=20
> I guess here we need to make this configurable. In Jacinto6 this can be e=
ither
> single lane or double lane. Maybe we should have a dt property to specify=
 the
> number of lanes?

On Tegra we use nvidia,num-lanes to specify the lane count for each
port. Perhaps standardizing on a generic num-lanes property would make
sense? Cc'ing devicetree-discuss mailing list, maybe somebody can
provide some guidance.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR4D1VAAoJEN0jrNd/PrOhb+8P/R9XTnmRnagQbeovzw36VZeY
UFkIARUXseo9iQj6FHp+WjgQMwYV9PEe2r97NPOD2DAWTe/qIXJVfQdMBAUPjFgJ
oueXtJIu9iG7QIKNxPI/tqTKVgQWkE+8FvxQfaH1oHZZ9ydMEn/WevP2f6jY+ZK8
1YMCzaG6aem4QtHe6g2B56yHZafxOi59vYIVooGKmdMkyh25cnRVzm4/5K7aBV+Y
s97UAbeeWc86qaXoTVkdIjyu57Pdv6fNqFeDRG8r3oSRMTRsgKQuUcy+rEUpGCaX
wrATPfy82/jCAio0wKULPoxHxkoNFowf3pBl+fO/id0609Ul93OzbKWA+QavTHFq
y9liN8BfRWA5FUjEzAelJPrxK3kc4HHTx55dsl9P71Tw4gMjwUJlD2NJrXmMcbzD
JoJXXSGqAKVJFXp4+lp+O8KKmTvGNag8CpWsOIEgKIiJaaYNlvsMsM3OwyFq35GM
9BoFUfB/X5eeHh1+jwr+ql7dcDnaLryoZQtLw8Ojx7NlRVivs/D8TKojxcOBfVtV
CFm+hKjnly5yViBNwg4nwLxtfw7+7EYGuM4vSESPJspvCqUQQjZDA9/n01DDPlY1
1Kc7BgPDV/Gx76A2Wt3qgsanJL2SrNzeRpPlC3sJwaNhID7XfIWNh43SLDWOeQT1
d6feosqRes5b5GqnBe77
=RM/u
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
