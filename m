Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab3BNKNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:13:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:50939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431Ab3BNKNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:13:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,664,1355126400"; 
   d="scan'208";a="202282401"
Date: Thu, 14 Feb 2013 12:17:09 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
Message-ID: <20130214101709.GF20771@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
 <20130212155334.GK3789@intel.com>
 <20130212164351.GA20771@intel.com>
 <20130212173435.GA17659@intel.com>
 <20130212190236.GD20771@intel.com>
 <20130214095738.GD27887@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214095738.GD27887@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 03:27:38PM +0530, Vinod Koul wrote:
> Not in the CSRT parser. Once your plaform devices are created, you can add your
> own board handler for each platform device. This board code, using the
> data availble from CSRT can go ahead and do the translation and present the
> actual addresses to dmac.
> Would this be doable with ACPI5.

I'm not sure what you mean by own board handler?

AFAIK, the only platform specific code is under arch/x86/platform/* but we
don't have such thing for Lynxpoint and it should not be needed as we can
enumerate the devices from ACPI.

> Somehow I dont like the idea of DMA resource for request lines. DMA
> resources have specific meaning, perhpas IO resource maybe better idea.

Well, it's a DMA request line so we thought that IORESOURCE_DMA would suit
fine there and the drivers that use these are well aware of their usage.
Not sure about IORESOURCE_IO, it has also specific meaning and I don't
think DMA request lines fit there either :-(
