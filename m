Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaJVK16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:27:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42219 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:27:56 -0400
Date: Wed, 22 Oct 2014 11:27:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141022102723.GL2344@sirena.org.uk>
References: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
 <20141017142605.GU1820@sirena.org.uk>
 <20141020061024.GA9406@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+jEI8cDoTn6Mu9E"
Content-Disposition: inline
In-Reply-To: <20141020061024.GA9406@jack-ThinkPad-T520>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+jEI8cDoTn6Mu9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 20, 2014 at 03:10:24PM +0900, Gyungoh Yoo wrote:
> On Fri, Oct 17, 2014 at 04:26:05PM +0200, Mark Brown wrote:

> > The thing I'm seeing is that the binding for your device with the
> > subnode looks very much like the device trees of devices with multiple
> > regulators.  The fact that you only have one regulator is a bit
> > difference but not that much.  It seems like drivers should fit into one
> > of two patterns: either the regulator is described in the root node for
> > the device for single purpose devices or there should be a collection of
> > regulators like is supported with this helper API.  Having a collection
> > with only one node doesn't seem to be a problem in any way.

> Thank you for your kind comments.
> My understanding is getting better.

> For my clear understanding:
> I think the original designed which I wanted to design is similar
> with arizona-ldo1.c
> It seems that this is 1st pattern your explained above.
> Can I ask what is different between arizona-ldo1.c and
> this sky81452-regulator.c?
> I think both are designed under root node.

Were that code being written today I'd probably be asking for it to use
a regulators subnode to be consistent with everything else, it's a
slightly older driver and sometimes we've not spotted the patterns when
they're added, once we get to the point of adding the helpers as we have
now things are definitely getting baked in.

--m+jEI8cDoTn6Mu9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUR4aKAAoJECTWi3JdVIfQ/uIH/0glztVbV+RiouufNTimD9v9
WOcU2UXLdunyf7zETEyaJJn+btGIYTR3JFNOeyjO1DgfMsweQsUyKPQgpXNypGFE
5+8jGVf82rXuGcl93EsA83cXRfCL+JESjlhCUWavzKTfQ9iG5se1ASTy9JSf8i06
TUfUjYLhRaGCAicnnPsAyOT89tpdN0eF8OiHtiev6ZEmZUtePhu3xywIYPCXjsWM
CrWp8BxM6/49iyAI4yq6FwW49/q/yR10kmLgrEqLA+xz786KIshuvxfRgxLsHDfp
aEwshr+kCpSzpCgandR8hXFovjD89cw0bqyvNdh7hzU08yEgj7zK25UWfLs5e4w=
=ShJw
-----END PGP SIGNATURE-----

--m+jEI8cDoTn6Mu9E--
