Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3K0KzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:55:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14363 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3K0KzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:55:14 -0500
X-AuditID: cbfee61a-b7f316d000007e34-3c-5295cf908af2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: remove unused function
Date: Wed, 27 Nov 2013 11:54:56 +0100
Message-id: <6220753.6QAEVtRX51@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1385491415-31325-1-git-send-email-olof@lixom.net>
References: <1385491415-31325-1-git-send-email-olof@lixom.net>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd0J56cGGRz/q2QxfeoFRovVU/+y
	WpxtesNucXnXHDaLb5eb2S1OXf/M5sDmseDXVhaPxXteMnlcOdHE6tG3ZRWjx+dNcgGsUVw2
	Kak5mWWpRfp2CVwZC26sYirYzF2x8+g85gbG9ZxdjJwcEgImEi9332GDsMUkLtxbD2RzcQgJ
	LGKU+HzpOROE08IkcW/daxaQKjYBK4mJ7asYQWwRAWWJJ22XmEGKmAXWMEp09k9kB0kICzhI
	PH60BcxmEVCV6L+yihXE5hXQlHi7o5kZxBYV8JTYsX0l2GpOAXuJzScOgS0QErCTuH/nKxNE
	vaDEj8n3wOLMAvIS+/ZPZYWwdST2t05jm8AoMAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzez6R2MK5ssDjEKMDBqMTDO+HylCAh1sSy4srcQ4wSHMxKIryZJ6cG
	CfGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamCce8nJ5bF8
	yFqnTRPKi3oUsrMLzZ19O2+eZxD4pPHgYeoit+flKfluoV/6LntNEs7N2Gj89ATr5pM6Xi3b
	ay6te9h++Hx20b7DOyfu+TJVS79TvChlwubrrXycj25/mnTZ2fFjSIzlhO7jwZOKQ10+WbL/
	YUgz+/ZafunUnYqTA77/vt907PdjJZbijERDLeai4kQAHo7Wp2sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Olof,

On Tuesday, November 26, 2013 10:43:35 AM Olof Johansson wrote:
> commit 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> refactored some code which resulted in an unused function in the at_hdmac
> driver:
> 
> drivers/dma/at_hdmac_regs.h:350:23: warning: 'chan2parent' defined but
>     not used [-Wunused-function]
> 
> Fixes: 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for catching and fixing this.

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
> 
> Dan,
> 
> Looks like you fixed up the DesignWare driver for the same issue but
> this needs it to.
> 
>  drivers/dma/at_hdmac_regs.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index f31d647acdfa..2787aba60c6b 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -347,10 +347,6 @@ static struct device *chan2dev(struct dma_chan *chan)
>  {
>  	return &chan->dev->device;
>  }
> -static struct device *chan2parent(struct dma_chan *chan)
> -{
> -	return chan->dev->device.parent;
> -}
>  
>  #if defined(VERBOSE_DEBUG)
>  static void vdbg_dump_regs(struct at_dma_chan *atchan)

