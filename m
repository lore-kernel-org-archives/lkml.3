Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaEZOwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:52:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43241 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaEZOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:52:09 -0400
Date: Mon, 26 May 2014 15:51:27 +0100
From: Mark Brown <broonie@kernel.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Message-ID: <20140526145127.GM22111@sirena.org.uk>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com>
 <20140523174925.GH22111@sirena.org.uk>
 <5382D8A7.7010704@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J0aV3cDZF7126fGV"
Content-Disposition: inline
In-Reply-To: <5382D8A7.7010704@linux.intel.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J0aV3cDZF7126fGV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 02:01:11PM +0800, Zhu, Lejun wrote:
> On 5/24/2014 1:49 AM, Mark Brown wrote:

> > There should also be no need to add extra locking around regmap calls,
> > the regmap API has locking as standard.

> Actually it also protects the pmic variable, so it won't be set to NULL
> while there's ongoing read/write.

Righ, but there is no clear need for the pmic variable to exist in the
first place.

> > It's also not clear why this API exists at all, surely all the
> > interaction with the device happens from the core or function drivers
> > for the device which ought to be able to get a direct reference to the
> > regmap anyway and only be instantiated when one is present.

> We created these names to hide the implementation of how read/write is
> done from other platform specific patches interacting with this driver.
> So when we change the implementation, e.g. from I2C read/write to
> regmap, we don't have to touch all these patches.

This sort of HAL is frowned upon in the upstream kernel.

--J0aV3cDZF7126fGV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1TsAAoJELSic+t+oim9vAkP/i8cZnldeHSbxMYYQYwJyiZh
hlq11JAcWGYSxhElDeE29wByND6vZ5yVL3/SliWO+OiZAMwOrwTqbEMLPsBkrdDX
0prx5aPml9WIx/GuZlNJOJ9XKYy87id39x3zap5AmkHO6wurOIVB3T93vgUGivy1
6rDdHycxthT7TODdbDD0LeKY8Rxyc037+ZdACx/vEg2hmBFaxQWlsV8ohEgTB1VR
Q1CZGZyT6ELJfY4Fs+wcRV+TDHcTZpPo5YJhDpvLSsZoRp5PB+6oAUOt4jvs6dBL
hMZs/KvwGhNKEwYQvvuns5IPVqi65+2jb8n2W57afOnEAkkxe9niRf/AxxeEYk0j
NG0T8OoK7+8Dtv58RxMjDaejqG2+2yP0nh7mF+qSk/b4C1/LFICPo6jEkW00zvQE
7lLx1si9+95PH/rOSlPlBu96NxxLUmC2PtxGDROaX785l6eVJXrFrH9rtLI1nZZ4
etm/5LA9VpGUrkmf3fS7zKual8in+sjepOHXOZUQTtP9Zm8cqohVRcP5r0mQIxnN
v4bDdYChYHAH9cYS1PtEMVVka/LMc1GqtERsJJx6TrwRxwt+xHghOaXfNPUgj12w
+l2w03toY75BlGJY5a17bJTsclFagmjc0kB8Ii255EFAVkSLxHhj0hkVNXCJcuNi
CBKck/L58ZeLCUPkiJfe
=SCiR
-----END PGP SIGNATURE-----

--J0aV3cDZF7126fGV--
