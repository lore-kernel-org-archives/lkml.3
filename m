Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaJGTQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:16:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42821 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932101AbaJGTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:16:14 -0400
Date: Tue, 7 Oct 2014 15:16:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <20141007185706.GC17409@saruman>
Message-ID: <Pine.LNX.4.44L0.1410071510030.1504-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Felipe Balbi wrote:

> > If the file handle was closed for abnormal reasons, we can behave like 
> > crashed firmware.  Which means, in the end, doing the same thing as in 
> > the normal-reason case -- i.e., do nothing.  In particular, don't 
> > disconnect.
> > 
> > If you want to allow for the possibility of orderly shutdown (and maybe 
> > even possible restart) of a userspace handler, the function library 
> > should first tell the kernel explicitly to disconnect.  Then function 
> > components can be changed around completely, and when everything is 
> > ready, userspace can tell the kernel to connect again.
> 
> I still feel iffy about it, but I must say I understand where you're
> coming from. It's weird to force a disconnect, sure. I guess we could

Well, it's not all that weird.  Devices disconnect automatically when
they receive a firmware update, so that they can reconnect with new
descriptors.  Much the same thing should happen if the user wants to
replace one function driver with a different one.

I guess the real idea is to give the user a choice of disconnecting or 
not.  Don't always force the whole device to disconnect when one of the 
function drivers goes away.

> accept this with a new option (just not 'zombie', perhaps no_disconnect
> :-) but only if we still have the same "delay pullups until daemon is
> running" requirement.

Seems reasonable to me.  Or something that can be adjusted while the 
library is running, as opposed to setting an option once when the 
library starts.

> /me hides

I'm out of further ideas.  What do the library designers think?

Alan Stern

