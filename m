Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3EXGbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:31:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:6019 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3EXGbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,732,1363158000"; 
   d="scan'208";a="339309875"
Date: Fri, 24 May 2013 11:24:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/6] dma: Add a jz4740 dmaengine driver
Message-ID: <20130524055453.GR30200@intel.com>
References: <1369341387-19147-1-git-send-email-lars@metafoo.de>
 <1369341387-19147-4-git-send-email-lars@metafoo.de>
 <20130524045935.GM30200@intel.com>
 <519F016C.4040901@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519F016C.4040901@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 07:58:04AM +0200, Lars-Peter Clausen wrote:
> This one needs both.
> 
> >> +	jzcfg.mode = JZ4740_DMA_MODE_SINGLE;
> >> +	jzcfg.request_type = config->slave_id;
> >> +
> >> +	chan->config = *config;
> >> +
> >> +	jz4740_dma_configure(chan->jz_chan, &jzcfg);
> >> +
> >> +	return 0;
> > You are NOT use src_addr/dstn_addr? How else are you passing the periphral
> > address?
> I'm saving the whole config, which will later be used to retrieve the source or
> dest address.
well I missed that and it is a bad idea. You dont know when client has
freed/thrown the pointer so copy this instead..

> 
> >> +}
> [...]
> >> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
> >> +{
> >> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> >> +
> >> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
> >> +	if (!chan->jz_chan)
> >> +		return -EBUSY;
> >> +
> >> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
> >> +
> >> +	return 0;
> > Zero is not expected value, you need to return the descriptors allocated
> > sucessfully.
> 
> Well, zero descriptors have been allocated. As far as I can see only a negative
> return value is treated as an error. Also the core doesn't seem to use the
> return value for anything else but checking if it is an error.
This is the API defination
* @device_alloc_chan_resources: allocate resources and return the
*      number of allocated descriptors

> >> +}
> >> +
> [...]
> >> +	dd->chancnt = 6;
> > hard coding is not advised
> 
> But there are 6 channels ;)
JZ4740_MAX_CH 6 :)

--
~Vinod
