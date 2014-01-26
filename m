Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaAZLYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 06:24:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:63164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaAZLYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 06:24:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,723,1384329600"; 
   d="scan'208";a="464877780"
Date: Sun, 26 Jan 2014 16:53:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH] dma: fix vchan_cookie_complete() debug print
Message-ID: <20140126112358.GC10628@intel.com>
References: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
 <20140120095917.GZ26823@intel.com>
 <20140120112822.GA15937@n2100.arm.linux.org.uk>
 <20140120120301.GE26823@intel.com>
 <20140120132829.GD15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120132829.GD15937@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:28:29PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 20, 2014 at 05:33:01PM +0530, Vinod Koul wrote:
> > On Mon, Jan 20, 2014 at 11:28:22AM +0000, Russell King - ARM Linux wrote:
> > > On Mon, Jan 20, 2014 at 03:29:17PM +0530, Vinod Koul wrote:
> > > > On Fri, Dec 06, 2013 at 04:42:09PM +0100, Jonas Jensen wrote:
> > > > > vd->tx.cookie is set zero on dma_cookie_complete(),
> > > > > save to local before printing it.
> > > > > 
> > > > > Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> > > > > ---
> > > > > 
> > > > > Notes:
> > > > >     dev_vdbg() could also be moved to happen earlier, what do you prefer?
> > > > This would be preferred IMHO. Also pls cc dmaengine@vger on this
> > > 
> > > I prefer this version - it means that the verbose debug printk doesn't
> > > impact the completion timing when printk is expensive (eg, because its
> > > outputting via a serial port.)
> > But if you know your printk is costly, do you want to enable these?
> 
> dev_vdbg() is for verbose debugging - you only enable it if you really
> need to.  Even so, it should have _minimal_ impact where possible.  That's
> why I prefer the first patch, because we mark the cookie as being
> complete _before_ we call the verbose debugging, which isn't going to add
> milliseconds to that.
Sure this version is better approach in that respect as it makes it debug
aognostic! Both mine and Dan's comment were trying to simlify by ignoring debug
option, but yes i do agree to you point here. So this patch will be applied!

> If you don't care about debugging, then getting rid of the dev_vdbg().
> But really, I could pull rank and say that this is *my* file, I get to
> choose how stuff should be done here - I'd prefer not to but...
That is not required!

--
~Vinod
