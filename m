Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3DWEPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:15:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:1060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3DWEPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,531,1363158000"; 
   d="scan'208";a="326610423"
Date: Tue, 23 Apr 2013 09:14:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-i2c@vger.kernel.org,
        plagnioj@jcrosoft.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] at_hdmac: move to generic DMA binding
Message-ID: <20130423034407.GY24632@intel.com>
References: <1366362683-14496-1-git-send-email-ludovic.desroches@atmel.com>
 <1366362683-14496-2-git-send-email-ludovic.desroches@atmel.com>
 <51750F68.4040701@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51750F68.4040701@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:22:32PM +0200, Nicolas Ferre wrote:
> On 04/19/2013 11:11 AM, ludovic.desroches@atmel.com :
> > From: Ludovic Desroches <ludovic.desroches@atmel.com>

> > +#ifdef CONFIG_OF
> > +static bool at_dma_filter(struct dma_chan *chan, void *slave)
this is not defined for else case here. Also this could be CONFIG_DMA_OF...?
> > +{
> > +	struct at_dma_slave *atslave = slave;
> > +
> > +	if (atslave->dma_dev == chan->device->dev) {
> > +		chan->private = atslave;
> > +		return true;
> > +	} else {
> > +		return false;
> > +	}
> > +}

--
~Vinod
