Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaGBSth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:49:37 -0400
Received: from foo.stuge.se ([212.116.89.98]:45377 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbaGBStg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:49:36 -0400
Message-ID: <20140702184933.7464.qmail@stuge.se>
Date: Wed, 2 Jul 2014 20:49:33 +0200
From: Peter Stuge <peter@stuge.se>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Klug <stefan.klug@baslerweb.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Stefan Klug <stefan.klug@baslerweb.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <53B42B14.7010303@baslerweb.com> <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for working on this, Stefan.

Alan Stern wrote:
> Also, many host controllers cannot handle arbitrary alignment.  
> It would be best to require that the buffer start at a page boundary.

This requires a bit of negotiation with userspace, maybe per-URB but
it seems better to negotiate per-claim or even per-open. What about
large control transfers?


> Using a global module parameter to control the use of zerocopy (for
> anything other than debugging or testing) is a bad idea.

I agree.


> If you think people will have a reason for avoiding zerocopy then
> you should make it possible to decide for each URB, by adding a new
> flag to struct usbdevfs_urb.

People might want to use zerocopy always, but have buffers in
userspace which make that impossible with the given hardware.

It's important that the kernel gives userspace enough information
about the constraints, if userspace wants zerocopy.


> People will want to use zerocopy with isochronous transfers as well as 
> bulk.  Implementing that isn't going to be quite so easy; it will be 
> necessary for the user to set up a memory mapping.  In fact, once 
> that's done the same mechanism could be used for bulk transfers too.

Indeed I think userspace wants to be involved in choosing memory also
with bulk, in order to ensure that zerocopy will always work when
userspace cares about that.

Is it enough to expose the DMA mask of the host controller?


//Peter
