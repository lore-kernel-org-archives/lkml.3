Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaEBPf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:35:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:27403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaEBPf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="532549632"
Date: Fri, 2 May 2014 23:35:44 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: fix burst size corruption
Message-ID: <20140503033544.GA19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140501211424.GE30575@intel.com>
 <Pine.LNX.4.44L0.1405010941550.1152-100000@iolanthe.rowland.org>
 <20140501151500.GC6355@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501151500.GC6355@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 01, 2014 at 10:15:00AM -0500, Felipe Balbi wrote:
> On Thu, May 01, 2014 at 09:45:17AM -0400, Alan Stern wrote:
> > On Thu, 1 May 2014, Zhuang Jin Can wrote:
> > > > again, you found a bug on the gadget driver. Fix that. composite.c
> > > > guarantees that for those functions which don't pass bMaxBurst,
> > > > gadget->maxburst will be set to *at least* 1.
> > > > 
> > > I agree the real fix should be in the gadget driver. The patch intents
> > > to prevent hibernatition from being corrupted by a bad gadget driver.
> > > If OEMs develop their own gadget driver forgetting to call
> > > config_ep_by_speed(), it'll turn out to be everything works except
> > > dwc3 hibernation, and they'll complain to dwc3. f_ffs is an
> > > example has SuperSpeed support but doesn't call config_ep_by_speed().
> > > It's just for robustness, and dwc3 is not doing anything wrong.
> > > It did cause me a long time to figure out why the hibernation was broken.
> > 
> > You could include the check, for the sake of robustness, in dwc3 -- but
> > if it fails, you should write a message to the kernel log saying that
> > the gadget driver needs to be fixed.
I admit the fix is too paranoid. Thanks your comment.

> 
> Also, if we're adding something to dwc3, we need to add to other
> USB3-capable UDCs too. Namely dummy and marvel's.
So I think the fix is not valuable to you. Thanks for your comment.
And I'm new to communitiy, hope you can bear with me:)

Jincan
