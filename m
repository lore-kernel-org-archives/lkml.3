Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750804AbaLOMUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:20:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLOMUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:20:43 -0500
Date: Mon, 15 Dec 2014 12:20:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@google.com>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141215122022.GA11764@sirena.org.uk>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
 <1418271327-14710-2-git-send-email-benzh@chromium.org>
 <20141212132732.GK11764@sirena.org.uk>
 <CAOV7By+GVAZiqwO9NW3DB87uOzx003K_RPqKhX4+vvf=oB=99A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZjlDoLon7m/fln42"
Content-Disposition: inline
In-Reply-To: <CAOV7By+GVAZiqwO9NW3DB87uOzx003K_RPqKhX4+vvf=oB=99A@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: rt5677: add a platform config option for
 MICBIAS voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZjlDoLon7m/fln42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 03:48:51PM -0800, Ben Zhang wrote:
> On Fri, Dec 12, 2014 at 5:27 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Dec 10, 2014 at 08:15:26PM -0800, Ben Zhang wrote:

> > Why is this being specified as some magic number rather than using the
> > voltage (or at least providing defines for the voltage) - this is going
> > to do little to make the DT legible and...

> >> +enum rt5677_micbias {
> >> +     RT5677_MICBIAS_1_476V = 0,
> >> +     RT5677_MICBIAS_2_970V = 1,
> >> +     RT5677_MICBIAS_1_242V = 2,
> >> +     RT5677_MICBIAS_2_475V = 3,
> >> +};

> > ...I see there are defined for platform data.

> This patch adds both an entry to the platform data and a DT binding
> for MICBIAS level selection. The 4 voltage options
> (1.476V/2.970V/1.242V/2.475V) are the only ones supported by the codec
> hardware, so it seems an enum is better than specifying the exact

It's not that clear that an enum *is* better, and a magic numbers enum
is definitely worse for anyone who has to read the resulting DT.

> voltage directly. I was following the two examples below:
> Documentation/devicetree/bindings/sound/cs42l52.txt (cirrus,micbias-lvl)
> Documentation/devicetree/bindings/sound/tlv320aic3x.txt (ai3x-micbias-vg)

Old DT bindings are old and often not best practice.

> I'm new to devicetree bindings. Is there something like an enum in DT?

include/dt-bindings

--ZjlDoLon7m/fln42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjtIFAAoJECTWi3JdVIfQkugIAIK3ofI8Ws8h1SoG9i4yZULp
QBMy07YzvtxEiLvSWsiYwCyr8UyIWMbj9oJRlrmDoDdaVawgK11RrvVl69GdKSgv
LzPydSDtud4ztvBrgzcTGu1dmrZfwecu8rnYcZmHh5B6EH2FivBukhwn9QJow9t1
38brUBUHWt2bzMrkpoZi1+d2g9DfxNSe6dRgr0Ozl45Hjt3uXqqvFxfzBxvBJbW2
Zs0tK6ONuC+o4RFgg6Xjh+hTLKvZfUSAMNGqfskjQHzsd/EByp70fp5V/NdShsB5
kroEwjveyMez42dpst9X9BBhJCzc34pjPxI/f3cxST7BkzVcRt2pq2+Ifo2bBSM=
=y7/8
-----END PGP SIGNATURE-----

--ZjlDoLon7m/fln42--
