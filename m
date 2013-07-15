Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3GORDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:03:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3GORDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:03:05 -0400
Date: Mon, 15 Jul 2013 10:02:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
Message-ID: <20130715170244.GA29883@kroah.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715154050.GA5941@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:40:50AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Linus,
> 
> I am hoping you can help me draw an understanding and a line in sand whether:
>  a) Tools should not depend on /proc/config.gz to figure out whether
>     a kernel has some CONFIG_X=y feature.
> 
>  b) If they are OK to do so, what do we do when certain CONFIG_X options
>     get reworked/removed. Would they be considered regressions? Aka
>     is this similar to 'you shall not break user-space'?

CONFIG_ values never get exported to userspace, you need to dig to find
them, and they don't "mean" anything to userspace.

You should test for the functionality of the kernel, not a CONFIG
option, in my opinion.

I've been working with some userspace tools that were blindly looking at
kernel version numbers (i.e. docker), and that too is not a good idea as
distros backport features and fixes to older kernel versions, so you
can't "rely" on that either.

> Irrespective of that, do you have any ideas of how a user-space program (say GRUB)
> can figure out whether the configuration stanze it generates is supported by
> the kernel. If you don't want to answer this question - since this might
> open a can of worms you prefer not to deal with - that is absolutly OK.

Why does grub need to care about the kernel configuration?  Other
bootloaders sure don't.  A bootloader just needs to load a blob and pass
control over to it, no need to care what is in that blob at all, right?

What am I missing here?

thanks,

gre gk-h
