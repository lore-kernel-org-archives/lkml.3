Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3EVUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:08:16 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35327 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3EVUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:08:15 -0400
Message-ID: <519D25AC.3030804@gmail.com>
Date: Wed, 22 May 2013 13:08:12 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH 2/2] nouveau: replace large udelay by mdelay
References: <cover.1369251478.git.marvin24@gmx.de> <d75e9ee62d4cba8efc86c23476f746f145ecb676.1369251478.git.marvin24@gmx.de>
In-Reply-To: <d75e9ee62d4cba8efc86c23476f746f145ecb676.1369251478.git.marvin24@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 12:48 PM, Marc Dietrich wrote:
> ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
> This affects distro kernels mostly.
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
> ---
>   drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> index d0817d9..ed7415e 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
> @@ -51,7 +51,8 @@ nv50_dac_sense(struct nv50_disp_priv *priv, int or, u32 loadval)
>   	const u32 doff = (or * 0x800);
>   	int load = -EINVAL;
>   	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
> -	udelay(9500);
> +	mdelay(9);
> +	udelay(500);

That looks very ugly.  Can you just use 9 or 10 instead of adding on the 
extra 500uS?

David Daney

