Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478AbaH0XlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:41:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316AbaH0XlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:41:22 -0400
Date: Wed, 27 Aug 2014 16:41:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Message-ID: <20140827234121.GA12195@kroah.com>
References: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827202301.GA13800@kroah.com>
 <20140827205129.GA25227@kroah.com>
 <CAPybu_2p0UroO=WwUOC3LybPq0HQymoD50v6-6gA+aVweveOHw@mail.gmail.com>
 <20140827210405.GA26372@kroah.com>
 <CAPybu_2p6+VXj0s+yWGRvTO-1W-=rkhCBVKFHqa25joEO+Q3zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2p6+VXj0s+yWGRvTO-1W-=rkhCBVKFHqa25joEO+Q3zA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:10:42PM +0200, Ricardo Ribalda Delgado wrote:
> Hello Greg
> 
> On Wed, Aug 27, 2014 at 11:04 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Aug 27, 2014 at 10:56:57PM +0200, Ricardo Ribalda Delgado wrote:
> >> No worries,
> >>
> >> I have to mark for stable it or Bjorn? It it is me, how :) ?
> >
> > Bjorn can when he applies it, for details on the process, see the kernel
> > file Documentation/stable_kernel_rules.txt
> >
> >> ps: For other people reading this thread, the kmod/modprobe is in
> >> http://anonscm.debian.org/cgit/users/md/kmod.git/tree/libkmod/libkmod-index.c
> >> and handles all the modalias as strings without differing the type.
> >
> > That sounds wrong, and odds are, will cause more problems over time.
> > These are hex values, not strings :(
> 
> I totally see your point, but I disagree on the method.
> 
> I think is our resposibility (modalias/file2alias) to provide a
> matcheable string, otherwise modprobe should be aware of all the types
> (pci, usb, spi, vmbus.....)
> 
> As we keep adding types, and they don't follow any standard, we would
> be adding a dependecy between kmod and the kernel, and duplicating
> code.  That is bad systemwise
> 
> Maybe the code on kmod should not be case sensitive, that is all :)

But this is a class field, which is a bit field, so it can't be compared
with a string compare, as it's a numerical value, not a string...

So maybe kmod needs to be fixed up?

thanks,

greg k-h
