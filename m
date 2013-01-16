Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3APNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:39:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:64984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3APNjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,479,1355126400"; 
   d="scan'208";a="272761329"
Message-ID: <1358343551.12502.25.camel@smile>
Subject: Re: [PATCH] dw_dmac: switch to use dma_pool API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Wed, 16 Jan 2013 15:39:11 +0200
In-Reply-To: <CAOh2x=k2M_U_f4ztjCkO5rxGg=-P-5ghHKXPJHNVkWq8=-jqYg@mail.gmail.com>
References: <1358327443-10562-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=k2M_U_f4ztjCkO5rxGg=-P-5ghHKXPJHNVkWq8=-jqYg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 15:18 +0530, Viresh Kumar wrote: 
> > @@ -1125,7 +1083,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
> > +               memset(desc, 0, sizeof(struct dw_desc));
> > +
> 
> why do we need this? We always fill all fields of this structure, isn't it?

No, it is not. At least we don't fill everything at
alloc_chan_resources() stage. Previous code used kzalloc. I decide to
use memset to avoid potential side effects in the future.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
