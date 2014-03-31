Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaCaSU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:20:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49561 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaCaSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:20:55 -0400
Date: Mon, 31 Mar 2014 19:20:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140331182038.GB2269@sirena.org.uk>
References: <1396265962-19343-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pI6hLdwVzam1XFuA"
Content-Disposition: inline
In-Reply-To: <1396265962-19343-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Fix buggy configurations in trigger()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pI6hLdwVzam1XFuA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 31, 2014 at 07:39:22PM +0800, Nicolin Chen wrote:
> The current trigger() has two crucial problems:
> 1) The DMA request enabling operations (FSL_SAI_CSR_FRDE) for Tx and Rx are
>    now totally exclusive: It would fail to run simultaneous Tx-Rx cases.
> 2) The TERE disabling operation depends on an incorrect condition -- active
>    reference count that only gets increased in snd_pcm_open() and decreased
>    in snd_pcm_close(): The TERE would never get cleared.

Can you please check that this against my asoc-v3.15-4 tag - it doesn't
seem to apply there?

--pI6hLdwVzam1XFuA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTObHzAAoJELSic+t+oim9jC8P/1D0ToGXczPF/Cd/uG/SghaO
KFNuNCBog1/3FOc1Zqkwh2qDtg131MNxdehZuJcCFIVEE04dIpoCTU1QaUCGyWMH
56YydIpokLPC1DrrVgEC41t9Bbhgu5BtnLh13bXD6jDXswAgaMxf20jKs5vZlvS9
wNQ/C4RqmXDNuSi7qUSI0J1sYOxVT/b7mW4SKt/v1Kn5hCx7Mw7MioRys77OYYHf
KwPN7m5UjlNJvjnkL6leSV85NiWXp828vDRDOWSVECX9qXJK+YHVqlyEzrXCUFcb
V6N0nmcNTW0cwqaCdaq7bQ/qNsUBlWz2tZkAzK145blkbV1BiyCSlG/FDulYit3P
4wQha6CtjlMftjTg70fT9Y++BZH8DXYSCxAQg/ssuQXUyEG5hDbfRE2KEhzGPBM3
w3X7Txp+qmqiUn6b5cPWy3nuVqDTroSbcnB5CAGWXwA1v+ZaE8fjucCCb02wCL+R
XN8nuUsLQWbykz+kaS+iMNhDv3ujG+vPbXrVOwmrL5KWQnadAJ18P0EDTEkYBjRG
s38A/g1DpQIXfwj41am10evjLOSBX/q47UU7LR23nFQdCGEJS2qERgOpMqMk0CVS
H45wAprtl3ZXZbGQOeO3vq4qmim2GYj9ta4HfYXvg4D2+h3MJcv6bBfEYptUhHa7
7id8Y+GUdtVHa8xMuqGx
=vQbh
-----END PGP SIGNATURE-----

--pI6hLdwVzam1XFuA--
