Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab3GXCTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:19:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:8086 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3GXCTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,732,1367996400"; 
   d="scan'208";a="335831285"
Date: Wed, 24 Jul 2013 10:04:40 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, yinghai@kernel.org, tglx@linutronix.de,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130724140440.GA13987@linux-youquan.bj.intel.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com> <20130723091729.GA19786@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723091729.GA19786@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:17:29AM +0200, Ingo Molnar wrote:
> 
> * Youquan Song <youquan.song@intel.com> wrote:
> 
> > x2APIC extends APICID from 8 bits to 32 bits, but the device interrupt 
> > routed from IOAPIC or delivered in MSI mode will keep 8 bits destination 
> > APICID. In order to support x2APIC, the VT-d interrupt remapping is 
> > introduced to translate the destination APICID to 32 bits in x2APIC mode 
> > and keep the device compatible in this way.
> > 
> > x2APIC support both logical and physical mode in destination mode.  In 
> > logical destination mode, the 32 bits Logical APICID has 2 sub-fields:
> >  16 bits cluster ID and 16 bits logical ID within the cluster and it is 
> > required VT-d interrupt remapping in x2APIC cluster mode. In physical 
> > destination mode, the 8 bits physical id is compatible with 32 bits 
> > physical id when CPU number < 256. When interrupt remapping 
> > initialization fail on platform with CPU number < 256, current kernel 
> > only enables x2APIC physical mode in virutalization environment, while 
> > we also can enable x2APIC physcial mode in native kernel this situation, 
> > and the device interrupt will use 8 bits destination APICID in physical 
> > mode and be compatible with x2APIC physical when < 256 CPUs.
> >  
> > So we can benefit from x2APIC vs xAPIC MMIO:
> >  - x2APIC MSR read/write is faster than xAPIC mmio
> >  - x2APIC only ICR write to deliver interrupt without polling ICR deliver 
> >    status bit and xAPIC need poll to read ICR deliver status bit.
> >  - x2APIC 64 bits ICR access instead of xAPIC two 32 bits access.
> 
> That looks interesting. How many systems are affected by this change in 
> practice? Have you tested it on affected hardware?

Thanks Ingo!
The machines will be affected: CPU support x2APIC and CPU number < 256,
chipset does not support VT-d2 or VT-d is disabled in BIOS. 

I have tested on one of affected hardware, it works.

Thanks
-Youquan
