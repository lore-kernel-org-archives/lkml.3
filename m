Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaFXRTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:19:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751598AbaFXRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:19:53 -0400
Date: Tue, 24 Jun 2014 13:19:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
In-Reply-To: <1403629121.1960.25.camel@x220>
Message-ID: <Pine.LNX.4.44L0.1406241317200.888-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Paul Bolle wrote:

> On Tue, 2014-06-24 at 10:25 -0400, Alan Stern wrote:
> > Also, that "Later kernels" thing has already arrived.  I believe it was 
> > implemented in 2.6.35.
> 
> How does the kernel currently call the disconnect method? I can't yet
> say for sure, and it seems silly to send a v2 dropping those lines
> without actually knowing why they can be dropped.

In drivers/usb/core/driver.c:usb_resume_complete(), which is called 
during the final "complete" phase of system suspend, interfaces that 
were marked for rebinding (because their drivers didn't have proper PM 
support) get rebound.

Is that what you wanted to know?

Alan Stern

