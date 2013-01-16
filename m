Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3APPDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:03:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:43592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab3APPDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:03:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,479,1355126400"; 
   d="scan'208";a="272795941"
Message-ID: <1358348555.12502.27.camel@smile>
Subject: Re: [PATCH v3] dw_dmac: don't exceed AHB master number in
 dwc_get_data_width
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Wed, 16 Jan 2013 17:02:35 +0200
In-Reply-To: <CAOh2x=nChhB3Bo7CnEZm_86OPBootPd5CqRZ8LCgS5RC4KhMWg@mail.gmail.com>
References: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358344131-18097-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=nChhB3Bo7CnEZm_86OPBootPd5CqRZ8LCgS5RC4KhMWg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 19:37 +0530, Viresh Kumar wrote: 
> On Wed, Jan 16, 2013 at 7:18 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > +static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
> > +{
> > +       struct dw_dma *dw = to_dw_dma(chan->device);
> > +       struct dw_dma_slave *dws = chan->private;
> > +       unsigned int m = 0;
> 
> :(

There a protection of wrong master parameter.

In the code I did
if ()
m = ...
else if ()
m = ...

Otherwise it would be 0.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
