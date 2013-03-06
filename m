Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3CFKdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:33:09 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:52869 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3CFKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:33:05 -0500
Message-ID: <51371B5E.1000508@free-electrons.com>
Date: Wed, 06 Mar 2013 11:33:02 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>
Subject: v3.9-rc1: swapper/0  [ INFO: possible circular locking dependency
 detected ]
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just noticed this in 3.9-rc1 on an iMX28 (ARM) board with a config
based on mxs_defconfig. I'm using the patchset "Add tested id switch
and vbus connect detect support for Chipidea" from Peter Chen in its
10th version [1], rebased on top of 3.9-rc1, but since this doesn't
modify the locks present in the udc_irq function, I think the problem
is elsewhere.

Please let me know if you have any questions,
Thanks,
Maxime

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/151837.html


[    1.893905] ======================================================
[    1.900097] [ INFO: possible circular locking dependency detected ]
[    1.906381] 3.9.0-rc1-00024-g39231ac #475 Not tainted
[    1.911441] -------------------------------------------------------
[    1.917716] swapper/0 is trying to acquire lock:
[    1.922341]  (&(&ci->lock)->rlock){-.....}, at: [<c02580fc>] ep_enable+0x20/0x25c
[    1.929935] 
[    1.929935] but task is already holding lock:
[    1.935782]  (&(&cdev->lock)->rlock){-.....}, at: [<c025e46c>] composite_setup+0x384/0xee8
[    1.944124] 
[    1.944124] which lock already depends on the new lock.
[    1.944124] 
[    1.952319] 
[    1.952319] the existing dependency chain (in reverse order) is:
[    1.959813] 
-> #1 (&(&cdev->lock)->rlock){-.....}:
[    1.964829]        [<c005adb0>] lock_acquire+0x98/0x104
[    1.970106]        [<c0375c28>] _raw_spin_lock_irqsave+0x3c/0x50
[    1.976152]        [<c025d960>] composite_disconnect+0x1c/0x5c
[    1.982016]        [<c02591c0>] udc_irq+0x6d8/0xbe8
[    1.986930]        [<c02571fc>] ci_irq+0x9c/0x108
[    1.991667]        [<c0067214>] handle_irq_event_percpu+0x5c/0x268
[    1.997896]        [<c006745c>] handle_irq_event+0x3c/0x5c
[    2.003417]        [<c00696c0>] handle_level_irq+0x8c/0xe8
[    2.008933]        [<c0066af4>] generic_handle_irq+0x20/0x30
[    2.014627]        [<c000fb8c>] handle_IRQ+0x30/0x84
[    2.019633]        [<c00086f0>] icoll_handle_irq+0x30/0x44
[    2.025148]        [<c000e8e4>] __irq_svc+0x44/0x54
[    2.030058]        [<c000fd58>] cpu_idle+0x60/0xec
[    2.034884]        [<c04e970c>] start_kernel+0x260/0x2a0
[    2.040237]        [<40008040>] 0x40008040
[    2.044364] 
-> #0 (&(&ci->lock)->rlock){-.....}:
[    2.049210]        [<c005a284>] __lock_acquire+0x14e8/0x1b18
[    2.054906]        [<c005adb0>] lock_acquire+0x98/0x104
[    2.060164]        [<c0375c28>] _raw_spin_lock_irqsave+0x3c/0x50
[    2.066202]        [<c02580fc>] ep_enable+0x20/0x25c
[    2.071207]        [<c02629d0>] gether_connect+0x34/0x1c0
[    2.076643]        [<c0262db0>] eem_set_alt+0x70/0xcc
[    2.081723]        [<c025eb54>] composite_setup+0xa6c/0xee8
[    2.087325]        [<c0259244>] udc_irq+0x75c/0xbe8
[    2.092237]        [<c02571fc>] ci_irq+0x9c/0x108
[    2.096973]        [<c0067214>] handle_irq_event_percpu+0x5c/0x268
[    2.103194]        [<c006745c>] handle_irq_event+0x3c/0x5c
[    2.108717]        [<c00696c0>] handle_level_irq+0x8c/0xe8
[    2.114234]        [<c0066af4>] generic_handle_irq+0x20/0x30
[    2.119926]        [<c000fb8c>] handle_IRQ+0x30/0x84
[    2.124929]        [<c00086f0>] icoll_handle_irq+0x30/0x44
[    2.130445]        [<c000e8e4>] __irq_svc+0x44/0x54
[    2.135353]        [<c000fd58>] cpu_idle+0x60/0xec
[    2.140176]        [<c04e970c>] start_kernel+0x260/0x2a0
[    2.145521]        [<40008040>] 0x40008040
[    2.149645] 
[    2.149645] other info that might help us debug this:
[    2.149645] 
[    2.157667]  Possible unsafe locking scenario:
[    2.157667] 
[    2.163598]        CPU0                    CPU1
[    2.168134]        ----                    ----
[    2.172667]   lock(&(&cdev->lock)->rlock);
[    2.176790]                                lock(&(&ci->lock)->rlock);
[    2.183255]                                lock(&(&cdev->lock)->rlock);
[    2.189893]   lock(&(&ci->lock)->rlock);
[    2.193842] 
[    2.193842]  *** DEADLOCK ***
[    2.193842] 
[    2.199782] 1 lock held by swapper/0:
[    2.203451]  #0:  (&(&cdev->lock)->rlock){-.....}, at: [<c025e46c>] composite_setup+0x384/0xee8
[    2.212231] 
[    2.212231] stack backtrace:
[    2.216663] [<c0014120>] (unwind_backtrace+0x0/0xf0) from [<c0370078>] (print_circular_bug+0x25c/0x2a8)
[    2.226112] [<c0370078>] (print_circular_bug+0x25c/0x2a8) from [<c005a284>] (__lock_acquire+0x14e8/0x1b18)
[    2.235813] [<c005a284>] (__lock_acquire+0x14e8/0x1b18) from [<c005adb0>] (lock_acquire+0x98/0x104)
[    2.244904] [<c005adb0>] (lock_acquire+0x98/0x104) from [<c0375c28>] (_raw_spin_lock_irqsave+0x3c/0x50)
[    2.254347] [<c0375c28>] (_raw_spin_lock_irqsave+0x3c/0x50) from [<c02580fc>] (ep_enable+0x20/0x25c)
[    2.263527] [<c02580fc>] (ep_enable+0x20/0x25c) from [<c02629d0>] (gether_connect+0x34/0x1c0)
[    2.272094] [<c02629d0>] (gether_connect+0x34/0x1c0) from [<c0262db0>] (eem_set_alt+0x70/0xcc)
[    2.280744] [<c0262db0>] (eem_set_alt+0x70/0xcc) from [<c025eb54>] (composite_setup+0xa6c/0xee8)
[    2.289572] [<c025eb54>] (composite_setup+0xa6c/0xee8) from [<c0259244>] (udc_irq+0x75c/0xbe8)
[    2.298226] [<c0259244>] (udc_irq+0x75c/0xbe8) from [<c02571fc>] (ci_irq+0x9c/0x108)
[    2.306026] [<c02571fc>] (ci_irq+0x9c/0x108) from [<c0067214>] (handle_irq_event_percpu+0x5c/0x268)
[    2.315119] [<c0067214>] (handle_irq_event_percpu+0x5c/0x268) from [<c006745c>] (handle_irq_event+0x3c/0x5c)
[    2.324986] [<c006745c>] (handle_irq_event+0x3c/0x5c) from [<c00696c0>] (handle_level_irq+0x8c/0xe8)
[    2.334159] [<c00696c0>] (handle_level_irq+0x8c/0xe8) from [<c0066af4>] (generic_handle_irq+0x20/0x30)
[    2.343516] [<c0066af4>] (generic_handle_irq+0x20/0x30) from [<c000fb8c>] (handle_IRQ+0x30/0x84)
[    2.352342] [<c000fb8c>] (handle_IRQ+0x30/0x84) from [<c00086f0>] (icoll_handle_irq+0x30/0x44)
[    2.360991] [<c00086f0>] (icoll_handle_irq+0x30/0x44) from [<c000e8e4>] (__irq_svc+0x44/0x54)
[    2.369531] Exception stack(0xc050df68 to 0xc050dfb0)
[    2.374612] df60:                   00000001 00000001 00000000 20000013 c050c000 c05476e8
[    2.382819] df80: c050c000 c050c000 c05476e8 41069265 40504270 00000000 600000d3 c050dfb0
[    2.391015] dfa0: c005b708 c000fd58 20000013 ffffffff
[    2.396110] [<c000e8e4>] (__irq_svc+0x44/0x54) from [<c000fd58>] (cpu_idle+0x60/0xec)
[    2.403990] [<c000fd58>] (cpu_idle+0x60/0xec) from [<c04e970c>] (start_kernel+0x260/0x2a0)
[    2.412291] [<c04e970c>] (start_kernel+0x260/0x2a0) from [<40008040>] (0x40008040)

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
