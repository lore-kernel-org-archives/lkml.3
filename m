Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707Ab3BNJ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:58:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:34115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab3BNJ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,664,1355126400"; 
   d="scan'208";a="262536313"
Date: Thu, 14 Feb 2013 15:27:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130214095738.GD27887@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
 <20130212155334.GK3789@intel.com>
 <20130212164351.GA20771@intel.com>
 <20130212173435.GA17659@intel.com>
 <20130212190236.GD20771@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212190236.GD20771@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:02:36PM +0200, Mika Westerberg wrote:
> > Okay, who parses the CSRT table and how is this presented to OS.
> 
> ACPI code, found under drivers/acpi/csrt.c handles this. Note that this
> code is heading 3.9 so it is not in mainline yet but available in
> linux-pm.git/linux-next branch. I can dig the commit id if you are
> interested.
> 
> > Can we do this in platform data and complete the base calculation.
> 
> Do you mean platform data for the dmac driver?
> 
> The CSRT parser code can't know what the platform data requirements for the
> particular dmac driver are. It only creates the platform devices and adds
> MMIO, IRQ and possible DMA resources. It is up to the (dmac) driver to use
> this information for whatever purposes in needs.
Not in the CSRT parser. Once your plaform devices are created, you can add your
own board handler for each platform device. This board code, using the
data availble from CSRT can go ahead and do the translation and present the
actual addresses to dmac.
Would this be doable with ACPI5.

Somehow I dont like the idea of DMA resource for request lines. DMA resources
have specific meaning, perhpas IO resource maybe better idea.

--
~Vinod
