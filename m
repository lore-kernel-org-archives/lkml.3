Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaGCUrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaGCUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:47:52 -0400
Date: Thu, 3 Jul 2014 16:47:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Alexandru Juncu <alexj@rosedu.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] video: fbdev: matrox: matroxfb_base.c:  Cleaning up
 a null pointer checks that could never happen
In-Reply-To: <1404414974-9676-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.LRH.2.02.1407031646450.19862@file01.intranet.prod.int.rdu2.redhat.com>
References: <1404414974-9676-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

On Thu, 3 Jul 2014, Rickard Strandqvist wrote:

> Removal of null pointer checks that could never happen
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/fbdev/matrox/matroxfb_base.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
> index 7116c53..cd9dc88 100644
> --- a/drivers/video/fbdev/matrox/matroxfb_base.c
> +++ b/drivers/video/fbdev/matrox/matroxfb_base.c
> @@ -1973,7 +1973,7 @@ static void matroxfb_register_device(struct matrox_fb_info* minfo) {
>  	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
>  	     drv != matroxfb_driver_l(&matroxfb_driver_list);
>  	     drv = matroxfb_driver_l(drv->node.next)) {
> -		if (drv && drv->probe) {
> +		if (drv->probe) {
>  			void *p = drv->probe(minfo);
>  			if (p) {
>  				minfo->drivers_data[i] = p;
> -- 
> 1.7.10.4
> 
