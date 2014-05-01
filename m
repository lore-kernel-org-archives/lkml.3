Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaEANpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:45:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753128AbaEANpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:45:18 -0400
Date: Thu, 1 May 2014 09:45:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
cc: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: fix burst size corruption
In-Reply-To: <20140501211424.GE30575@intel.com>
Message-ID: <Pine.LNX.4.44L0.1405010941550.1152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Zhuang Jin Can wrote:

> > again, you found a bug on the gadget driver. Fix that. composite.c
> > guarantees that for those functions which don't pass bMaxBurst,
> > gadget->maxburst will be set to *at least* 1.
> > 
> I agree the real fix should be in the gadget driver. The patch intents
> to prevent hibernatition from being corrupted by a bad gadget driver.
> If OEMs develop their own gadget driver forgetting to call
> config_ep_by_speed(), it'll turn out to be everything works except
> dwc3 hibernation, and they'll complain to dwc3. f_ffs is an
> example has SuperSpeed support but doesn't call config_ep_by_speed().
> It's just for robustness, and dwc3 is not doing anything wrong.
> It did cause me a long time to figure out why the hibernation was broken.

You could include the check, for the sake of robustness, in dwc3 -- but
if it fails, you should write a message to the kernel log saying that
the gadget driver needs to be fixed.

Alan Stern

