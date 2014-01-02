Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaABSu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:50:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33402 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaABSuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:50:24 -0500
Date: Thu, 2 Jan 2014 18:49:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Message-ID: <20140102184959.GI31886@sirena.org.uk>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-3-git-send-email-sboyd@codeaurora.org>
 <20131215113337.GB14818@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/dHhfKPS6kpMPPhT"
Content-Disposition: inline
In-Reply-To: <20131215113337.GB14818@core.coreip.homeip.net>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/7] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/dHhfKPS6kpMPPhT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 15, 2013 at 03:33:37AM -0800, Dmitry Torokhov wrote:
> On Tue, Dec 10, 2013 at 03:43:11PM -0800, Stephen Boyd wrote:

> > +	regmap = dev_get_regmap(pdev->dev.parent, NULL);
> > +	if (!regmap)
> > +		return -ENODEV;

> And you are leaking memory here...

He's not, dev_get_regmap() just gets a pointer to an existing regmap -
no reference is taken and nothing is allocated.  It's a helper that's
mainly there so that generic code can be written without needing the
regmap to be passed around.  The caller is responsible for ensuring that
it will stick around for as long as it's used (generally by having it
lifetime managed with the device).

--/dHhfKPS6kpMPPhT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxbTUAAoJELSic+t+oim9o4oP/RIh2uLG4+BXSthcSYsyI+Id
YQTx3WPGsD5E+8fKeBzN2u3nelU1uFmC21merUz2oQCNewz++CZ7F4r/4zDa6OJE
ozbtLcLTL9K2kU7GoQiEe3dQ45C0izP9cwztsv2FL8vQvi/RrlzQnzs9GUhK6cF6
SjN3OQIHuNOwiGICStETkOOplp1TyFyVq5ATGU47Wv8/kK+7cpApBipZddHIePzf
wjV7yY4AIk0PcZGgEw8yMbS3V9g0RM11VzezMwtx5VXzuchHW44LzcfnQC/nQnkH
pKN/7o9kA8sEbR5y8rrjBKLX3ZhTnGvzGU62+psYhVwqb60fQjsJNWMTmTtSkrbW
JlzDrlwGHb0UMcJjPGMDXeWOmbhtvEWai4Nlv9K/XBT15gaHMvmCj6+TVVWK1rEZ
NTOZObsrEnx8OwmU+6c4Zf3CQucU21nijLk2aGapIkOJ53UMYkCqqlDTi/m3K8pw
1f/JbOthIc09w+ekulm9RNzVJuUBaSk493C3KXdmYvemygDVkx7EyMOwp073ZkR5
oec01e0rmpCVvR5UBKEcZw1I7JuQOKWWkdX028/leZpFB4UZn9l1oRaa3Tsjg+JN
qYwh79iBcpb4sxQueaB8FFtgsbuF/4RTEetmzp2ouVBII1WM4l4KItfqOHfIMbCR
CeGOpr/i3Y7/IUXvF26f
=eCpS
-----END PGP SIGNATURE-----

--/dHhfKPS6kpMPPhT--
