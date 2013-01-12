Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3ALWwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:52:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48069 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754448Ab3ALWwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:52:17 -0500
Date: Sat, 12 Jan 2013 17:52:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alex Riesen <raa.lkml@gmail.com>
cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <CALxABCb1Z5fg4zPfTa5ka7WDjUNZSR4-n4P+fazdQLMD4F5njw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301121748360.4723-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2013, Alex Riesen wrote:

> On Sat, Jan 12, 2013 at 8:39 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > On Sat, Jan 12, 2013 at 6:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> On Sat, 12 Jan 2013, Alex Riesen wrote:
> >>> One more detail: I usually use the "noop" elevator. That time it was
> >>> the "deadline". And I just reproduced it easily with "deadline".
> >>
> >> I doubt the elevator has anything to do with this.
> >
> > But it looks like it does: just using the deadline elevator is a sure way
> > to reproduce the bug. The system always recovers (sometimes after a while)
> > with "noop".
> 
> And no, it does not. Not by itself, but the fact that deadline elevator was
> compiled as module certainly helped!
> 
> This explains the hanging modprobe in the dmesg output (the part after device
> connect). I still wonder, why didn't it froze at boot, mounting SATA devices
> (the root, /var, and /home are on an SSD connected by SATA)? And why hanging
> khubd at reboot?
> 
> Anyway, building the elevator in the kernel avoids the problem. Sorry for
> not spotting this earlier.
> 
> Now, who would be interested to handle this kind of misconfiguration ...

So the whole thing was a false alarm?

Maybe you should report to the block-layer maintainers that it's 
possible to mess up the system by building an elevator as a module.  
That sounds like the sort of thing they'd be interested to hear.

Alan Stern

