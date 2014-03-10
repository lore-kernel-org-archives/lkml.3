Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaCJRaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:30:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaCJRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:30:04 -0400
Date: Mon, 10 Mar 2014 17:29:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, patches@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140310172947.GU28112@sirena.org.uk>
References: <1394468977-23149-1-git-send-email-broonie@kernel.org>
 <20140310163811.GA16697@lee--X1>
 <20140310164904.GO28112@sirena.org.uk>
 <20140310170524.GN8570@opensource.wolfsonmicro.com>
 <531DF3A2.80504@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALmJwsEf88ww7bQ0"
Content-Disposition: inline
In-Reply-To: <531DF3A2.80504@metafoo.de>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5102: Mark register 0x19 readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALmJwsEf88ww7bQ0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 06:17:22PM +0100, Lars-Peter Clausen wrote:
> On 03/10/2014 06:05 PM, Charles Keepax wrote:

> >WRITE_SEQUENCER_CTRL_3, seems we should add that in since it is
> >required for that 5102 boot stuff. Slightly confused as to how
> >that ever worked without the register being readable, but guess
> >it has been a while since I have fired up 5102 on mainline.

> Presumably this change triggered it:

> http://git.kernel.org/cgit/linux/kernel/git/broonie/regmap.git/commit/?h=topic/core&id=d4807ad2c4c0e17b6f00e3be9492c81de0804f40

Indeed.  Now that I think about it there's another bug lying underneath
too - the register isn't marked as volatile so it'll only actually be
being read on first read.  For some reason that check is only done on
probe so it's got no impact but it seems it's asking for future
breakage.

--ALmJwsEf88ww7bQ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHfaIAAoJELSic+t+oim9iXgQAIgP0H06+aDWqHlo2CwtOwz8
moPq1ydiVdjmbmBebc27oa3Iw7YGvmETsuA6dadfmFkElu5wZLhTmJ/bCJOJf1+D
z52EtcYo5aSuYor2QZRyBTJtvvQZFQ/7qctzJ7mk0e7jaVuLBDgHHS1sN2MTXdF6
T1L/Sx65WTU22KDd4u5KkDLSzkU4ZxoJz5AkaU4XZLsz+gRMp+6syl/W+SzFMew4
ozdNwvr6O/OSps6ejcpWZTBN/k3rADU99NLYmR+cQB+iE0wHMrPbVFGaQA5toDDF
0/4D1ITuCQ06f/dKD9Gm7IImBxgIpWdSf7Y+trVWFfKu6LhjNrHFyhZgd9q3MioD
W7m7HiaPP5VRcV/o1vAKQu//JFZ2sVPNe2fGMl3Mr8Y8jmdySoLIOExQBjXi/se8
6ehgPB77UvcC6S7q0I1ge/OWTaOJ4l34zJOAM/yaAExfgpR/nebCOINvJAXkLFSx
OSuLb/ubmIHbNfNec8IS9nuTWG3GxUf0afNrEC1W04XsGmTV7Y4hfOb4tHM/XmZ9
VCCrAWsuu3HWdjx880lDS5N/XGlKYNTP7xvoA/frWa4+84JviLfOS7u6yrnkQLGW
RqNL3eqbzNa9ANmmXNOt3Sf8VFkEwkJNjcnmgfwL/dyFlH1bIRU9Z9oRpXdpbbRZ
oaSbIhWe+KC7uXKmBw/r
=UrfY
-----END PGP SIGNATURE-----

--ALmJwsEf88ww7bQ0--
