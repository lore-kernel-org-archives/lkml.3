Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337Ab3ECNTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:19:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51761 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761940Ab3ECNT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:19:29 -0400
Date: Fri, 3 May 2013 14:19:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, Milo Kim <milo.kim@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130503131908.GA3820@sirena.org.uk>
References: <1367585170.7397.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1367585170.7397.1.camel@phoenix>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Remove all platform_set_drvdata(pdev, NULL)
 in drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 03, 2013 at 08:46:10PM +0800, Axel Lin wrote:
> Since 0998d06310 "device-core: Ensure drvdata = NULL when no driver is bound",
> this is done by driver core after device_release or on probe failure.
> Thus we can remove all platform_set_drvdata(pdev, NULL) in drivers.

Applied, but note that this is nothing to do with the above commit - it
has always been a bug for drivers to rely on drvdata except while bound
so any driver that relied on clearing it was buggy.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg7lEAAoJELSic+t+oim9KZkP/2gsf1TqyKVJg2n1G+4Ppqf2
T/F1sMJbO40HNMqPeFiYHZ+nFo1Es7OyOqApjCUTlbqKt0BcBx3I15Tt7gb6pojG
uvND2Zpxw9AJG/ahTvCCZ9F41DWIGSkr/4JrcnpINC8eGJnlZzUNBs510ljUUw3m
nv1XFBIrZNSiSVpiePPO655mH+Lc0k3npSip/+svjWJxRgVKHpIsKHFVBU1ke5bM
BmSH1MSqlcVvIYtuB7nQmq2FL1ap9WrMokt/R55lYKTkKTpBkYDZKMQlPKG2cq2Y
i4FRV3ggpTIVjus63a8xH4KMinMw4Y+zvBV2NfkXLXIt5pinQZqgesdMNxKOpqBO
RvEl1s+6aSdXK6bczpVoCHORbP5QKmxwT/AR49+6/w3Z9oE2Sj/pG583tUKxH2dR
yS4h6W5Qjjwf9fKcw7zuJCmiOW0jZbHIO0RCcoowfUjSvGkTrB4xOAgGTBHaaa1F
pTqTkcKPQdSDENA6lzpo55l9GqRh+iX8ytoX5ObS9eVU7mBVGVVwyD6X54vfmBEw
CIlPdPy3YA+IUDuQE84Lo5yCJeSJKGBdqNjCl8cephds2rWs22UaEPgvRDC4YCwX
qZKdXs58knpQ9zjmLEM4ICLh7P6wQg4WcIvM4u/OFcb/ZiQhdd0vxJTdJ7EZx2yL
jNhLHU7Wyrh5TLyzdAIv
=RZgQ
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
