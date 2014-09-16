Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaIPPy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:54:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:13289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaIPPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:54:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,535,1406617200"; 
   d="scan'208";a="477892495"
Date: Tue, 16 Sep 2014 20:59:03 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>, hpa@zytor.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Add memcpy32_toio to write to PCI MMIO
Message-ID: <20140916152903.GR3131@intel.com>
References: <1410164046-15577-1-git-send-email-subhransu.s.prusty@intel.com>
 <540EB3CE.6010700@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540EB3CE.6010700@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:01:18AM +0200, Clemens Ladisch wrote:
> Subhransu S. Prusty wrote:
> > This is needed because the hardware
> 
> Which hardware?  Every x86-64 CPU ever built by AMD, Intel, and VIA?
Baytrail and few other SoCs
> 
> > does not support 64-bit moveq insructions while writing to PCI MMIO.
> 
> > +#ifndef CONFIG_X86_64
> > +#define MEMCPY_TOIO memcpy_toio
> > +#else
> > +#define MEMCPY_TOIO memcpy32_toio
> > +#endif
> 
> This does not change any code that uses memcpy_toio().
So the devices cant do 64bit memcpy_toio so we are forced to use 32bit
copies only. This given us such an option
> 
> > +	for (i = 0; i < count/sizeof(u32); i++)
> > +		writel(*src_32++, dst_32++);
> 
> This breaks when count is not a multiple of four.
Ah yes, we can fix that

-- 
~Vinod

