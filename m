Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3JCOUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:20:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48142 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752477Ab3JCOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:20:14 -0400
Date: Thu, 3 Oct 2013 10:20:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Baldyga <r.baldyga@samsung.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH v4] USB: gadget: epautoconf: fix ep maxpacket check
In-Reply-To: <524D48BA.9060800@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1310031017010.1287-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Oct 2013, Robert Baldyga wrote:

> > This disagrees with the kerneldoc for usb_ep_autoconfig().  For bulk
> > endpoints, wMaxPacket is always supposed to be set to the full-speed
> > value, regardless of what the protocol driver specifies.
> 
> Hmm, it looks like all gadgets calls usb_ep_autoconfig() for full speed
> descriptors and after it they uses usb_assign_descriptors() function to 
> set descriptors proper for device speed.

Also, the gadgets have the wMaxPacketSize value hard-coded for the HS 
and SS descriptors.

>  And it works until gadget sets 
> full speed descriptors. But what if gadget supports only high speed and
> don't want to set full speed descriptors? If it will use
> usb_ep_autoconfig() function for high speed descriptor, value of
> wMaxPacketSize field will change to 64. Is there any good solution for 
> this problem or all gadgets have to support full speed?

The gadget driver can change wMaxPacketSize back to the correct value 
after calling usb_ep_autoconfig().

Or you can change the definition of usb_ep_autoconfig(), and have the 
driver pass the speed value as an additional argument.

Alan Stern

