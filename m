Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3F3VQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:16:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:13135 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab3F3VQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,969,1363158000"; 
   d="scan'208";a="362953869"
Date: Sun, 30 Jun 2013 14:16:04 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Yuan-Hsin Chen <yuanlmm@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, Felipe Balbi <balbi@ti.com>,
        florian@openwrt.org, USB list <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ratbert <ratbert.chuang@gmail.com>,
        John Feng-Hsin =?utf-8?B?Q2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Subject: Re: [PATCH] usb: host: Faraday fotg210-hcd driver
Message-ID: <20130630211604.GD4946@xanatos>
References: <CADB-GoKACJnearpDL+kxxsW6ez=2cbP0UDgbZNL+uNN0bswDog@mail.gmail.com>
 <Pine.LNX.4.44L0.1306181039440.1157-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1306181039440.1157-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:43:56AM -0400, Alan Stern wrote:
> On Tue, 18 Jun 2013, Yuan-Hsin Chen wrote:
> 
> > > In that case, no, you should be figuring out how to refactor and reuse
> > > the EHCI code instead of copying it straight into your driver.
> > 
> > I was trying to use ehci-platform.c, anonymous union/struct, and quirk
> > flags to avoid copying EHCI code.
> > But there are too big incompatibilities between fotg210/fusbh200
> > controller and EHCI.
> > That's why Alan agreed that I could create a stand-alone driver for
> > fusbh200 host controller.
> > Since fotg210 and fusbh200 have the same issue,  fotg210 hcd is
> > supposed to be stand-alone.
> > More details please refer to mail sequence
> > http://www.spinics.net/lists/linux-usb/msg83812.html
> 
> That's right.  The patch's description mentions some of the
> incompatibilities.  In short, the Faraday controllers are a _very_
> noncompliant EHCI variant.  The changes needed to make ehci-hcd work
> with them were too invasive IMO.
>
> It's a shame, because so much of the code is the same.  It makes you 
> want to go back and ask those Faraday engineers what they were thinking 
> of at the time.

Ah, ok, that's too bad.  I understand why the code can't be refactored.

Sarah Sharp
