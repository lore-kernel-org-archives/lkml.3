Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbbAMOhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:37:00 -0500
Received: from sauhun.de ([89.238.76.85]:35582 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbbAMOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:36:58 -0500
Date: Tue, 13 Jan 2015 15:36:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of
 readl/writel
Message-ID: <20150113143654.GG7660@katana>
References: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Content-Disposition: inline
In-Reply-To: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Thu, Dec 11, 2014 at 02:26:41PM +0800, Jisheng Zhang wrote:
> readl/writel is too expensive especially on Cortex A9 w/ outer L2 cache.
> This introduces i2c read/write errors on Marvell BG2/BG2Q SoCs when there
> are heavy L2 cache maintenance operations at the same time.

Reading this again, I got a question:

Really read/write errors? I would think that there is a performance
penalty because of the memory barriers. But errors?

> The driver does not perform DMA, so it's safe to use the relaxed version.
> From another side, the relaxed io accessor macros are available on all
> architectures now, so we can use the relaxed versions instead.

Can the designware core make use of DMA in theory?


--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtS2GAAoJEBQN5MwUoCm2svAQAIpRt3q0aHH0xGwK8rt2P91x
ZJVUcF2YrP1KPo14LaP6N0lPAjzathtXBHOPr5udB7+zoMJBPGdHXrPRP9x7WmAY
89avemgEFOdrhuDcBkr2BXhn6hsRs5HJlu9x0/z/HfLK4Cwmoh9BhB4CTOYT4VnL
PlH60kJBSfAxh2llM/k024o70p8uNnN0ODe4kIDiBcbqnWTOBjTT4ecjT0qehrl/
T7ghYQOFzl4vwzgvMNFrxMNb4n1eksktxn5qua/HGrloU8l1iJ1rRBSBkw1xfHJp
/2DZv+inHvuyLPvyNLEld8i/4Q0QgA/D8zL7lNhLuA7pmwUmv496NJpkX++xD+da
SJOZuzKGT30lUUQLMLUEkeG89kLqMkqbbsdrC4RDw6LP077h/p53rmFuVGr9Yc3B
3Nk5TfeOK34mq4eTLvNerAwg+y6e6T7GekVGvRjR6gGcSQPsD8SD3sEpVSgbFzhY
8xM3yDBROS6/kepaHGAXSF3nyxYg2ask8Cdrirg9pRwHm6OHCTBl8S5q6hYAzINu
ysJTSor0O64aiwxhH/dVzEEqHbf8X/0/rHLrxomoVPS0l4lmgqH538to59vYQ1+C
HR80GYPgkBL8EnwNo06VuYvoEpOO8c1/IDlSFpbkaWO0RV9Wid16ImvI59EkR28s
bxtE2Bu78n1pC4fbYQzG
=lfnX
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
