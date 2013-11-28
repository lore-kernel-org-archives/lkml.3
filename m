Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab3K1Qws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:52:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:38542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3K1Qwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:52:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,791,1378882800"; 
   d="scan'208";a="443770252"
Date: Thu, 28 Nov 2013 18:59:22 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
Message-ID: <20131128165922.GC2281@intel.com>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
 <CACRpkda-TtKQr6hDx4corjxYv7r7f6_9sNp_2ocbvg9MHyOk7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda-TtKQr6hDx4corjxYv7r7f6_9sNp_2ocbvg9MHyOk7Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:45:37PM +0100, Linus Walleij wrote:
> On Thu, Nov 28, 2013 at 9:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Change the format of the platform GPIO lookup tables to make them less
> > confusing and improve lookup efficiency.
> >
> > The previous format was a single linked-list that required to compare
> > the device name and function ID of every single GPIO defined for each
> > lookup. Switch that to a list of per-device tables, so that the lookup
> > can be done in two steps, omitting the GPIOs that are not relevant for a
> > particular device.
> >
> > The matching rules are now defined as follows:
> > - The device name must match *exactly*, and can be NULL for GPIOs not
> >   assigned to a particular device,
> > - If the function ID in the lookup table is NULL, the con_id argument of
> >   gpiod_get() will not be used for lookup. However, if it is defined, it
> >   must match exactly.
> > - The index must always match.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > Let's change this bad design before more users start using it. ;)
> 
> OK given that Mika has based his patches on this I'll request
> that he ACK this and then I'll merge this so that he can put
> this patch at the bottom of his patch stack.
> 
> Mika: requesting ACK.

Alexandre, please check Andy's comments.

Apart from that this looks good to me.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
