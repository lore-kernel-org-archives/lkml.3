Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaANRVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:21:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:39533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaANRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:21:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="466554048"
Date: Tue, 14 Jan 2014 09:20:56 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: walt <w41ter@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst [NEW HARDWARE]
Message-ID: <20140114172056.GB12126@xanatos>
References: <20140109235045.GA17660@xanatos>
 <52D4791B.3030309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D4791B.3030309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 03:39:07PM -0800, walt wrote:
> On 01/09/2014 03:50 PM, Sarah Sharp wrote:
> 
> >>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> >>
> >> I've wondered if my xhci problems might be caused by hardware quirks, and
> >> wondering why I seem to be the only one who has this problem.
> >>
> >> Maybe I could "take one for the team" by buying new hardware toys that I
> >> don't really need but I could use to test the xhci driver?  (I do enjoy
> >> buying new toys, necessary, or, um, maybe not :)
> > 
> > It would be appreciated if you could see if your device causes other
> > host controllers to fail.  Who am I to keep a geek from new toys? ;)
> 
> Sarah, I just fixed my xhci bug for US$19.99 :)
> 
> #lspci | tail -1
> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
> 
> This new NEC usb3 controller does everything the ASMedia controller should have
> done from the start.  I can even power-up the outboard usb3 disk docking station
> after the computer is running and still everything Just Works :)
> 
> I appreciate all the debugging work you've done to fix the ASMedia problem but
> I think it's time to quit now.  If hundreds of irate linux users complain about
> the same bug then I'll be happy to test more patches.

I just got a similar report from someone with a Fresco Logic host
controller, so I may need you to test a work-around patch for the
ASMedia host at some point.

I'm considering disabling the effect of David's patch for those two host
controllers.  That will mean USB storage works fine, but USB ethernet
may fail.

I had considered just disabling scatter-gather for the hosts, but we can
still run into the ethernet issue if we need to break a TRB at a 64KB
boundary.  So disabling scatter-gather would make USB ethernet work
_most of the time_, but fail intermittently, and USB storage performance
would be impacted.  Since USB ethernet will fail in either case, I would
rather keep USB storage performance and sacrifice USB ethernet on those
particular hosts.

So please keep the ASMedia host around for testing, if possible.

Sarah Sharp
