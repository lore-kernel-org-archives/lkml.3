Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3JQOkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:40:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3JQOkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:40:02 -0400
Date: Thu, 17 Oct 2013 16:39:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
In-Reply-To: <20131017142755.GA4477@breakpoint.cc>
Message-ID: <Pine.LNX.4.64.1310171638030.27369@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com> <20131017142755.GA4477@breakpoint.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:d+hHtXo3+I8TBwVcao8uGrU41zg7U0y7DgNpyWCad4X
 KhsBNLX5Mgefd0A7z6jgMyvAnS+bvr73meeSCFUwJGXsYu3GxA
 kBAaHPwc1DPV0U1YJr56Du77/ue57MQQxV2NCenWG1MW/+Dhcb
 qnQT69ak+ZL/h5GRm+2e5JRui60IjQSI0Zm7B/kK7NutLboHni
 cOAcpAOh1m4idRkEAnCVlM5r7Y+5yVUSiDmQ9/Jo8zBJRzQojR
 /XbxAiLyNBotFzWFqun9jSw5dHpX4DmdLkftE2T46V+bfQ+cmS
 R4ohyWYKYMwL34hY0pKrPPiR3JfTAQM3kkm2Y3zk3F5fhkhlSd
 ReyVxx8fXpTTAeDhTFi8D1E2j3BxOAQvKv76aWHSS+rcCuVPG/
 dR7dL3lcI6+OA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian

On Thu, 17 Oct 2013, Sebastian Andrzej Siewior wrote:

> On Thu, Oct 17, 2013 at 07:37:45AM +0530, Vinod Koul wrote:
> > index 0bc7275..683c380 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
> >  
> >  /**
> >   * enum dma_status - DMA transaction status
> > - * @DMA_SUCCESS: transaction completed successfully
> > + * @DMA_COMPLETE: transaction completed
> >   * @DMA_IN_PROGRESS: transaction not yet processed
> >   * @DMA_PAUSED: transaction is paused
> >   * @DMA_ERROR: transaction failed
> >   */
> >  enum dma_status {
> > -	DMA_SUCCESS,
> > +	DMA_COMPLETE,
> >  	DMA_IN_PROGRESS,
> >  	DMA_PAUSED,
> >  	DMA_ERROR,
> > +	DMA_SUCCESS,
> >  };
> 
> There are some drivers which compare against == or != DMA_SUCCESS. Shouldn't this
> become
>   enum dma_status {
>  -	DMA_SUCCESS,
>  +	DMA_COMPLETE = 0, DMA_SUCCESS = 0,
>   	DMA_IN_PROGRESS,
>   	DMA_PAUSED,
>   	DMA_ERROR,
>   };
> 
> so nothing breaks during the transition?

Good catch. I would do

 enum dma_status {
-	DMA_SUCCESS,
+	DMA_COMPLETE,
 	DMA_IN_PROGRESS,
 	DMA_PAUSED,
 	DMA_ERROR,
 };
 
+ #define DMA_SUCCESS DMA_COMPLETE

and then just remove the last line again

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
