Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab3ICUz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:55:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838Ab3ICUz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:55:28 -0400
Date: Tue, 3 Sep 2013 13:55:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rmk+kernel@arm.linux.org.uk
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130903205527.GA6358@kroah.com>
References: <20130903185924.046EE660E91@gitolite.kernel.org>
 <20130903204442.GA22222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903204442.GA22222@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 04:44:42PM -0400, Dave Jones wrote:
> On Tue, Sep 03, 2013 at 06:59:24PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=c817a67ecba7c3c2aaa104796d78f160af60920d
>  > Commit:     c817a67ecba7c3c2aaa104796d78f160af60920d
>  > Parent:     7c42721fe0c58a848849b43ff558cf2fb86aa35a
>  > Author:     Russell King <rmk+kernel@arm.linux.org.uk>
>  > AuthorDate: Thu Jun 27 15:06:14 2013 +0100
>  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  > CommitDate: Thu Jul 25 15:39:04 2013 -0700
>  > 
>  >     kobject: delayed kobject release: help find buggy drivers
>  >     
>  >     Implement debugging for kobject release functions.  kobjects are
>  >     reference counted, so the drop of the last reference to them is not
>  >     predictable. However, the common case is for the last reference to be
>  >     the kobject's removal from a subsystem, which results in the release
>  >     function being immediately called.
>  >     
>  >     This can hide subtle bugs, which can occur when another thread holds a
>  >     reference to the kobject at the same time that a kobject is removed.
>  >     This results in the release method being delayed.
>  >     
>  >     In order to make these kinds of problems more visible, the following
>  >     patch implements a delayed release; this has the effect that the
>  >     release function will be out of order with respect to the removal of
>  >     the kobject in the same manner that it would be if a reference was
>  >     being held.
>  >     
>  >     This provides us with an easy way to allow driver writers to debug
>  >     their drivers and fix otherwise hidden problems.
>  >     
>  >     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>  >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> With this enabled, I get a bunch of scrolling oopses immediately after
> exiting the bootloader. It happens so early I can't even capture them
> over usb-serial, or earlyprintk=dbgp.
> 
> And for whatever reason, the printk path while oopsing ignores boot_delay parameter,
> so I can't even use that.
> 
> any ideas ?

The first big bug found with this was with the module kobject code, and
a fix for that should be going in through Rusty's tree to Linus for this
merge window (right Rusty?)

After that, things should settle down and boot properly, although a few
bugs have been reported already to their respective subsystem owners, I
don't know the status of them yet.

thanks,

greg k-h
