Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaJOIdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 04:33:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:23299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaJOIdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 04:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,722,1406617200"; 
   d="scan'208";a="605623266"
Date: Wed, 15 Oct 2014 13:27:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RESEND PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check
 for pl330_submit_req parameters
Message-ID: <20141015075747.GK1638@intel.com>
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
 <20141014115118.GG1638@intel.com>
 <543D19A9.5010109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543D19A9.5010109@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:40:09PM +0200, Lars-Peter Clausen wrote:
> On 10/14/2014 01:51 PM, Vinod Koul wrote:
> >On Mon, Sep 29, 2014 at 02:42:18PM +0200, Krzysztof Kozlowski wrote:
> >>The pl330_submit_req() checked supplied 'struct pl330_thread thrd' and
> >>'struct dma_pl330_desc desc' parameters for non-NULL. However these
> >>checks are useless because supplied arguments won't be NULL.
> >even if we have some error or bug?
> >
> >I would like this to be checked and complained loudly so we know something
> >is going wrong rather than assuming it will be correct always.
> >
> 
> In this case it is impossible to get to this code portion if the
> pointer is NULL because it would have crashed earlier.
Yes checking again,
for desc it seems not neccessary as its deref earlier in calling code and
thrd shouldnt be NULL, so will apply now

-- 
~Vinod
