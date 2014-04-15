Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaDORzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:55:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42606 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754442AbaDORzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:55:40 -0400
Date: Tue, 15 Apr 2014 13:55:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: sundeep subbaraya <sundeep.lkml@gmail.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
In-Reply-To: <20140415171830.GB16002@saruman.home>
Message-ID: <Pine.LNX.4.44L0.1404151345580.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Felipe Balbi wrote:

> > 2. Does device need to know OUT transactions before hand so that OUT
> > requests are queued for endpoint before packets are received
> > from host?
> 
> well, no. Gadget driver shouldn't depend on that. That's UDC driver's
> responsability to manage that. I mean, if host sends OUT token and
> there's nothing in the out queue, then UDC need to start transfer as
> soon as gadget driver queues the request. If, on the other hand, gadget
> driver queues packet before host has sent OUT token then you have two
> choices:
> 
> 1) start the transfer - most HW will wait for OUT token
> 2) wait for out token

I'm not familiar with the variations in all the different UDC hardware.  
Nevertheless, I wouldn't describe the situation in those terms.

If an OUT transaction occurs and the gadget driver hasn't queued a
request, the UDC hardware could store the incoming data in an internal
buffer or it could NAK the transaction.  There aren't any other
choices.  If there isn't enough space available in an internal buffer,
the only possible action is NAK.

Regardless, gadget drivers do not need to queue requests for OUT
endpoints before the host starts sending data.  When the request does
get queued, the UDC driver will make sure that the transfer takes
place.

Alan Stern

