Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3LPSSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:18:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3LPSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:18:23 -0500
Date: Mon, 16 Dec 2013 10:18:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Levente Kurusa <levex@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] treewide: add missing put_device calls
Message-ID: <20131216181822.GA2522@kroah.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
 <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com>
 <20131214172419.GC22520@kroah.com>
 <52AD606F.50408@linux.com>
 <20131215170325.GA28799@kroah.com>
 <52AF35FD.8000904@linux.com>
 <20131216175848.GB2007@kroah.com>
 <52AF4249.8030000@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AF4249.8030000@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:11:21PM +0100, Levente Kurusa wrote:
> On 12/16/2013 06:58 PM, Greg Kroah-Hartman wrote:
> > On Mon, Dec 16, 2013 at 06:18:53PM +0100, Levente Kurusa wrote:
> >>>> IIRC, there are also a few where the device is also unregistered from
> >>>> the specific subsystem's core.
> >>>
> >>> Do you have a specific example of this?  This should happen in the
> >>> release function of the device already, not in some other code.
> >>>
> >> Character drivers who register with device_register() call cdev_del()
> >> when device_register() fails.
> > 
> > A cdev shouldn't be created until _after_ the device is successfully
> > registered, as it could be opened and accessed before the device is
> > registered.  That sounds like the drivers that do that should be fixed
> > (have an example of this somewhere?)
> 
> I did some research and it seems it has mostly been my false memory that made
> me think that. The only example I could find that did something like this
> was: drivers/scsi/osd/osd_uld.c at line 403.
> 
> When the device_register() fails it immediately jumps to a cdev_del();

That should be easy to reorginize to not do this (i.e. do the cdev_add()
call after the device_register() call, if needed.

thanks,

greg k-h
