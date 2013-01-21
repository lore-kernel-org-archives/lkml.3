Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3AUOrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:47:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:30582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab3AUOrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:47:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,506,1355126400"; 
   d="scan'208";a="279817365"
Date: Mon, 21 Jan 2013 06:22:05 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
Message-ID: <20130121142205.GB26562@intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130121084924.GA26562@intel.com>
 <1358761551.12502.39.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358761551.12502.39.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:45:51AM +0200, Andy Shevchenko wrote:
> > > +	return 0;
> > hmmm, why not use BLOCK_TS value. That way you dont need to look at direction
> > and along with burst can easily calculate residue...
> 
> Do you mean to read CTL hi/lo and do
> 
> desc->len - ctlhi.block_ts * ctllo.src_tr_width?
> 
Yes
> I think it could be not precise when memory-to-peripheral transfer is
> going on. In that case you probably will have src_tr_width like 32 bits,
> meanwhile peripheral may receive only byte stream.
Nope that is not the case.
SAR/DAR is always incremented in src/dstn_tr_width granularity. For example if
you are using MEM to DMA, then SAR will always increment in case of x86 in 4byte
granularity as we will read bursts not singles.

Also if check the spec, it says "Once the transfer starts, the read-back value is the
total number of data items already read from the source peripheral, regardless of
what is the flow controller"

So basically you get what is read from buffer in case of MEM->PER and get what
is read from FIFO in case of PER->MEM which IMO gives you better or equal results
than your calulation.

--
~Vinod
