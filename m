Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKIXyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:54:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaKIXyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:54:50 -0500
Date: Mon, 10 Nov 2014 10:54:38 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ASoC: twl4030: enable routing audio to 'voice'
 interface.
Message-ID: <20141110105438.39cff12b@notabene.brown>
In-Reply-To: <20141108092756.GD2722@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
	<20141108003803.6561.52497.stgit@notabene.brown>
	<20141108092756.GD2722@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dR1OvpO1fg+U5QcLkwY8/Mp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dR1OvpO1fg+U5QcLkwY8/Mp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Nov 2014 09:27:56 +0000 Mark Brown <broonie@kernel.org> wrote:

> On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:
>=20
> > -		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
> > -				 TWL4030_VIF_TRI_EN,
> > -				 TWL4030_REG_VOICE_IF);
> > +		/* These pins only relevant when voice_fmt set */
> > +		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEIN");
> > +		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEOUT");
>=20
> Given your previous patch are these trying to control a digital link by
> any chance?  If they are they should be removed, and in any case this
> sort of thing looks like a machine driver issue.


Depends on what you mean by "control".
They declare that a digital link is, or is not, active so that the related
amplifiers, DACs, etc can be powered up or down.

The "VIF_TRI_EN" puts the digital interface in 'tristate' mode which
effectively disables it.  So that bit certainly "controls" the digital link.


If I shouldn't have these controls here, where should I have them?  How
should I turn on/off the widgets that drive the VOICE interface?

You say it looks like "a machine driver issue".
alsa/soc/machine.txt says that "machine" is a synonym for "board".
I thought we were getting rid of board files and replacing them with
devicetree.  You seem to be implying that we are keeping board files (under
the name "machine driver") for the audio config.

Is that correct?  What is the reason for that?

Thanks,
NeilBrown

--Sig_/dR1OvpO1fg+U5QcLkwY8/Mp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF/+vjnsnt1WYoG5AQJKHg//foJMDfvWH76ZCj7aW+TFu99LPKFdVm32
DJcjQzeNRzNlkkHsKAvqmRL/pre4G8XAO8b1FGudZRxJ1IUrmWSv1DL0ZOLK/7bU
JL53v9rBdgVkSv8y6MToV0XFGIz/3tJxARlvloG7lx+Ih61Wam+PXVPNysd+WQgB
FyNkdhIW7zf5BzE+a8KSigasfLDqJBICSEy9Y47Z9MNi04epWR5UgI5dardSmcfl
To/ALmqSqIpwOPvB5G2C2rOmJyQ7TP17GqBIR7Dt64YASLdZYooEcAQyVRNdMcOL
R91iE4pKAuHirmU0C00albapt80/jTiGeSinJ/84f5/JljKmjw0mQNIBV5y/nBcZ
5NQS4cNzdBjW7oO01nHrasOOZhHY1tPskF0MlXKQ8ksdOWYtrhQ0sMaGWHZ3FsX+
dsyWiBa1Nd+yfMpqPQ3dxXyTi7tgI3q6k2CyD4a5z6IUv5edHDVsiacPwJJh5anl
bDF0bgbmX/BW8JaawUgPjxJIY+VBXtkiNWBj67dt9xMnFyQyP+GxMdhj/Ty9+6Yl
s8ntAWX1KjvQ0e1tyv6cXAoHIpJBoPGo9PtDHW6KvyKF+m9HOVeZy4WHFtEetg5H
tRz/07G7N3UnyWCL0BPt5f3Zynf37rcqyQkTBoOW1WFcm5ddypGeafvKxIN+iF2M
kOotbM31CEY=
=KcWZ
-----END PGP SIGNATURE-----

--Sig_/dR1OvpO1fg+U5QcLkwY8/Mp--
