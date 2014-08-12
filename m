Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaHLWEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:04:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60524 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHLWD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:03:59 -0400
Date: Tue, 12 Aug 2014 23:03:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140812220337.GF17528@sirena.org.uk>
References: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140807141604.GJ8181@intel.com>
 <20140807171324.GM17528@sirena.org.uk>
 <20140811062429.GC13288@intel.com>
 <20140811121912.GY17528@sirena.org.uk>
 <20140812151014.GF13288@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="igpv2mJkFzVQTi9J"
Content-Disposition: inline
In-Reply-To: <20140812151014.GF13288@intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3] ASOC: dapm: add code to configure dai
 link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--igpv2mJkFzVQTi9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 08:40:14PM +0530, Vinod Koul wrote:
> On Mon, Aug 11, 2014 at 01:19:12PM +0100, Mark Brown wrote:

> > That doesn't mean it's the best way to go in the end though - long term
> > I expect to see us move away from that to something more data driven and
> > DAPM integrated.  Requiring drivers to open code things rather than
> > factoring out the code doesn't seem like the right way forwards.

> Okay if that is the direction then this sound good to me.

> Only one last nitpick on how do we set different format value apart from
> sample rate, bits etc here. We have devices talking on same port and each one is
> different format(one use i2s, one uses tdm ...), so how do we handle that part?

Doing that sort of thing automatically is probably best handled by
having some actual concrete idea of what's on the link and how it's
sharing the resources which we don't really have in detail right now -
we loose track of TDM when things hit the link and can't do things like
notice that only two timeslots are active even though the link could
have eight and so end up powering more than we need to.  What I'd like
to be able to do is to trace the individual per-channel and per-stream
audio paths over the link, I think multiple configurations would fall
out of being able to do that though I don't have a terribly concrete
idea for a design right now (I sort of have one but it's got a lot of
handwaving in it and isn't really concrete enough to write down).

--igpv2mJkFzVQTi9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6o81AAoJELSic+t+oim9vEkP/jOclFfspFPbO0GY8wN7S2Oz
mKrKbi4TPqQpxpMO6X7X0JOXA8IH8WkkVeWf6c1uGgGt5M/jjnuug6ztQwlc91lX
92+VvJ1aj2msMSBu786UYKCF/aNingZ5sMkjl+uFM/mwn7HgRZQ0F3hTKBOlQCyd
XRiTGbaX7+5Z+ibwHF96S1lb7ldTXbq8DhxiPjlvxMkWxVofX3S/b8K8XG1n32iL
T85mBaV7PdtszIH+FkmAK5ToT8s1Ww00LV2LuDJfgD6CQ4eDLSvURXDXFl7jNbva
P8RrOO4/vhInv3veAPwPk8/Y5iTeRqf9pcxZUWeGmkcZq4VFUjz0s5CurCRwdUA8
uSz5BRG8BIphdwo3vKVrsXupilfiCjgYK4VapO4SqbI7xA4g/pc7TyeyJRnXjao7
3AWSr6UdiExe8+UspDnJ2AvEXekTvoAYR/Hc1p5rFa1+uEowi2ALjxnKzqwZ8+AI
g4u1Futlu6qKRt/DlVpZyuzpOmtt99OlSZ4Sw2VDaa4TFcp6ZP1DU3GgKF4t/pcS
nLgJdaWUaKzEeXisaLVmYLM+KbUAwatY3QX54VVNsrRgkrNNjJfWcDGDEmqJIeJx
ZheAXhFz/nuFu0ugCe8/JzoqMcpUcXKHE/goiu7hGb2pJJcEnMjc13yLJ2r/gHg8
2l2b+hQVyKuhwmrdNWsx
=lAJY
-----END PGP SIGNATURE-----

--igpv2mJkFzVQTi9J--
