Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3G2FEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:04:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:37322 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab3G2FEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,766,1367996400"; 
   d="scan'208";a="338265687"
Date: Mon, 29 Jul 2013 12:48:17 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, yinghai@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130729164817.GA30371@linux-youquan.bj.intel.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com> <20130723091729.GA19786@gmail.com> <20130724140440.GA13987@linux-youquan.bj.intel.com> <20130725220122.GH18254@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725220122.GH18254@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks Ingo!
> > The machines will be affected: CPU support x2APIC and CPU number < 256,
> > chipset does not support VT-d2 or VT-d is disabled in BIOS. 
> 
> I mean, can you guess what rough percentage of new systems 
> shipping (or significant number of older systems already 
> shipped) will be affected by this?
> 
> My feeling is that this should be relatively rare (only 
> when a user reconfigures the BIOS, etc.), but I might be 
> wrong.

Sorry. I do not know what percentage of system shipped be affected.
I have encountered one affected machine which CPU support x2APIC but its
BIOS not support VT-d (BIOS also has no item to enable it). After apply
the patch, it works with X2APIC physical mode.

Of course, most of machine affected are in the case of disable VT-d in BIOS
 by option or add intremap=off kernel option. 

>From what I understand, the x2APIC physical mode should be compatiable
with legacy mode when CPU < 256 without support interrupt remapping.

I have tested many machines, both old and most recent machines and from desktop
 to server, x2APIC physical mode works without interrupt remapping when CPU < 256. 

Thanks
-Youquan
 
