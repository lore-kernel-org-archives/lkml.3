Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaITHZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 03:25:06 -0400
Received: from mout.gmx.net ([212.227.15.15]:54646 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaITHZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 03:25:04 -0400
Date: Sat, 20 Sep 2014 09:24:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Philipp Zabel <p.zabel@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v3 1/8] [media] soc_camera: Do not decrement endpoint
 node refcount in the loop
In-Reply-To: <1410449587-1677-2-git-send-email-p.zabel@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1409200923160.21175@axis700.grange>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
 <1410449587-1677-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:GAZUwHm3EmW+BXkrFrV7YyBa57p1eXweHvzZHfb553vgQfB5saf
 Xr3pb4TOreYjdAhmPcTN8j718wNMXNEknqicKx4TOoP4CJXGHP3i3sYhvfMGGnq9CMest6P
 u5v0L3R36fl1cx91vVAAZ/YmRU9C/RdB8jli1NUFLANLxgzh1x2uklAzj4HhzUEbFVVdc0H
 xpab3SOqxTSyiO45R54TA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Thu, 11 Sep 2014, Philipp Zabel wrote:

> In preparation for a following patch, stop decrementing the endpoint node
> refcount in the loop. This temporarily leaks a reference to the endpoint node,
> which will be fixed by having of_graph_get_next_endpoint decrement the refcount
> of its prev argument instead.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index f4308fe..f752489 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1696,11 +1696,11 @@ static void scan_of_host(struct soc_camera_host *ici)
>  		if (!i)
>  			soc_of_bind(ici, epn, ren->parent);
>  
> -		of_node_put(epn);
>  		of_node_put(ren);
>  
>  		if (i) {
>  			dev_err(dev, "multiple subdevices aren't supported yet!\n");
> +			of_node_put(epn);

Sorry, this doesn't look right to me. I think you want to drop the last 
reference _after_ the loop, not in this temporary check for multiple 
endpoints, which your patch has nothing to do with.

Thanks
Guennadi

>  			break;
>  		}
>  	}
> -- 
> 2.1.0
> 
