Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3JFIln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 04:41:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3JFIll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 04:41:41 -0400
Date: Sun, 6 Oct 2013 09:41:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
	mm/slab.c:3060
Message-ID: <20131006084120.GB12758@n2100.arm.linux.org.uk>
References: <20131006075811.GA22562@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006075811.GA22562@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:58:11PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
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
> mount: mounting proc on /proc failed: No such device
> grep: /proc/filesystems: No such file or directory
> [    4.188118] BUG: sleeping function called from invalid context at mm/slab.c:3060
> [    4.190236] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
> [    4.191696] 1 lock held by swapper/0/0:
> Starting Bootlog daemon: 
> [    4.192991]  #0:  (H

Sorry, I don't believe this one.  This patch adds no new allocation.
How does device_not_available() end up being called, or
math_state_restore() ?
