Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3EVUdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:33:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:51062 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3EVUdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:33:54 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+ndBZyBAinnDKoHDpd4uMPsPwfoGAWioGHUXDyNk
	0SBvxWsp/K/jMr
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH 2/2] nouveau: replace large udelay by mdelay
Date: Wed, 22 May 2013 22:33:50 +0200
Message-ID: <13984908.ROMDY68d5s@fb07-iapwap2.physik.uni-giessen.de>
User-Agent: KMail/4.10.2 (Linux/3.9.2-8.g04040b9-desktop; KDE/4.10.2; x86_64; ; )
In-Reply-To: <d75e9ee62d4cba8efc86c23476f746f145ecb676.1369251478.git.marvin24@gmx.de>
References: <cover.1369251478.git.marvin24@gmx.de> <d75e9ee62d4cba8efc86c23476f746f145ecb676.1369251478.git.marvin24@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like Arndt already send a fix for this. Sorry for the noise.

Am Mittwoch, 22. Mai 2013, 21:48:42 schrieb Marc Dietrich:
> ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
> This affects distro kernels mostly.
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
> ---
>  drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c index d0817d9..ed7415e
> 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> @@ -51,7 +51,8 @@ nv50_dac_sense(struct nv50_disp_priv *priv, int or, u32
> loadval) const u32 doff = (or * 0x800);
>  	int load = -EINVAL;
>  	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
> -	udelay(9500);
> +	mdelay(9);
> +	udelay(500);
>  	nv_wr32(priv, 0x61a00c + doff, 0x80000000);
>  	load = (nv_rd32(priv, 0x61a00c + doff) & 0x38000000) >> 27;
>  	nv_wr32(priv, 0x61a00c + doff, 0x00000000);
