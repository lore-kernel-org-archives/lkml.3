Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3JVSWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:22:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:61068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3JVSWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423048314"
Date: Tue, 22 Oct 2013 11:19:30 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Message-ID: <20131022181930.GA53231@bingao-desk1.fm.intel.com>
References: <5265C0C5.70905@linux.intel.com>
 <20131022054406.GA14163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022054406.GA14163@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:44:06AM +0100, Greg Kroah-Hartman wrote:
> So, just because userspace is "hard" you want to add stuff to the kernel
> instead.
> 
Well, there are other reasons - "hard" is just one of them.
For instance, on some platforms with runtime pm enabled, access to registers
of a device which is in low power state will cause problems(syste reboot, etc.).
You can only wake it up to running state by runtime API from kernel space.

> Sorry, but for over the past decade, we have been doing just the
> opposite, if things can be done in userspace, then they should be done
> there.  So for us to go in the opposite direction, like these patches
> show, would be a major change.
> 
Agree, but as mentioned above, for some situation we can't do it from
user space.

> You can already do this today for PCI with the UIO framework, right?
> Why duplicate that functionality here with another userapce API that we
> will then have to maintain for the next 40+ years?
> 
No, UIO is not appropriate for my requirement.
The thing I need is to dump any registers just by 2 simple commands.

> All of your patches are line-wrapped and totally fail to apply, so even
> if we wanted to take this type of changes, I couldn't :(
> 
Sorry for that. I recently upgraded my email client, will fix it next posting.

> Have you run these proposed changes by any of the Intel kernel
> developers?  What did they say to them?
> 
> If not, why haven't you, isn't that a resource you should be using for
> things like this?
> 
Why you had these strange questions?
Over years, we have been maintaining and using these drivers internally 
for various purpose across our group for SoC pre-silicon and post-silicon
degugging, e.g. IOAPIC RTE dumping, GPIO tunning, raw device degugging
without a driver(i2c, spi, uart), etc., etc., ...
Trying to push some existed codes upstream is not a bad thing.

> greg k-h
