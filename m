Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3AMWma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 17:42:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab3AMWm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:42:29 -0500
Date: Mon, 14 Jan 2013 07:42:21 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] regulator-core: update all enable GPIO state in
 _enable/disable
Message-ID: <20130113224220.GE5041@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 09:46:12AM +0000, Kim, Milo wrote:

> +	/* Update shared enable pin state */
> +	list_for_each_entry(r, &regulator_list, list) {
> +		if (r->ena_gpio == gpio)
> +			r->ena_gpio_state = enable ? 1 : 0;
> +	}
> +}

This isn't quite going to work properly - we need to actually move the
state (and also a reference count) into some sort of shared state.
Otherwise consider what happens in this scenario:

	1. regulator 1 enables
	2. regulator 2 enables
	3. regulator 1 disables

Since regulator 1 doesn't know anything about regulator 2 it'll not know
that regulator 2 should still be enabled so it'll put the GPIO into the
disabled state.  It'll be OK if regulator 1 and regulator 2 always have
the same state but if they ever differ then we'll not do the right thing.

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8zg/AAoJELSic+t+oim9fMIP+wSXvcRTOZGiiZTf7FIdYITI
aY2/BIoXBcAtoyP4exLGNpnmgFk4J4k3c8H5raGO7UkHpTE4ptkJgKYa1m1FZwuU
VLPMgEOMk6C6S26yqejzORfYdS+t6DCiy9AdbUxRFXp3fRxTtGYn6iS/h5zGCjlo
k7JsMVZgxU/x/CkJAVdBBg+nd/1BdOtRzTMNPL2SsdLyOpNwAtBp7SLOl60LiVLZ
LOR4+orKBgHjHCZJR18GD0fuMx4fe+s2cnOLN68PctzTA0oWJSQjbrAiovbI1pVM
h1EBhhhssNYrdg+XPWbfctpg9zr6rZF5liXhzDXxPaH5+d/XhbG7XCYoYtGkfwVl
6wXOwRG3PXx2mHM4wSYdr1qV4reKAybczStb8jk8tzLse3T68gikNAcxjnct3BnC
QxAkENImlJBvHGQk0B2HDjnJR1LJC4K++t50Zyt7xQThEtyTjkXkvUk1HjlAAw4L
mdKOmbJts5enMqshk1fGp12MD1QwtvxkdlnZXTCYwpglXwCzGvkCMfgRtPseeKAF
ei4ZaPnbdOVp8MF59PXHi8o+0WwmBdF2L33TxTBBq1BCZTFKZqeOGqGDSP8RPl1R
qPCnwB3SxhQ4lllrg5QkF/2n6NZwOdDhDcQs/ugEQ3bZgWzJ/TVOiQ5jRzn8AUCZ
OzvtnfCv5osqAgcj+Vud
=oeda
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
