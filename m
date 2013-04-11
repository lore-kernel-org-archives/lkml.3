Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3DKQIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:08:31 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44591 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3DKQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:08:27 -0400
Date: Thu, 11 Apr 2013 09:08:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130411160825.GA24536@kroah.com>
References: <20130408182527.GB12889@kroah.com>
 <1365520315.18069.56@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365520315.18069.56@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 10:11:55AM -0500, Rob Landley wrote:
> 
> Or do you think it will simply never cause a problem, so there's no
> need to worry?

Based on the limited number of drivers that will be using this
interface, I don't think there's any need to worry.  But I will be glad
to revisit this in the future if needed.

> >> Or is this because containers allow UID/GID to be redefined, and
> >> thus imposing magic values on userspace can now be mapped away or
> >> something?
> >
> >I don't understand, what do you mean by this?
> 
> I mean that each container can have its own UID/GID namespace now, I
> was wondering if a driver claims a UID that an existing root
> filsystem is already using for something else, can a container remap
> it away so it doesn't conflict? Or will it still need manual udev
> rules to adjust at hotplug time?

I don't know how containers deal with the userspace major/minor device
nodes today at all, so I can't answer that.  But see the review comments
from Eric that he sent, I'll make the needed changes based on that so
all should be ok after that.

thanks,

greg k-h
