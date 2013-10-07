Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3JGImm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:42:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab3JGIml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:42:41 -0400
Date: Mon, 7 Oct 2013 09:42:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] jump label safety checks break automatic numa
 balancing
Message-ID: <20131007084237.GE11028@suse.de>
References: <20130930143955.GF2425@suse.de>
 <20131004110356.42a2d268@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131004110356.42a2d268@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 11:03:56AM -0400, Steven Rostedt wrote:
> 
> FYI, please remove my redhat email from your address book. I don't read
> my RH email when I travel (which I've been doing a lot lately).
> 
> 
> On Fri, 04 Oct 2013 10:44:00 -0400
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > With CONFIG_NUMA_BALANCING=y and booting with numa_balancing=enable
> > there is a crash very early in the lifetime of the system. By setting
> > earlyprintk=ttyS0,115200 the error is visible and looks something like
> > this
> > 
> > [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11.0-vanilla+ root=/dev/sda5 reboot=pci console=tty0 console=ttyS0,115200 numa_balancing=enable earlyprintk=ttyS0,115200
> > [    0.000000] Unexpected op at task_numa_fault+0x1d/0xa0 [ffffffff81085ded] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:53
> > PANIC: early exception 06 rip 10:ffffffff815b2663 error 0 cr2 ffff88107ffff000
> 
> What's at ffffffff815b2663?
> 

kernel/sched/fair.c:5901

-- 
Mel Gorman
SUSE Labs
