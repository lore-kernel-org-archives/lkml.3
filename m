Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaDNTIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:08:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDNTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:08:44 -0400
Date: Mon, 14 Apr 2014 12:11:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140414191143.GA26864@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414145359.48b7337c@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:53:59PM +0200, Jean Delvare wrote:
> Hi all,
> 
> Configuring kernels from scratch has become an incredibly long and
> tedious task. The reason is that the number of drivers and options has
> exploded in the past few years. Which in itself is great - Linux is
> successful, yeah! - but the side effects must be dealt with.
> 6000-line .config files are no fun.
> 
> Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
> configuration. The two ethernet drivers below this menu are for ARM
> machines. I really shouldn't be asked about that on x86-64. I just sent
> a patch addressing this specific issue, which follows about 50 similar
> patches from me for similar issues in various subsystems. But I can't
> do all of that by myself, this is too much work quantitatively, and I
> am not always the best person to find out the proper hardware
> dependencies that should be added.

Ideally, the arch doesn't matter at all for a driver, only the
infrastructure the driver depends on does.  So perhaps the
"infrastructure" dependancy should be added for the drivers that you
feel are only present on ARM platforms?  Are these all platform devices?

> I would like to call for proper hardware dependencies to become a
> general trend: every new hardware-specific driver which is added to the
> kernel should depend on ($hardware || COMPILE_TEST), so as to make it
> clear right away, which type of hardware is expected to need the driver
> in question.

Adding more COMPILE_TEST dependancies for platform drivers would be
wonderful to have, and make your life a little bit easier.  Other than
that, a simple 'm' selection for a distro config should be fine :)

thanks,

greg k-h
