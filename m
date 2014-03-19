Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaCSTBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:01:25 -0400
Received: from imap.thunk.org ([74.207.234.97]:43666 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaCSTBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:01:23 -0400
Date: Wed, 19 Mar 2014 15:01:19 -0400
From: tytso@mit.edu
To: Nilesh More <nilesh99999@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Page cache corruption with mount/unmount of USB with Fat file
 system
Message-ID: <20140319190119.GC16906@thunk.org>
Mail-Followup-To: tytso@mit.edu, Nilesh More <nilesh99999@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAMbOQaVjS3Gzg0iJrxjyb3SD5sA1mm-gZeGEqaTG_B5z4-_pGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbOQaVjS3Gzg0iJrxjyb3SD5sA1mm-gZeGEqaTG_B5z4-_pGg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 12:05:44AM +0530, Nilesh More wrote:
> Hi all,
> 
> First of all sorry for the lengthy mail but I did not want to miss out
> on any details.
> 
> The following issue that I am reporting occurs when I plugin the USB
> drive on android tablet with USB mount support. Please note that this
> issue may or may not occur the first time I hotplug the USB drive. It
> might require couple of hotplug/hotunplug to see this issue. If
> anybody has/gets any clue about the possible root cause, please let me
> know.

And I'll repeat the comments I made a few weeks ago.  Last time you
reported this, you included a dmesg output which included this:

> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
> [ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227: inode
> #81827: block 328308: comm installd...

Are you seeing the same thing?  If so, the fundamental high level
issue is that the USB driver is reporting a device disconnect,
presumably of a USB device different from the one that you just
plugged in.   Are you still seeing this?

If so, it's important if you want to root cause this issue to
determine why the USB disconnect is happening, and not try to comment
out the page invalidations which happens *after* the USB device is
reported as disconnected.

If I had to guess, it's probably some hardware issue where when you
plug in a USB device that draws too much power, it's destablizing the
USB bus and causing some other USB device to report a disconnect.

    	    	    	       	   	  - Ted
