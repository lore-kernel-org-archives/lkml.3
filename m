Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3HBKPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:15:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34836 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3HBKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:15:18 -0400
Date: Fri, 2 Aug 2013 11:14:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130802101454.GI9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
 <20130802100108.GA17936@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VcQ2MTg63lIaL1+E"
Content-Disposition: inline
In-Reply-To: <20130802100108.GA17936@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: core: init delayed_work for codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VcQ2MTg63lIaL1+E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 11:01:08AM +0100, Richard Fitzgerald wrote:

> +static void codec2codec_close_delayed_work(struct work_struct *work)
> +{
> +	/* No action required.
> +	 * C2C links only represent a hardware connection and currently
> +	 * we assume that we don't have to explicitly start or stop them
> +	 */
> +}

That's not the reason - what's happening with the stream events is that
since these links are not on the edge of the DAPM graph we don't need to
interface with the outside world.  Further since we're not dealing with
the application layer there is no need to delay the power down, the
reason that's there is to stop us powering the link down if there's just
a small gap between tracks so we don't get pops, clicks and extra gaps
if the application layer is closing the device at the end of every track
(which is quite a common pattern).

--VcQ2MTg63lIaL1+E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4aaAAoJELSic+t+oim9vcoP/05uOUSkkRVN7l50GoGKgDUz
p/h1s6J/I+EpSYp+5f3wFgrJkriY0BTt+fdQjCUJlNO/x3EscvbcFCJBO5YAHH3R
xWCZ+otMRRX8K2pi7gXpC0obKyvR9ODsgjpNYmmfg9yhk2YUM+47vbtDU5Ms8zqs
3aoZbpIPATX8XMNrzwAJSYEM9Zyg5CwC/crR6O9HO3slQy/KRtrdYJQjVBVtfajC
gZDGXemJlGazIT++L01qU8ul/nHhPYuxD5kQ6/0F/JD1OznOkHqFUhGzKr8bWWip
eti313mEDDvcs7s6bzB6TloMyYYVFKhdJhltK6kI6xxZnGgBjHLxC7mOLTnWkBW+
ydTQBg4Ch3tvBEouWaT3sBexG5eBM9+W1P5fL1ZVa+qdJsHhehsfnUFHVJI4U4cQ
S9Fcy9wrClvgtmymKJhBwkN/iidKRA+E2YAYikgkBOnzo+cy5LAQ9ADCUysTDCEj
idjDg9k2Y8UACsQbisIl/GnXS9HN53CojlcXqeGG1KVbJScHZowNK8X70h02EJ6+
72Jdk1knCVmswrSqR6JWrUTjg79b35NwzaXnCy5NZbz1fRigQg95ciEWD+5wEeQ/
ZOtxs+bsPj/dPS/ZuY2VFDo5Cgl4UEBgkosPJqh9i3EHRDYItHTMPO/ehf09161f
ji9vrqA3ow8K4eA/eanV
=CyIX
-----END PGP SIGNATURE-----

--VcQ2MTg63lIaL1+E--
