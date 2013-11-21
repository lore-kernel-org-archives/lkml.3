Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3KULXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:23:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58693 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KULXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:23:11 -0500
Date: Thu, 21 Nov 2013 11:23:01 +0000
From: Mark Brown <broonie@kernel.org>
To: wangbiao <biao.wang@intel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, di.zhang@intel.com
Message-ID: <20131121112301.GN2674@sirena.org.uk>
References: <1384996978.19494.7.camel@wangbiao>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WW66Wv25qHMoYYLs"
Content-Disposition: inline
In-Reply-To: <1384996978.19494.7.camel@wangbiao>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] wm8994: avoid to enable dcs done irq before init
 completion dcs_done
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WW66Wv25qHMoYYLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 21, 2013 at 09:22:58AM +0800, wangbiao wrote:

> From: wang, biao <biao.wang@intel.com>
> Date: Wed, 20 Nov 2013 17:53:28 +0800
> Subject: [PATCH] wm8994: avoid to enable dcs done irq before init completion dcs_done

Please don't include things like this in the body of your mail unless
you are overriding things in the header, submit things in the format
documented in SubmittingPatches.  This will avoid confusing tools used
to handle patches.

Please also try to send your mail to only relevant people, the CC list
above is very broad.  Many kernel developers get a lot of mail so it's
good to be sure that you know why everyone on the CC list is there.

> once code return from request_threaded_irq, irq was setup enabled by
> default, but completion var dcs_done not got initialized yet, if then a
> dcs done irq was raised, system will got hung as the sync mechanism is
> invalid now.

> so this patch try not enable irq when request it until we got things
> ready.

I would expect to see a patch such as this moving either the interrupt
request or (more likely) the completion init.  However that's not what
this patch does.  Why is this?  The most obvious thing here would be to
move the initialisation of the completion to the start of the probe()
function.

--WW66Wv25qHMoYYLs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSje0SAAoJELSic+t+oim9DasP/RSQYbJKFw3K+H2QzRSpY/VD
4T8v9YtVJOzyRb/+wzkwTaJl9waC+MEG5ZN0aLRGF06PJQwa0kPItUMK4L+9EoY9
rNyBK2WqUH04jo5X/bef5T/cWifHZjVp9nri6ei/iNThwH6jUg9bUQnlaon+gCIm
+1sXU1PjUBn0eNFwdgR0u2TDF2iM08FZtamQefAK8/2+kvtpbgkYxhUPPsAVGgN9
SIQSjD9LLWOwqlz0LWNxAJXvWl6bLX7voHsQJpsxdjkMIzZNKu8HB0Ysu7vTdX8s
Sly50ml6cAQJvNzbU94PuBkaRI+RlAdHo7UPAe/01dWh5KVBZqYb0w/IFWsP0LVg
+LsVqbN8tXC1EsM1pVb/PEgjujjhXumg3Pfn4RSbkBrYscHycIJE5u+jTYE1LLap
rbM5twd9PbYgIRY0cHU6G5JKg18QHVz0l5Yw3nosXVI8avPXST+4CQpXj5UXeYyE
KFuUfK+KEbgqte0N8Ti+6KNJ4pto7Be2fF2k6wLFeaEuiwpbBASQ9fI44tYC337+
O4GmLoZaU0I6NpUEQEc5mn0z52EC+4pPSNUi2UTcKNoovFqqCJqTm43N2Ny+rgr7
C9Ns25H5l6HLLnIE47U1+kUszsUjHmb3y1MqH45Rfig7cYvKAe3ltoiuzCg3Pk/H
BkwWXxLi1CSx9IZjWmI7
=FRM0
-----END PGP SIGNATURE-----

--WW66Wv25qHMoYYLs--
