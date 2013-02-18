Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3BRRNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:13:41 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:63307 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3BRRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:13:38 -0500
Date: Mon, 18 Feb 2013 09:13:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218171334.GA31329@kroah.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218155215.GB2663@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 05:52:15PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Feb 18, 2013 at 07:50:12AM -0800, Greg KH wrote:
> > > If it helps in any way, I have printed below only the filenames
> > > (without path) so I could pipe it through uniq:
> > > 
> > > act_mask
> > > audit
> > > autosuspend_delay_ms
> > > bind
> > 
> > This one the driver core creates, I'll fix that up.
> > 
> > The rest need paths to determine who to blame :)
> 
> wanna see the full list ? It's 1602 lines :-p

You must have more devices in your system than I do:
	$ ruby ./sysfs_test.ruby  | wc -l
	626

What kernel version did you run this on?  I don't see any "bind" file in
the list on 3.8.0-rc7+:
	$ ls -l /sys/bus/platform/drivers/pcspkr/bind
	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/platform/drivers/pcspkr/bind
	$ ls -l /sys/bus/serio/drivers/atkbd/unbind
	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/serio/drivers/atkbd/unbind

So the full list might be necessary here, thanks.

greg k-h
