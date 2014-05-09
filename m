Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaEHPBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:01:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:9757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaEHPBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="537123485"
Date: Thu, 8 May 2014 23:01:33 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        liping.zhou@intel.com, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140509030133.GK19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140508160046.GJ19925@intel.com>
 <Pine.LNX.4.44L0.1405081019230.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405081019230.1087-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 10:25:46AM -0400, Alan Stern wrote:
> On Thu, 8 May 2014, Zhuang Jin Can wrote:
> 
> > > When the host already timed out the control transfer and started a new 
> > > one.  Here's what I'm talking about:
> > > 
> > > 	Host sends a Set-Configuration request.
> > > 
> > > 	The UDC driver calls the gadget driver's setup function.
> > > 
> > > 	The setup function returns DELAYED_STATUS.
> > > 
> > > 	After a few seconds, the host gets tired of waiting and
> > > 	sends a Get-Descriptor request
> > My understanding is dwc3 will return NYET to host for this
> > Get-Descriptor request transaction, as dwc3 is still in STATUS phase,
> > there's no buffer to receive anything in ep0-out.
> 
> dwc3 _cannot_ return NYET to a SETUP packet.  The USB protocol does not 
> allow it.  A device must always respond to SETUP with ACK.
It true that device can not return NYET to a SETUP packet.
A device must always respond to SETUP with ACK _if_ the SETUP packet is
correctly received. Because there's no buffer prepared in ep0 for dwc3
to receive the SETUP packet, I guess there will be no handshake
returned to host. I can confirm this by doing an experiment tomorrow:)

Jincan
