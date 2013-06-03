Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3FCIYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:24:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:29457 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3FCIYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="343923772"
Message-ID: <1370247842.29283.243.camel@smile>
Subject: Re: [RFC PATCH v0 1/2] dma: move dw_dmac driver to an own directory
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 03 Jun 2013 11:24:02 +0300
In-Reply-To: <CAKohpomwHMP=0hxkv4rLRWty28h6F408wmPq6FU_vixL1X-krA@mail.gmail.com>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1370015432-17259-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpomwHMP=0hxkv4rLRWty28h6F408wmPq6FU_vixL1X-krA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 10:25 +0530, Viresh Kumar wrote: 
> On 31 May 2013 21:20, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> > +obj-$(CONFIG_DW_DMAC) += dw/
> 
> > +++ b/drivers/dma/dw/Makefile
> > +obj-$(CONFIG_DW_DMAC) += dw_dmac.o
> 
> The lower one should be obj-y += dw_dmac.o as this will always
> be true.

Imagine the case when we choose platform driver to be compiled as a
module. It means both variables set to m.

During compilation we will have core part compiled-in, and platform part
as a module.

I don't think this is what we want. 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
