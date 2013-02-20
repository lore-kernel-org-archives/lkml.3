Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3BTGFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:05:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:33843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab3BTGFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:05:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="289406623"
Date: Wed, 20 Feb 2013 11:34:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130220060417.GB23302@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1361264544.28241.52.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361264544.28241.52.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 11:02:24AM +0200, Andy Shevchenko wrote:
> On Mon, 2013-01-28 at 13:04 +0200, Andy Shevchenko wrote: 
> > On some hardware configurations we have got the request line with the offset.
> > The patch introduces convert_slave_id() helper for that cases. The request line
> > base is got from the platform device resources provided by the IORESOURCE_DMA
> > type.
> 
> Hi, Vinod.
> 
> v3.8 is just out, and we have not got any proposal from anyone how to
> make our approach better. So, I'm just wondering about current state.
I was trying to go thru ACPI 5 and see a solution, i think we 
- use IORESOURCE_IO, but they have a specfic meaning
- accpet this patch with IORESOURCE_DMA, but again this has specfic dma meaning
  too. Just becoz you are in slave-dma driver, doesn't justify use of
  IORESOURCE_DMA as well
- use platform_data (somehow get this from CSRT into device parsing logic of
  ACPI where you create your platform device and add this in platform data

> Rafael, could you share your opinion about our case with CSRT and
> request line base (perhaps you need to go through the entire thread)?
Sure, do we have anything better than above?

--
~Vinod
