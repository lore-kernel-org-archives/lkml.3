Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3LVAtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 19:49:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65069 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754482Ab3LVAtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 19:49:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Masami Ichikawa <masami256@gmail.com>, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: Fix memory leak in pm_vt_switch_unregister().
Date: Sun, 22 Dec 2013 02:02:24 +0100
Message-ID: <1708288.nAHm0VPirU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131219124228.GA11928@amd.pavel.ucw.cz>
References: <1387450847-23797-1-git-send-email-masami256@gmail.com> <20131219124228.GA11928@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 01:42:28 PM Pavel Machek wrote:
> On Thu 2013-12-19 20:00:47, Masami Ichikawa wrote:
> > kmemleak reported a memory leak as below.
> > 
> > unreferenced object 0xffff880118f14700 (size 32):
> >   comm "swapper/0", pid 1, jiffies 4294877401 (age 123.283s)
> >   hex dump (first 32 bytes):
> >     00 01 10 00 00 00 ad de 00 02 20 00 00 00 ad de  .......... .....
> >     00 d4 d2 18 01 88 ff ff 01 00 00 00 00 04 00 00  ................
> >   backtrace:
> >     [<ffffffff814edb1e>] kmemleak_alloc+0x4e/0xb0
> >     [<ffffffff811889dc>] kmem_cache_alloc_trace+0x1ec/0x260
> >     [<ffffffff810aba66>] pm_vt_switch_required+0x76/0xb0
> >     [<ffffffff812f39f5>] register_framebuffer+0x195/0x320
> >     [<ffffffff8130af18>] efifb_probe+0x718/0x780
> >     [<ffffffff81391495>] platform_drv_probe+0x45/0xb0
> >     [<ffffffff8138f407>] driver_probe_device+0x87/0x3a0
> >     [<ffffffff8138f7f3>] __driver_attach+0x93/0xa0
> >     [<ffffffff8138d413>] bus_for_each_dev+0x63/0xa0
> >     [<ffffffff8138ee5e>] driver_attach+0x1e/0x20
> >     [<ffffffff8138ea40>] bus_add_driver+0x180/0x250
> >     [<ffffffff8138fe74>] driver_register+0x64/0xf0
> >     [<ffffffff813913ba>] __platform_driver_register+0x4a/0x50
> >     [<ffffffff8191e028>] efifb_driver_init+0x12/0x14
> >     [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
> >     [<ffffffff818e40e0>] kernel_init_freeable+0x17b/0x201
> > 
> > In pm_vt_switch_required(), "entry" variable is allocated via kmalloc().
> > So, in pm_vt_switch_unregister(), it needs to call kfree() when object
> > is deleted from list.
> > 
> > Signed-off-by: Masami Ichikawa <masami256@gmail.com>
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Applied and queued up for the next PM pull request.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
