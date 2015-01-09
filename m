Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbbAIOcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:32:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32418 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbAIOcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:32:19 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-af-54afe67004fb
Content-transfer-encoding: 8BIT
Message-id: <1420813934.7331.2.camel@AMDC1943>
Subject: Re: [PATCH] dmaengine: k3: Fix duplicated function name and
 allmodconfig build
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Fri, 09 Jan 2015 15:32:14 +0100
In-reply-to: <1419858090-7682-1-git-send-email-k.kozlowski@samsung.com>
References: <1419858090-7682-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7oFz9aHGGyYKmAxfeoFRovVU/+y
	WlzeNYfNYuumvcwWL/v2sziwejzZdJHRY/Gel0wenzfJBTBHcdmkpOZklqUW6dslcGU0fJrM
	XrBRoGJHZydrA+MV3i5GTg4JAROJ690X2SBsMYkL99YD2VwcQgJLGSW+rdzEBJLgFRCU+DH5
	HksXIwcHs4C8xJFL2SBhZgF1iUnzFjGD2EICnxkl/u6EKteT+DZrESOILSwQKTGx7xxYnE3A
	WGLz8iVgu0QEtCUmzjnIDLKLWWASo0Tz8UawQSwCqhKrX64Ba+YUcJeYc3wuO8QCN4kfT88y
	g9wgIaAs0djvNoFRYBaS62YhXDcLyXULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE
	7pcdjIuPWR1iFOBgVOLh3aG6PkSINbGsuDL3EKMEB7OSCG/DZqAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxo37Jp3docMnmtI/6d7MjbV7//I82yCy0X5u77Y3WZ0JsyJ29d/JnMRi/DXeTaXA
	X33lvrvyV07s53h8dYMj43fxkK1yW1UWcTn9jZla8eCTQ/3ybz4NDWsnbdrcnW+Q3/59A9ND
	v2qxxudsR0u6QoK2iHDUzLOdO+WSU+JtpX0zI+SkjdMmRiqxFGckGmoxFxUnAgBW/5ohOgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-12-29 at 14:01 +0100, Krzysztof Kozlowski wrote:
> While splitting device control in db08425ebd51 ("dmaengine: k3:
> Split device_control") new function with the same 'k3_dma_resume' name
> was added, leading to build error:
> 
> drivers/dma/k3dma.c:823:12: error: conflicting types for ‘k3_dma_resume’
> drivers/dma/k3dma.c:625:12: note: previous definition of ‘k3_dma_resume’ was here
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Knock, knock.
Anyone care to pick it up? This is not a serious issue, the patch is
just to fix compiling (ARM, all{mod,yes}config on current next).

Best regards,
Krzysztof

> ---
>  drivers/dma/k3dma.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
> index 49be7f687c4c..a4ff7e9e68be 100644
> --- a/drivers/dma/k3dma.c
> +++ b/drivers/dma/k3dma.c
> @@ -601,7 +601,7 @@ static int k3_dma_terminate_all(struct dma_chan *chan)
>  	return 0;
>  }
>  
> -static int k3_dma_pause(struct dma_chan *chan)
> +static int k3_dma_transfer_pause(struct dma_chan *chan)
>  {
>  	struct k3_dma_chan *c = to_k3_chan(chan);
>  	struct k3_dma_dev *d = to_k3_dma(chan->device);
> @@ -622,7 +622,7 @@ static int k3_dma_pause(struct dma_chan *chan)
>  	return 0;
>  }
>  
> -static int k3_dma_resume(struct dma_chan *chan)
> +static int k3_dma_transfer_resume(struct dma_chan *chan)
>  {
>  	struct k3_dma_chan *c = to_k3_chan(chan);
>  	struct k3_dma_dev *d = to_k3_dma(chan->device);
> @@ -735,8 +735,8 @@ static int k3_dma_probe(struct platform_device *op)
>  	d->slave.device_prep_slave_sg = k3_dma_prep_slave_sg;
>  	d->slave.device_issue_pending = k3_dma_issue_pending;
>  	d->slave.device_config = k3_dma_config;
> -	d->slave.device_pause = k3_dma_pause;
> -	d->slave.device_resume = k3_dma_resume;
> +	d->slave.device_pause = k3_dma_transfer_pause;
> +	d->slave.device_resume = k3_dma_transfer_resume;
>  	d->slave.device_terminate_all = k3_dma_terminate_all;
>  	d->slave.copy_align = DMA_ALIGN;
>  

