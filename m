Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3AVHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:25:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:35465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3AVHZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:25:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,512,1355126400"; 
   d="scan'208";a="250574924"
Message-ID: <1358839491.12502.41.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Tue, 22 Jan 2013 09:24:51 +0200
In-Reply-To: <20130121142205.GB26562@intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130121084924.GA26562@intel.com> <1358761551.12502.39.camel@smile>
	 <20130121142205.GB26562@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 06:22 -0800, Vinod Koul wrote: 
> On Mon, Jan 21, 2013 at 11:45:51AM +0200, Andy Shevchenko wrote:
> > > > +	return 0;
> > > hmmm, why not use BLOCK_TS value. That way you dont need to look at direction
> > > and along with burst can easily calculate residue...
> > 
> > Do you mean to read CTL hi/lo and do
> > 
> > desc->len - ctlhi.block_ts * ctllo.src_tr_width?
> > 
> Yes
> > I think it could be not precise when memory-to-peripheral transfer is
> > going on. In that case you probably will have src_tr_width like 32 bits,
> > meanwhile peripheral may receive only byte stream.
> Nope that is not the case.
> SAR/DAR is always incremented in src/dstn_tr_width granularity. For example if
> you are using MEM to DMA, then SAR will always increment in case of x86 in 4byte
> granularity as we will read bursts not singles.
> 
> Also if check the spec, it says "Once the transfer starts, the read-back value is the
> total number of data items already read from the source peripheral, regardless of
> what is the flow controller"
> 
> So basically you get what is read from buffer in case of MEM->PER and get what
> is read from FIFO in case of PER->MEM which IMO gives you better or equal results
> than your calulation.

I will try this. Indeed I don't like usage of direction as well, and
your solution seems much clear in that sense.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
