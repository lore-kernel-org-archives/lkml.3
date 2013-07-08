Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3GHOm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:42:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:17747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3GHOmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="265438737"
Date: Mon, 8 Jul 2013 19:33:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [RFC] dmaengine: add dma_slave_get_caps api
Message-ID: <20130708140357.GI16653@intel.com>
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
 <51DAAA1F.5050002@metafoo.de>
 <20130708134024.GH16653@intel.com>
 <51DACC8D.5020201@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DACC8D.5020201@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 04:28:29PM +0200, Lars-Peter Clausen wrote:
> On 07/08/2013 03:40 PM, Vinod Koul wrote:
> > On Mon, Jul 08, 2013 at 02:01:35PM +0200, Lars-Peter Clausen wrote:
> >> On 07/08/2013 10:54 AM, Vinod Koul wrote:
> >>> +/* struct dma_slave_caps - expose capabilities of a slave channel only
> >>> + *
> >>> + * @src_addr_widths: bit mask of src addr widths the channel supports
> >>> + * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
> >>> + * @src_burst_lengths: bit mask of src slave burst lengths supported
> >>> + * @dstn_burst_lengths: bit mask of dstn slave burst lengths supported
> >>
> >> I'm not sure if we need the burst_lengths fields. For one we can only
> >> express a max burst length up 32. And usually it is fine if the dma
> >> controller does not support the burst length requested by the slave driver,
> >> since this only specifies the maximum and the dma controller driver can
> >> choose a value below this limit. E.g. if the max burst length is set to 16
> >> it is still fine if the controller only supports a burst length of 8.
> > well how are you picking up which one to use?
> > The idea is that you query and match that with system and client to get best
> > throughput. If you have IP block which over generations change capablities you
> > can runtime query and then program the channel smartly!
> 
> The client would always request the largest burst size it can support, and
> the dma master would then select a burst size equal or smaller to it
> depending on what it can support.
not really, most dmac drivers will return an error when they find a value is not
in the supported list. And that is precisely what we would like to prevent.
If you look at current model, it mostly program value which we know is already
a capablity and works model.

> E.g. if the client has an internal FIFO with room for 16 samples and it
> sends a request once the FIFO is half empty, max_burst would be set to 8. If
> the master supports burst sizes of 8 sample it would send 8 samples, if it
> only supported burst sizes of 4 it might send either one burst of 4 or two of 4.

~Vinod
-- 
