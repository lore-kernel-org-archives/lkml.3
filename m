Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IQOHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:07:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55108 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:07:33 -0400
Date: Tue, 17 Sep 2013 15:01:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [pps_ktimer_event] WARNING: CPU: 0 PID: 1 at
	lib/list_debug.c:33 __list_add()
Message-ID: <20130917140153.GR12758@n2100.arm.linux.org.uk>
References: <20130917135122.GA17015@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917135122.GA17015@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 09:51:22PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is

I'm afraid this report is virtually useless in terms of debugging what's
going on, because the timer list has been corrupted by some bad driver
kfree()'ing memory associated with a kobject before its release function
has been called.

This contains no hint as to whom is responsible for that.

I've tried to improve the debugging by decoupling the delayed work queue
from its associated kobject, but that has proven to be a fruitless task
due to the antics that x86 gets up to in its early initialisation.

I'm stumped with this; I can't see how we can get sane debugging out of
the kernel.

What we should have done is have explicitly delayed kobject releasing
from the very outset of sysfs to prevent this kind of madness from day
one - but we didn't and now we have something of a nasty headache with
it.
