Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3HYEHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 00:07:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3HYEH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 00:07:29 -0400
Date: Sat, 24 Aug 2013 21:09:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Ben Dooks <ben@simtec.co.uk>, Wolfram Sang <w.sang@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [tps_init] BUG: unable to handle kernel paging request at
 484970c9
Message-ID: <20130825040939.GB17883@kroah.com>
References: <20130825000421.GC26317@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825000421.GC26317@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 08:04:21AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> It seems the below patch discloses a bug in tps_init().
> 
> commit c817a67ecba7c3c2aaa104796d78f160af60920d
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Thu Jun 27 15:06:14 2013 +0100
> 
>     kobject: delayed kobject release: help find buggy drivers
>     
>     Implement debugging for kobject release functions.  kobjects are
>     reference counted, so the drop of the last reference to them is not
>     predictable. However, the common case is for the last reference to be
>     the kobject's removal from a subsystem, which results in the release
>     function being immediately called.
>     
>     This can hide subtle bugs, which can occur when another thread holds a
>     reference to the kobject at the same time that a kobject is removed.
>     This results in the release method being delayed.
>     
>     In order to make these kinds of problems more visible, the following
>     patch implements a delayed release; this has the effect that the
>     release function will be out of order with respect to the removal of
>     the kobject in the same manner that it would be if a reference was
>     being held.
>     
>     This provides us with an easy way to allow driver writers to debug
>     their drivers and fix otherwise hidden problems.
>     
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> Parent commit not clean. Look out for wrong bisect!
> 
> BUG: kernel boot crashed
> 
> /kernel/i386-randconfig-j1-08220808/7c42721fe0c58a848849b43ff558cf2fb86aa35a/dmesg-kvm-nhm4-6710-20130824125721-3.11.0-rc2-00007-ge56341a-282
> 
> [    0.304827] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:530 sysfs_add_one+0x89/0x9b()
> [    0.306316] sysfs: cannot create duplicate filename '/bus/i2c/drivers/tps65010'

Same as before, are you unloading and loading modules?  We have a fix
for modules that cause problems when unloading with the config option
above enabled.  But that shouldn't be this issue.

thanks,

greg k-h
