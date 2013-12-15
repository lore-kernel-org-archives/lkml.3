Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3LORBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:01:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3LORBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:01:24 -0500
Date: Sun, 15 Dec 2013 09:03:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Levente Kurusa <levex@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] treewide: add missing put_device calls
Message-ID: <20131215170325.GA28799@kroah.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
 <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com>
 <20131214172419.GC22520@kroah.com>
 <52AD606F.50408@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AD606F.50408@linux.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 08:55:27AM +0100, Levente Kurusa wrote:
> On 12/14/2013 06:24 PM, Greg Kroah-Hartman wrote:
> > On Fri, Dec 13, 2013 at 01:42:05PM -0700, Bjorn Helgaas wrote:
> >> [+cc Greg]
> >>
> >> On Fri, Dec 13, 2013 at 12:22 PM, Levente Kurusa <levex@linux.com> wrote:
> >>> Hi,
> >>>
> >>> This is just the beginning of patchset-set that aims to fix possible
> >>> problems caused by not calling put_device() if device_register() fails.
> >>>
> >>> The root cause for the need to call put_device() is that the underlying
> >>> kobject still has a reference count of 1. Thus, device.release() will not
> >>> be called and the device will just sit there waiting for a put_device().
> >>> Adding the put_device() also removes the need for the call to kfree() as most
> >>> release functions already call kfree() on the container of the device.
> >>>
> >>> While these have not been experienced, they are potential issues and thus
> >>> they need to be fixed. Also, they are a few more files that have the same
> >>> kind of issue, those will be fixed if these are accepted.
> >>
> >> Thanks for doing this.  This is the sort of mistake that just gets
> >> copied everywhere, so fixing the examples in the tree will help
> >> prevent the problem from spreading more.
> >>
> >> I don't know if there's really value in having device_register()
> >> return an error but rely on the caller to do the put_device().  Are
> >> there cases where the caller still needs the struct device even if
> >> device_register() fails?  E.g., could we do something like this
> >> instead (I know some callers would also require corresponding changes
> >> to avoid double puts):
> 
> There are cases where it is needed. There are quite a few files which
> when device_register() fails, the driver print an error messages.

That shouldn't be needed, and can be removed.

> IIRC, there are also a few where the device is also unregistered from
> the specific subsystem's core.

Do you have a specific example of this?  This should happen in the
release function of the device already, not in some other code.

thanks,

greg k-h
