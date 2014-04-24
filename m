Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaDXTVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:21:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54699 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbaDXTVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:21:15 -0400
X-Sasl-enc: qDQ8/7SaHuHM2SPBoxSm0fuHmFxx/beShSi/yDzMei5w 1398367274
Date: Thu, 24 Apr 2014 12:24:06 -0700
From: Greg KH <greg@kroah.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-usb@vger.kernel.org, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: usb: mon: freeing active timer
Message-ID: <20140424192406.GA6054@kroah.com>
References: <53594C7E.1080407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53594C7E.1080407@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 01:40:14PM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following:
> 
> [ 1361.390880] WARNING: CPU: 10 PID: 24274 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
> [ 1361.391203] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x20
> [ 1361.391203] Modules linked in:
> [ 1361.391203] CPU: 10 PID: 24274 Comm: trinity-c83 Not tainted 3.15.0-rc2-next-20140423-sasha-00018-gc4ff6c4 #408
> [ 1361.391203]  0000000000000009 ffff8801de341c78 ffffffffb85271f2 0000000000000001
> [ 1361.391203]  ffff8801de341cc8 ffff8801de341cb8 ffffffffb515afcc ffff8801eb3ebd98
> [ 1361.391203]  ffff8801eb751870 ffffffffb9e76200 ffffffffb98dc502 ffffffffbc702550
> [ 1361.391203] Call Trace:
> [ 1361.391203] dump_stack (lib/dump_stack.c:52)
> [ 1361.391203] warn_slowpath_common (kernel/panic.c:430)
> [ 1361.391203] warn_slowpath_fmt (kernel/panic.c:445)
> [ 1361.391203] debug_print_object (lib/debugobjects.c:262)
> [ 1361.391203] ? __queue_work (kernel/workqueue.c:1452)
> [ 1361.391203] __debug_check_no_obj_freed (lib/debugobjects.c:697)
> [ 1361.391203] debug_check_no_obj_freed (lib/debugobjects.c:726)
> [ 1361.391203] kmem_cache_free (mm/slub.c:2689 mm/slub.c:2717)
> [ 1361.391203] ? kmem_cache_destroy (mm/slab_common.c:363)
> [ 1361.391203] kmem_cache_destroy (mm/slab_common.c:363)
> [ 1361.391203] mon_text_release (drivers/usb/mon/mon_text.c:643)
> [ 1361.391203] __fput (fs/file_table.c:217)
> [ 1361.391203] ____fput (fs/file_table.c:253)
> [ 1361.391203] task_work_run (kernel/task_work.c:125 (discriminator 1))
> [ 1361.391203] do_notify_resume (include/linux/tracehook.h:196 arch/x86/kernel/signal.c:751)
> [ 1361.391203] int_signal (arch/x86/kernel/entry_64.S:807)

So you were running usbmon at the time?  Were you actually monitoring a
specific USB device/bus, or something else?

thanks,

greg k-h
