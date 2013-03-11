Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3CKM0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:26:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CKM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:26:06 -0400
Date: Mon, 11 Mar 2013 13:26:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: A proposal to check the device in generic way
In-Reply-To: <1363001537.18714.3.camel@smile>
Message-ID: <Pine.LNX.4.64.1303111302340.21241@axis700.grange>
References: <1363001537.18714.3.camel@smile>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:9VrrMrl86acrw65CuOizHrAtPU8+t6oFMqXG9OyQuPY
 6W0hOQmdKFn+q9Yjmn7upRaHP9RimMtHrpOkRjy3ZXjPxIgmYN
 mWppXSzF98E9/gyhr7064i3YLLwTm8xONMeX2GUVqNlz7Sbt8Y
 jYmu6RkwcU+MdAhsc5zK001upwd26Ac65b7L5g4QrTZv3QD3q3
 uj+e8/iwSSiaOT5xNqRLtd9qCTYicIu2piTZxrAnYRj5UcByxS
 rswI200XTwpqxMRIMWLl0FWCNKBDy43RKVMSy2ZcbiTtaKomet
 5v//UOgAHCULS61BaTAGChsRXHOFHM6iz9tTYtaiE8ZHn3jGVn
 uK5R1J/9zfxOLzXCnxHB7zKVTwA9o5aWtit5SD29IWvUNM+oaK
 zNSXdZtXzBX/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andriy

(adding Russell to CC)

On Mon, 11 Mar 2013, Shevchenko, Andriy wrote:

> Hello.
> 
> Currently in linux-next we have the following things:
> 
> $ git grep -n 'chan->device->dev->driver' drivers/dma/
> 
> drivers/dma/amba-pl08x.c:1594:  if (chan->device->dev->driver !=
> &pl08x_amba_driver.drv)
> drivers/dma/dmaengine.c:190:    return chan->device->dev->driver->owner;
> drivers/dma/edma.c:609: if (chan->device->dev->driver ==
> &edma_driver.driver) {
> drivers/dma/omap-dma.c:654:     if (chan->device->dev->driver ==
> &omap_dma_driver.driver) {
> drivers/dma/pl330.c:2374:       if (chan->device->dev->driver !=
> &pl330_driver.drv)
> drivers/dma/sa11x0-dma.c:1080:  if (chan->device->dev->driver ==
> &sa11x0_dma_driver.driver) 
> 
> I think it's a non-generic way to check which driver provides a channel
> into filter function. First of all, I don't get why that comparison goes
> as deep as driver structure. Isn't clearer to check chan->device->dev
> against the struct dev passed in the custom parameter structure? Like:
> 
> struct filter_params {
>  struct dev *dev;
>  void *param;
> };

I don't think you always know which DMA device you want to use with this 
DMA client - sometimes there are several DMA engine devices, that can be 
used with your DMA client, or even if it's only one, you don't necessarily 
have a pointer to it in your DMA client.

Thanks
Guennadi

> bool filter_fn(struct dma_chan *chan, void *fparams)
> {
>   struct filter_params *p = fparams;
>   if (chan->device->dev != p->dev)
>    return false;
>  ...
> }
> 
> In case my idea has a right to live, what about to move such check inside
> DMA engine code?
> 
> Opinions, comments?
> 
> Earlier I tried to discuss this with Arnd here: http://www.spinics.net/lists/arm-kernel/msg220716.html

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
