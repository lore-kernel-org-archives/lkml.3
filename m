Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbaCULiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:38:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57369 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaCULiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:38:08 -0400
Date: Fri, 21 Mar 2014 11:37:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Songhee Baek <sbaek@nvidia.com>, Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140321113751.GK11706@sirena.org.uk>
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
 <20140318235941.GT11706@sirena.org.uk>
 <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com>
 <20140320114829.GC11706@sirena.org.uk>
 <532B3161.6080808@wwwdotorg.org>
 <20140320183638.GI11706@sirena.org.uk>
 <532B3C03.7030208@metafoo.de>
 <532B4446.9060607@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mjiFtt7fBqhrGRle"
Content-Disposition: inline
In-Reply-To: <532B4446.9060607@metafoo.de>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mjiFtt7fBqhrGRle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 20, 2014 at 08:40:54PM +0100, Lars-Peter Clausen wrote:
> On 03/20/2014 08:05 PM, Lars-Peter Clausen wrote:

> >It might make sense to add special code for supported muxes with a one-hot
> >encoding instead of using a value mux. Having an large array where each
> >entry is just 1<<n is a bit ugly in my opinion, especially if the value
> >needs to be able to be larger than 2**64. But anyway the patch that modifies
> >the soc_enum struct should also add the code that makes use of the new
> >struct layout.

> On the other hand this can actually already be implemented without any core
> changes by using a virtual mux and connecting a supply widget to each input
> which sets the bit for that input. DAPM will take care that only one of the
> supply widgets is enabled at a time.

Yes, each works - either way I think we can probably come up with some
helpers in the header which hide the actual implementation from the
drivers or at least makes it obvious that this is the way to do things.
The supply widgets approach wouldn't need any changes in the core but
then generalising the two register code isn't a bad thing anyway.

--mjiFtt7fBqhrGRle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLCSLAAoJELSic+t+oim9oO4P/10rn8Msw5BFS5mCSOFhGvK5
O82fYvIJ4jF8lOr3j/u8aGPRFIZrr0mM1mQOaDD62wDgIsk33fX0vquIakWttcxh
eQOm1P2OtwcVYXnsNK1mvEtNSvnrV2+UJ/Wb9oL6t6ApJTWCQWBNQ+2YPBDDWEc2
jfcqNoctJPqshjqVW8BYfE8SoazzQZ1ERL2JHakl3vYUrF+3knkcCfS0bytinnvV
qhnT12eeES7hwjUxUP1wxwJvplz35vOAGy6ESydtUaBDkxbpope76TJGT4cu6Nfw
fYdOXS4o/vColzsTbX0OobwcXI/2XD74CtHEORqYH8gljTZr7nsR9csB5IOSxmbJ
HSfzoA0R2JQvnt8nP+A6xsWwZSfQvOmrCOmq+laNDXlg08g1QLJdusK51h87Z82k
hJf8oWRMvk2v+kghIxfNJjqKBhOwvj2xL6/Jkvnisp10ALiVi5FNL4okcBNgjJtD
sa+XSjlwA9e2+Ag9/JWtm3RqOvLY0EmuD44+8CbNg+MXPuW+7GlNoU5RsUGQxHpQ
SCcqY+/EXlsQ/qHkT0GgO5H9anUOFDmnUyJGAniN39/Y+o63q729FG7WEvZyMIDm
jfs6iWu95gFEDNSk5v7y60TnpdxnnVsCqiL8N4YAUQ9DTS3m70WoyZkj0MZ35w2q
/I+ApjibpHDa37RLopPK
=AnGu
-----END PGP SIGNATURE-----

--mjiFtt7fBqhrGRle--
