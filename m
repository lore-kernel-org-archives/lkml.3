Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3LSMmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:42:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40229 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3LSMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:42:33 -0500
Date: Thu, 19 Dec 2013 13:42:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Masami Ichikawa <masami256@gmail.com>
Cc: len.brown@intel.com, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: Fix memory leak in pm_vt_switch_unregister().
Message-ID: <20131219124228.GA11928@amd.pavel.ucw.cz>
References: <1387450847-23797-1-git-send-email-masami256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387450847-23797-1-git-send-email-masami256@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-12-19 20:00:47, Masami Ichikawa wrote:
> kmemleak reported a memory leak as below.
> 
> unreferenced object 0xffff880118f14700 (size 32):
>   comm "swapper/0", pid 1, jiffies 4294877401 (age 123.283s)
>   hex dump (first 32 bytes):
>     00 01 10 00 00 00 ad de 00 02 20 00 00 00 ad de  .......... .....
>     00 d4 d2 18 01 88 ff ff 01 00 00 00 00 04 00 00  ................
>   backtrace:
>     [<ffffffff814edb1e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811889dc>] kmem_cache_alloc_trace+0x1ec/0x260
>     [<ffffffff810aba66>] pm_vt_switch_required+0x76/0xb0
>     [<ffffffff812f39f5>] register_framebuffer+0x195/0x320
>     [<ffffffff8130af18>] efifb_probe+0x718/0x780
>     [<ffffffff81391495>] platform_drv_probe+0x45/0xb0
>     [<ffffffff8138f407>] driver_probe_device+0x87/0x3a0
>     [<ffffffff8138f7f3>] __driver_attach+0x93/0xa0
>     [<ffffffff8138d413>] bus_for_each_dev+0x63/0xa0
>     [<ffffffff8138ee5e>] driver_attach+0x1e/0x20
>     [<ffffffff8138ea40>] bus_add_driver+0x180/0x250
>     [<ffffffff8138fe74>] driver_register+0x64/0xf0
>     [<ffffffff813913ba>] __platform_driver_register+0x4a/0x50
>     [<ffffffff8191e028>] efifb_driver_init+0x12/0x14
>     [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
>     [<ffffffff818e40e0>] kernel_init_freeable+0x17b/0x201
> 
> In pm_vt_switch_required(), "entry" variable is allocated via kmalloc().
> So, in pm_vt_switch_unregister(), it needs to call kfree() when object
> is deleted from list.
> 
> Signed-off-by: Masami Ichikawa <masami256@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
