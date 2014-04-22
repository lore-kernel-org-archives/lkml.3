Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaDVKmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:42:16 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34909 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaDVKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:42:11 -0400
Date: Tue, 22 Apr 2014 12:40:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH v2 04/10] drm/nouveau/fb: add GK20A support
Message-ID: <20140422104052.GB22426@ulmo>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
 <1398060142-7937-5-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <1398060142-7937-5-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 21, 2014 at 03:02:16PM +0900, Alexandre Courbot wrote:
[...]
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
[...]
> +		pages = dma_alloc_from_contiguous(dev, ncmin, order);
> +		if (!pages) {
> +			gk20a_ram_put(pfb, &mem);
> +			return -ENOMEM;
> +		}
> +
> +		dma_addr = pfn_to_dma(nv_device_base(nv_device(pfb)),
> +				      page_to_pfn(pages));

This breaks compilation on x86 because neither pfn_to_dma() nor
dma_to_pfn() are available. Is there some other way this can be
allocated so that these functions don't need to be called?

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVkc0AAoJEN0jrNd/PrOh7HkP/iCMWEHuOBSMvawVbmp9nVLI
CC1prTVr9Q6oT/eyCNGY47Hb23XuZO7AiDouF3hE3okswxsyRDqY1GBwI5xW6zsK
sP7/b79Lwzr+kpZrnRpx2ZWazKA0/vdvlH0jY6VYAJUwVdyEpR9ndqLe7yw7Ff3G
fHWGzSsWXA0obbqjp8j3T8ECY9YQg5GWH/PufNpGwMb5f/rKB0M01Ay/0gavoa3X
+5x5kQZZk3idOLt45LJ1HhnAw9sOEuBDmUn3mU/8GvwXkCTggl9dgDPHIMqIR4/4
FZpeSJ8wgWGVKC2UjO/mbpDAB70+ntgOji/RsOdEGB3y7rY+xVDJ4JOnd8mRLKJb
ooukR+8D0WgxZrrNlwOOUcID5h/2CUSrIJce+MdtidoTM7FnQPp7CvNTrBhq92VU
VwYku2KCyCppd5N9N7x2gcDs1uE1KOWckHyhZsf8rOQ1exGPzZbciZJV+BLLg7xR
cDFoY3bNMY/jUKUXfyNlpjaQ+/TA2HrcDSEjxgYfth90xhxoq7kpgUPYvh2lj+2X
YJB+GeWdku+tuR+cHZIBbS5SX740Q1omR677q74j6l9dQsv7LL0CXVwSnge/fDVb
lpkWuTP7nUVaOgqZ2RNCpXMA5CKwptr4a+FvkIqnTcKvqBT75H2KUuA1yzgZvaoh
040PDibi26IjzlTOsRSG
=Yvc9
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
