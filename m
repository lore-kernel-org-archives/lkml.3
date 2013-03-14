Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3CNUcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:32:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35431 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752288Ab3CNUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:32:47 -0400
Date: Thu, 14 Mar 2013 16:32:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Soeren Moch <smoch@web.de>
cc: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <linux-mm@kvack.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
In-Reply-To: <51421B89.6020308@web.de>
Message-ID: <Pine.LNX.4.44L0.1303141630550.1194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Soeren Moch wrote:

> >> I added a debug message to
> >> drivers/usb/host/ehci-sched.c:itd_urb_transaction() to log the
> >> allocation flags, see log below.
> >
> > But it looks like you didn't add a message to end_free_itds(), so we
> > don't know when the memory gets deallocated.  And you didn't print out
> > the values of urb, num_itds, and i, or the value of itd (so we can
> > match up allocations against deallocations).
> 
> OK, I will implement this more detailed logging. But with several 
> allocations per second and runtime of several hours this will result in 
> a very long logfile.

If the memory really is being leaked here in some sort of systematic
way, we may be able to see it in your debugging output after a few
seconds.

Alan Stern

