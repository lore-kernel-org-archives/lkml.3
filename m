Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaIAOQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:16:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58066 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752008AbaIAOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:16:39 -0400
Date: Mon, 1 Sep 2014 10:16:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mathias Nyman <mathias.nyman@intel.com>
cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
In-Reply-To: <54044C5C.9010305@intel.com>
Message-ID: <Pine.LNX.4.44L0.1409011013100.7410-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2014, Mathias Nyman wrote:

> On 09/01/2014 12:36 PM, Ricardo Ribalda Delgado wrote:
> > After some time of use (one hour or so) my system started to behave
> > "weird". I did check  dmesg and I was receiving the following line
> > again and again:
> > 
> > usb-storage: Error in queuecommand_lck: us->sfb= ffff8805bd61ccc0

This is probably caused by some transfer not occurring correctly.  With 
a usbmon trace we could see what was going on.

> > I did disconnect the usb device and the whole computer crashed :S
> > 
> 
> Ok, thanks.
> 
> Would you say things work better after the patch?
> 
> I still think the patch solves part of the issue, i.e. how we handle halted endpoints
> in reset, but I don't know the reason why the endpoints stall in the first place

The endpoint stall occurs because the device's protocol requires the
endpoint to stall.  The reason doesn't matter; xhci-hcd should handle 
stalls correctly whenever they occur.

Alan Stern

