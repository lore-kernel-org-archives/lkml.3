Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaJQILw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:11:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:58574 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaJQILh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="590753431"
Date: Fri, 17 Oct 2014 13:05:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ray Jui <rjui@broadcom.com>, Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
Message-ID: <20141017073535.GN1638@intel.com>
References: <rjui@broadcom.com>
 <1413506896-4536-1-git-send-email-rjui@broadcom.com>
 <5440C929.9050906@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5440C929.9050906@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
> On 10/17/2014 02:48 AM, Ray Jui wrote:
> >As part of subsystem that many slave drivers depend on, it's more
> >appropriate for the pl330 DMA driver to be initialized at
> >subsys_initcall than device_initcall
> 
> Well, we do have -EPROBE_DEFER these days to handle these kinds of
> dependencies so we no longer have to these kinds of manual init
> reordering tricks.
How ould that work?

Consider for example SPI and dmanegine. SPI driver got probed, then to start
a transaction requested a channel... while dmaengine driver is still getting
probed/not probed yet. So SPI driver didnt get a channel.

-- 
~Vinod

