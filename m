Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaGUQZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:25:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48086 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaGUQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:25:04 -0400
Date: Mon, 21 Jul 2014 17:24:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140721162448.GD17528@sirena.org.uk>
References: <20140716121029.GA22222@opensource.wolfsonmicro.com>
 <20140717194215.GH17528@sirena.org.uk>
 <20140721090104.GA21400@opensource.wolfsonmicro.com>
 <s5hsilvnkuf.wl%tiwai@suse.de>
 <20140721103327.GA29141@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5JJEVRmBpje5aLKk"
Content-Disposition: inline
In-Reply-To: <20140721103327.GA29141@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: arizona: Disable AIF TX/RX before configuring it
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5JJEVRmBpje5aLKk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 11:33:27AM +0100, Richard Fitzgerald wrote:
> On Mon, Jul 21, 2014 at 11:04:56AM +0200, Takashi Iwai wrote:
> > Richard Fitzgerald wrote:

> > > The case being fixed is like this:

> > > aplay 48kHz.wav; aplay 96kHz.wav

> > > The second open happens before pmdown_time so the AIF is still enabled.
> > > Writes to the AIF config registers only take effect if the AIF is disabled.
> > > Without this patch, the 96kHz.wav will play at 48kHz

> > If the glitch really matters, the driver can minimize by checking the
> > change of sample rate and doing temporary turn on/off only when
> > required.

> That's a fair point.

The case I was particularly worrying about here was simultaneous
playback and capture - we won't be changing rates here since these
devices currently require symmetry which is enforced via constraints but
we are likely to at least be starting multiple streams close to each
other frequently.

--5JJEVRmBpje5aLKk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzT7MAAoJELSic+t+oim9v/oP/RvaN2sXIp6/pczl+SuIWu4Z
GBqN6tyBw4krZ7Go3CwrdS7e4pp+4KTtb2FVJGZL5r5u24O3zld67wfyYQohbyrb
1xEsRy51FM2wOGHaVC+wqqQrUgpKPRIHvNbhO7TSTDrSWWnFldXRzJdIttFUKY2h
KDyDD4f6+gOC4UamVLRG2T+wuX/N+i6ey/Nk4cVE/gF1ZvGbJiL2WLoQSQcpFS+K
7PDECrQSWxklo9cVETTs0i2Uz1HxSytdhFvmzUuL90pFtjkxAVD5AbB9d8R2LyiG
kkYU8+wja770a1D0qtTHDPDHMa4/7VMfNML8n2HLQaHF9aCNG2hwzzAGDbV85270
qjOe2OUplf5/T5pBAaV3fSOeFaR+uVU4Ubp1dNgYncmTZL1L+G/0kW3agetUlzGx
rx/0D16pRUwbH6HTHLPEMal+MwQJXme9jgxmivaYXRPnJrtLvjQvnmWg61lY/Kd0
/CV9m6Dtauc1x1gGzT6c8An92vbggo/iGRQegkuNK6EFmGR3lqxLv/o/CueX6DDw
KMYxM9HWuz+1YrNuOL/gTwowtpReiKoSaI5E91rqw5pm+jyFUNpQJ5CVcFQ92hpM
Lc3HvILfip2vkInkoxbJPCBm0G8N4eZaD5+0IK55x5lvKqhVpoqMrXYNy7xF1SA9
M2J40n8BpmF73bWqWPPD
=tlur
-----END PGP SIGNATURE-----

--5JJEVRmBpje5aLKk--
