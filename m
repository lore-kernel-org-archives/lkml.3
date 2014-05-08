Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaEHPWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:22:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42670 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751910AbaEHPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:22:38 -0400
Date: Thu, 8 May 2014 11:22:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <liping.zhou@intel.com>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
In-Reply-To: <20140509030133.GK19925@intel.com>
Message-ID: <Pine.LNX.4.44L0.1405081118480.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Zhuang Jin Can wrote:

> > dwc3 _cannot_ return NYET to a SETUP packet.  The USB protocol does not 
> > allow it.  A device must always respond to SETUP with ACK.
> It true that device can not return NYET to a SETUP packet.
> A device must always respond to SETUP with ACK _if_ the SETUP packet is
> correctly received. Because there's no buffer prepared in ep0 for dwc3
> to receive the SETUP packet, I guess there will be no handshake
> returned to host. I can confirm this by doing an experiment tomorrow:)

The dwc3 driver should always prepare a buffer for the next ep0 SETUP
packet as soon as it retrieves the information for the current SETUP 
packet from the buffer.

Otherwise, as you described it, if the gadget driver never sends its 
delayed status response then the UDC will never respond to any more 
control transfers.

Alan Stern

