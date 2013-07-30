Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3G3RYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:24:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60899 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3RYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:24:40 -0400
Date: Tue, 30 Jul 2013 18:24:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Ball <cjb@laptop.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130730172413.GW9858@sirena.org.uk>
References: <20130730114502.GQ9858@sirena.org.uk>
 <864nbcte4j.fsf@void.printf.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1hYC8G2yr6txGRN"
Content-Disposition: inline
In-Reply-To: <864nbcte4j.fsf@void.printf.net>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] Optional regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N1hYC8G2yr6txGRN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 01:40:28PM +0100, Chris Ball wrote:
> On Tue, Jul 30 2013, Mark Brown wrote:

> > Right now all the MMC users are converted over as-is, though it does
> > look like drivers such as sdhci really ought to be insisting on having a
> > regulator for VMMC in the same way that the MMC core helper does (and
> > indeed in that case it looks like it ought to be converted over to the
> > core code).

> I didn't follow this part -- I don't think the MMC core insists on a
> VMMC regulator, and I don't think sdhci should either, because e.g.
> an x86 laptop isn't going to have one.  What am I missing?

You're missing the fact that there will be a VMMC regulator there since
the card needs power to function, it just might not be one that software
knows about or can control.  If it's one that software can control
that's not mapped in properly (eg, because the driver for the regulator
wasn't loaded) then obviously that's a serious problem and power saving
features in the regulator API may for example turn off the supply even
if it's on by default since they can't tell it's in use.

As things stand the expectation for x86 type systems is that MMC
controllers attached via PCI or USB ought to be setting up a fixed
regulator so that the consumer part can proceed without ignoring errors
that might be serious on other systems.  It's probably not a bad idea to
do this anyway though hopefully in the future this work will make it
less needed.  For embedded systems the system integration ought to be
doing the same thing, normally as part of the configuration of the PMIC.

The goal of this series is to make it much easier for the regulator core
to transparently support such systems where the regulators aren't
visible to software by transparently stubbing out normal supplies that
really must be present somehow for the hardware to operate without
confusing things by also stubbing out suppies that may be missing in
normal operation.  This is the problem for the existing stubbing support
- it works well for normal supplies but it means that any consumer that
wants to handle a supply that's not there can't tell it's missing.

--N1hYC8G2yr6txGRN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9/a6AAoJELSic+t+oim9tD0P/1nZKP1GVe7cQl52fJ1rK9Ol
CdMOkU3mirx4sIt7ndi0GVRuZZCivLLC/QECuoiQIQ12VrLOLcZUGlxO+vkLFEnR
GTs1SjJIvET5clnvI/fI8hRFYrpm6CNm8Dzf50maiin1JNll0uto6fV2Ke2UHSOb
9QgQ/8tHxFuy5XMHmrLV9CVvqmWMoPzvjbhF7cKCLduherhKf5NWEgt3P2bnOF+E
/c9XJj2KIU/Vdwb/sLCtOsQsnW8Urjm+2dqbWbJ+Ka3b1j/8u9otxnwgcdd6o3pf
jrJF8/kVILsPpKCf3cI3hNTS7eHZ/vYAhS7cPpsiPUZOaxydWJSJbyOr+mhOpbGF
k6eVCdt4xcC5G2un8EbS97YEIkDQvKNUrZs02utcdEn5HguDc7E2w4VNB07jv7FR
ovEcBxjTEZDkJuqNYMNvMxRYEjDXZcYlZTeVjUe6PkUP85qYXTXB8l1ZbFlQeHXW
MH96vl/3OOnF6iD0HeHVhYMdJmwaJSbrjM7NcH2p6dcIRjMGoQHNp/GDTMtehX56
m+Obb2AXCqas1twAu2bo0BsQAJBW3yf9lm8x/cfHFP3pSsXP2IpH5YIVq1a1gywP
Zc5H5HWEzBgVFNoanDbRVH2RQLA95CsUA0UXSpizBS2J5YpK6FbuY51uA+lMCcfL
kwQB/F/5ORqOO+qOMQm0
=tv0Z
-----END PGP SIGNATURE-----

--N1hYC8G2yr6txGRN--
