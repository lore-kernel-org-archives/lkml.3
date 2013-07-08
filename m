Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3GHOTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:19:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:54455 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3GHOTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="328219855"
Date: Mon, 8 Jul 2013 19:10:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [RFC] dmaengine: add dma_slave_get_caps api
Message-ID: <20130708134024.GH16653@intel.com>
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
 <51DAAA1F.5050002@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DAAA1F.5050002@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 02:01:35PM +0200, Lars-Peter Clausen wrote:
> On 07/08/2013 10:54 AM, Vinod Koul wrote:
> > +/* struct dma_slave_caps - expose capabilities of a slave channel only
> > + *
> > + * @src_addr_widths: bit mask of src addr widths the channel supports
> > + * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
> > + * @src_burst_lengths: bit mask of src slave burst lengths supported
> > + * @dstn_burst_lengths: bit mask of dstn slave burst lengths supported
> 
> I'm not sure if we need the burst_lengths fields. For one we can only
> express a max burst length up 32. And usually it is fine if the dma
> controller does not support the burst length requested by the slave driver,
> since this only specifies the maximum and the dma controller driver can
> choose a value below this limit. E.g. if the max burst length is set to 16
> it is still fine if the controller only supports a burst length of 8.
well how are you picking up which one to use?
The idea is that you query and match that with system and client to get best
throughput. If you have IP block which over generations change capablities you
can runtime query and then program the channel smartly!

> > +static inline struct dma_slave_caps *dma_get_slave_caps(struct dma_chan *chan)
> 
> Same comment as for Matt's patch. The caller of the dma_get_slave_caps()
> should pass in a pointer to a dma_slave_caps struct which the dma driver
> will then fill in. This makes it much clearer to the caller what the
> lifetime of the struct is.
Yup i agree, will update...

~Vinod
-- 
