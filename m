Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaE0TuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:50:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44709 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaE0TuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:50:07 -0400
Date: Tue, 27 May 2014 20:49:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Message-ID: <20140527194932.GD12304@sirena.org.uk>
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wHCRs67tfc1XsEk1"
Content-Disposition: inline
In-Reply-To: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/6] mfd: axp20x: add AXP221 PMIC support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wHCRs67tfc1XsEk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 11:38:49AM +0200, Boris BREZILLON wrote:

> I'm still waiting for inputs regarding the ipsout regulator representation:

If you've got questions you need an answer to urgently it's possibly
best to highlight them outside of a series like this doing that helps
make it more obvious.

>  * The ipsout regulator is currently represented as a fixed regulator
>    providing a 5v output, and this is not exactly the case.
>    AFAIU (here's is the datasheet traduction if you want to check [1]), the
>    ipsout output is a multiplexer that choose among vbus (5V), acin (12V
>    which is then converted to 5V) and the battery power supply (3,5 -> 4,2 V).
>    This means the output voltage of ipsout vary between 3,5V and 5V.
>    How can we express this kind of muxer in the regulator framework (is there
>    already something available ?) ?
>    Note that the power supply selection is automatic, though we could force
>    one power supply, but then we loose the ability to unplug one power supply
>    without impacting the system.

This sounds like it may as well just be represented as an unregulated
supply - it's just the system root supply really.  Nothing can rely on
the voltage anyway as it's going to vary randomly depending on what the
user does power wise and typically it'd only be used as a supply for
things that don't care about the specific voltage.

--wHCRs67tfc1XsEk1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThOxJAAoJELSic+t+oim9f8YP/jozDw/mw5l5NMErcDOjKNoX
8PaR+IsIx2JZau9pTLHEoMs7gbI+YElEoXwFYA8Rcv+mjZBsRczx2zMwaoGxIq6f
BgxldGuBZBR4NnhisziD0TiAuR3ib6uu4KVenzeeRc1MCfLPQl9tipwRu4CksvYX
7DlNZLMpVo0KKkcgr6TBO7Z4CuRyPzWoc2Pa8C74CValzwYAcjF+WxXgoBWhG5J9
pEoc1ySMUvEvI8CfS8pxr8LCg/wjb0SnJTG1f1LOe6QnX0UFBxq7F9QSlJt+U3Dd
Ju9VOMAYFezacVuekNJgbaeJe4j8pVs8KiilMHDvfS5pbeBTDvAwdo1iizG+iCrN
8axVF/Lqs81xmmofgX047+8tmG3hO9WrAnd0FXnXEj4cps4FWFQLExJlrLo188cS
0h1Ym5tqxXTdlI4rzBji5BtfnCBHbCAvx42PvopajgfBWegyv4hMjBHTFcgvL0Nj
fwjC2FokeLa8jcrSmVmVd6OUPv4qsCRIfGbcvvgCEjTh2vp0MtAALNbqoEADvzcn
SWW4uvHPuM2XQpe2nCtf/kgxQEQmhcbnqt6Ywa50PcTmwOowEU7AjqtDuapKJYjX
o1Iy/APhVcbp2KCPAuCqg/IPn2QWUdhTbNNAz9TCRfmJTbXK8IgAyloFuBo/aTX/
2TBmxhEN/u7wH54CiEFF
=Rzn1
-----END PGP SIGNATURE-----

--wHCRs67tfc1XsEk1--
