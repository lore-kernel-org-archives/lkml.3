Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3LMNd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:33:59 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:46849
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab3LMNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:33:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(z579eh37d5kz98dI1403R1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz17326ah8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 13 Dec 2013 21:34:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philippe De Muyter <phdm@macq.eu>
CC: <linux-kernel@vger.kernel.org>, <b29396@freescale.com>, <cjb@laptop.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: ARM,sdhci_esdhc_imx: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock
 order detected
Message-ID: <20131213133430.GW18380@S2101-09.ap.freescale.net>
References: <20131212144925.GA14995@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131212144925.GA14995@frolo.macqel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Thu, Dec 12, 2013 at 03:49:25PM +0100, Philippe De Muyter wrote:
> Hello,
> 
> I have just booted 3.13-rc3 on my i.MX6DL board, done nothing but watch
> it start, and I have got this!

There is a patch [1] from Fabio for this issue.

Shawn

[1] http://thread.gmane.org/gmane.linux.kernel.mmc/23786

> ======================================================
> [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> 3.13.0-rc3+ #4 Not tainted
> ------------------------------------------------------
> ALSA device list:
>   No soundcards found.
> kworker/u4:0/6 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>  (prepare_lock){+.+.+.}, at: [<804b55b4>] clk_prepare_lock+0x78/0xec
> 
> and this task is already holding:
>  (&(&host->lock)->rlock){-.-...}, at: [<804941c4>] sdhci_do_set_ios+0x20/0x728
> which would create a new lock dependency:
>  (&(&host->lock)->rlock){-.-...} -> (prepare_lock){+.+.+.}
> 
> but this new dependency connects a HARDIRQ-irq-safe lock:
>  (&(&host->lock)->rlock){-.-...}
> ... which became HARDIRQ-irq-safe at:
>   [<8005f640>] mark_lock+0x15c/0x6d8
>   [<8006069c>] __lock_acquire+0xae0/0x1cc8
>   [<80061d9c>] lock_acquire+0x68/0x7c
>   [<80650b64>] _raw_spin_lock+0x34/0x44
>   [<8049679c>] sdhci_irq+0x24/0xa30
>   [<8006b64c>] handle_irq_event_percpu+0x54/0x1a4
>   [<8006b7e0>] handle_irq_event+0x44/0x64
>   [<8006e928>] handle_fasteoi_irq+0xc4/0x15c
>   [<8006afb0>] generic_handle_irq+0x28/0x38
>   [<8000f1f4>] handle_IRQ+0x54/0xb4
>   [<80008644>] gic_handle_irq+0x30/0x64
>   [<80012f64>] __irq_svc+0x44/0x5c
>   [<806488c0>] printk+0x3c/0x44
>   [<80493e20>] sdhci_add_host+0x83c/0xbc0
>   [<80498bcc>] sdhci_esdhc_imx_probe+0x324/0x548
>   [<8035f480>] platform_drv_probe+0x20/0x50
>   [<8035d8ac>] driver_probe_device+0x118/0x22c
>   [<8035da5c>] __driver_attach+0x9c/0xa0
>   [<8035bfa0>] bus_for_each_dev+0x5c/0x90
>   [<8035d380>] driver_attach+0x20/0x28
>   [<8035cf80>] bus_add_driver+0xe0/0x1d8
>   [<8035e114>] driver_register+0x80/0xfc
>   [<8035edcc>] __platform_driver_register+0x50/0x64
>   [<808979c0>] sdhci_esdhc_imx_driver_init+0x18/0x20
>   [<800088b8>] do_one_initcall+0x40/0x170
>   [<80867c78>] kernel_init_freeable+0x104/0x1d4
>   [<80644934>] kernel_init+0x10/0x118
>   [<8000e988>] ret_from_fork+0x14/0x2c
> 
> to a HARDIRQ-irq-unsafe lock:
>  (prepare_lock){+.+.+.}
> ... which became HARDIRQ-irq-unsafe at:
> ...  [<8005f640>] mark_lock+0x15c/0x6d8
>   [<80062594>] mark_held_locks+0xa0/0x138
>   [<800626dc>] trace_hardirqs_on_caller+0xb0/0x1cc
>   [<8006280c>] trace_hardirqs_on+0x14/0x18
>   [<8064daa8>] mutex_trylock+0x180/0x20c
>   [<804b5550>] clk_prepare_lock+0x14/0xec
>   [<804b5d34>] clk_notifier_register+0x2c/0xf0
>   [<80015f84>] twd_clk_init+0x50/0x68
>   [<800088b8>] do_one_initcall+0x40/0x170
>   [<80867c78>] kernel_init_freeable+0x104/0x1d4
>   [<80644934>] kernel_init+0x10/0x118
>   [<8000e988>] ret_from_fork+0x14/0x2c
> 
> other info that might help us debug this:
> 
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(prepare_lock);
>                                local_irq_disable();
>                                lock(&(&host->lock)->rlock);
>                                lock(prepare_lock);
>   <Interrupt>
>     lock(&(&host->lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by kworker/u4:0/6:
>  #0:  (kmmcd){.+.+.+}, at: [<8003ded4>] process_one_work+0x130/0x444
>  #1:  ((&(&host->detect)->work)){+.+.+.}, at: [<8003ded4>] process_one_work+0x130/0x444
>  #2:  (&(&host->lock)->rlock){-.-...}, at: [<804941c4>] sdhci_do_set_ios+0x20/0x728
> 
> the dependencies between HARDIRQ-irq-safe lock and the holding lock:
> -> (&(&host->lock)->rlock){-.-...} ops: 410 {
>    IN-HARDIRQ-W at:
>                     [<8005f640>] mark_lock+0x15c/0x6d8
>                     [<8006069c>] __lock_acquire+0xae0/0x1cc8
>                     [<80061d9c>] lock_acquire+0x68/0x7c
>                     [<80650b64>] _raw_spin_lock+0x34/0x44
>                     [<8049679c>] sdhci_irq+0x24/0xa30
>                     [<8006b64c>] handle_irq_event_percpu+0x54/0x1a4
>                     [<8006b7e0>] handle_irq_event+0x44/0x64
>                     [<8006e928>] handle_fasteoi_irq+0xc4/0x15c
>                     [<8006afb0>] generic_handle_irq+0x28/0x38
>                     [<8000f1f4>] handle_IRQ+0x54/0xb4
>                     [<80008644>] gic_handle_irq+0x30/0x64
>                     [<80012f64>] __irq_svc+0x44/0x5c
>                     [<806488c0>] printk+0x3c/0x44
>                     [<80493e20>] sdhci_add_host+0x83c/0xbc0
>                     [<80498bcc>] sdhci_esdhc_imx_probe+0x324/0x548
>                     [<8035f480>] platform_drv_probe+0x20/0x50
>                     [<8035d8ac>] driver_probe_device+0x118/0x22c
>                     [<8035da5c>] __driver_attach+0x9c/0xa0
>                     [<8035bfa0>] bus_for_each_dev+0x5c/0x90
>                     [<8035d380>] driver_attach+0x20/0x28
>                     [<8035cf80>] bus_add_driver+0xe0/0x1d8
>                     [<8035e114>] driver_register+0x80/0xfc
>                     [<8035edcc>] __platform_driver_register+0x50/0x64
>                     [<808979c0>] sdhci_esdhc_imx_driver_init+0x18/0x20
>                     [<800088b8>] do_one_initcall+0x40/0x170
>                     [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                     [<80644934>] kernel_init+0x10/0x118
>                     [<8000e988>] ret_from_fork+0x14/0x2c
>    IN-SOFTIRQ-W at:
>                     [<8005f640>] mark_lock+0x15c/0x6d8
>                     [<800601b4>] __lock_acquire+0x5f8/0x1cc8
>                     [<80061d9c>] lock_acquire+0x68/0x7c
>                     [<80650c44>] _raw_spin_lock_irqsave+0x4c/0x60
>                     [<80492f54>] sdhci_tasklet_finish+0x1c/0x120
>                     [<8002bb24>] tasklet_action+0x90/0x14c
>                     [<8002c07c>] __do_softirq+0x100/0x254
>                     [<8002c5a4>] irq_exit+0xb0/0x108
>                     [<8000f1f8>] handle_IRQ+0x58/0xb4
>                     [<80008644>] gic_handle_irq+0x30/0x64
>                     [<80012f64>] __irq_svc+0x44/0x5c
>                     [<806488c0>] printk+0x3c/0x44
>                     [<80493e20>] sdhci_add_host+0x83c/0xbc0
>                     [<80498bcc>] sdhci_esdhc_imx_probe+0x324/0x548
>                     [<8035f480>] platform_drv_probe+0x20/0x50
>                     [<8035d8ac>] driver_probe_device+0x118/0x22c
>                     [<8035da5c>] __driver_attach+0x9c/0xa0
>                     [<8035bfa0>] bus_for_each_dev+0x5c/0x90
>                     [<8035d380>] driver_attach+0x20/0x28
>                     [<8035cf80>] bus_add_driver+0xe0/0x1d8
>                     [<8035e114>] driver_register+0x80/0xfc
>                     [<8035edcc>] __platform_driver_register+0x50/0x64
>                     [<808979c0>] sdhci_esdhc_imx_driver_init+0x18/0x20
>                     [<800088b8>] do_one_initcall+0x40/0x170
>                     [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                     [<80644934>] kernel_init+0x10/0x118
>                     [<8000e988>] ret_from_fork+0x14/0x2c
>    INITIAL USE at:
>                    [<8005f640>] mark_lock+0x15c/0x6d8
>                    [<8005fee0>] __lock_acquire+0x324/0x1cc8
>                    [<80061d9c>] lock_acquire+0x68/0x7c
>                    [<80650c44>] _raw_spin_lock_irqsave+0x4c/0x60
>                    [<804941c4>] sdhci_do_set_ios+0x20/0x728
>                    [<804948f4>] sdhci_set_ios+0x28/0x34
>                    [<80481680>] mmc_power_up+0x6c/0xd0
>                    [<804823d8>] mmc_start_host+0x40/0x70
>                    [<804833f0>] mmc_add_host+0x60/0x88
>                    [<80493dd4>] sdhci_add_host+0x7f0/0xbc0
>                    [<80498bcc>] sdhci_esdhc_imx_probe+0x324/0x548
>                    [<8035f480>] platform_drv_probe+0x20/0x50
>                    [<8035d8ac>] driver_probe_device+0x118/0x22c
>                    [<8035da5c>] __driver_attach+0x9c/0xa0
>                    [<8035bfa0>] bus_for_each_dev+0x5c/0x90
>                    [<8035d380>] driver_attach+0x20/0x28
>                    [<8035cf80>] bus_add_driver+0xe0/0x1d8
>                    [<8035e114>] driver_register+0x80/0xfc
>                    [<8035edcc>] __platform_driver_register+0x50/0x64
>                    [<808979c0>] sdhci_esdhc_imx_driver_init+0x18/0x20
>                    [<800088b8>] do_one_initcall+0x40/0x170
>                    [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                    [<80644934>] kernel_init+0x10/0x118
>                    [<8000e988>] ret_from_fork+0x14/0x2c
>  }
>  ... key      at: [<80e517cc>] __key.24069+0x0/0x8
>  ... acquired at:
>    [<8005f13c>] check_usage+0x3e8/0x5f4
>    [<8005f3a0>] check_irq_usage+0x58/0xb4
>    [<80060ce0>] __lock_acquire+0x1124/0x1cc8
>    [<80061d9c>] lock_acquire+0x68/0x7c
>    [<8064f57c>] mutex_lock_nested+0x5c/0x3b4
>    [<804b55b4>] clk_prepare_lock+0x78/0xec
>    [<804b5fc8>] clk_get_rate+0x14/0x64
>    [<80497c74>] esdhc_pltfm_set_clock+0x20/0x2a8
>    [<80492b60>] sdhci_set_clock+0x4c/0x424
>    [<804944b8>] sdhci_do_set_ios+0x314/0x728
>    [<804948f4>] sdhci_set_ios+0x28/0x34
>    [<80481560>] mmc_set_bus_mode+0x20/0x24
>    [<804858d4>] mmc_attach_mmc+0x140/0x1a0
>    [<80482348>] mmc_rescan+0x28c/0x2dc
>    [<8003df48>] process_one_work+0x1a4/0x444
>    [<8003ec7c>] worker_thread+0x120/0x3e4
>    [<8004539c>] kthread+0xcc/0xe8
>    [<8000e988>] ret_from_fork+0x14/0x2c
> 
> 
> the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
> -> (prepare_lock){+.+.+.} ops: 337 {
>    HARDIRQ-ON-W at:
>                     [<8005f640>] mark_lock+0x15c/0x6d8
>                     [<80062594>] mark_held_locks+0xa0/0x138
>                     [<800626dc>] trace_hardirqs_on_caller+0xb0/0x1cc
>                     [<8006280c>] trace_hardirqs_on+0x14/0x18
>                     [<8064daa8>] mutex_trylock+0x180/0x20c
>                     [<804b5550>] clk_prepare_lock+0x14/0xec
>                     [<804b5d34>] clk_notifier_register+0x2c/0xf0
>                     [<80015f84>] twd_clk_init+0x50/0x68
>                     [<800088b8>] do_one_initcall+0x40/0x170
>                     [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                     [<80644934>] kernel_init+0x10/0x118
>                     [<8000e988>] ret_from_fork+0x14/0x2c
>    SOFTIRQ-ON-W at:
>                     [<8005f640>] mark_lock+0x15c/0x6d8
>                     [<80062594>] mark_held_locks+0xa0/0x138
>                     [<80062720>] trace_hardirqs_on_caller+0xf4/0x1cc
>                     [<8006280c>] trace_hardirqs_on+0x14/0x18
>                     [<8064daa8>] mutex_trylock+0x180/0x20c
>                     [<804b5550>] clk_prepare_lock+0x14/0xec
>                     [<804b5d34>] clk_notifier_register+0x2c/0xf0
>                     [<80015f84>] twd_clk_init+0x50/0x68
>                     [<800088b8>] do_one_initcall+0x40/0x170
>                     [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                     [<80644934>] kernel_init+0x10/0x118
>                     [<8000e988>] ret_from_fork+0x14/0x2c
>    RECLAIM_FS-ON-W at:
>                        [<8005f640>] mark_lock+0x15c/0x6d8
>                        [<80062594>] mark_held_locks+0xa0/0x138
>                        [<80062dd8>] lockdep_trace_alloc+0x90/0x110
>                        [<800a8bf4>] __alloc_pages_nodemask+0x70/0x84c
>                        [<800d7558>] new_slab+0x6c/0x270
>                        [<80649880>] __slab_alloc.isra.71.constprop.73+0x3b8/0x504
>                        [<800d83d4>] kmem_cache_alloc+0x120/0x12c
>                        [<800f380c>] __d_alloc+0x24/0x180
>                        [<800f3b6c>] d_alloc+0x18/0x68
>                        [<800e652c>] lookup_dcache+0x8c/0xb0
>                        [<800e6570>] __lookup_hash+0x20/0x4c
>                        [<800eb344>] lookup_one_len+0xcc/0x120
>                        [<80256fc4>] __create_file+0x74/0x214
>                        [<80257238>] debugfs_create_file+0x30/0x38
>                        [<80257ffc>] debugfs_create_u32+0x44/0x54
>                        [<804b65d4>] clk_debug_create_subtree+0x98/0x11c
>                        [<804b6614>] clk_debug_create_subtree+0xd8/0x11c
>                        [<80898fb4>] clk_debug_init+0xac/0x13c
>                        [<800088b8>] do_one_initcall+0x40/0x170
>                        [<80867c78>] kernel_init_freeable+0x104/0x1d4
>                        [<80644934>] kernel_init+0x10/0x118
>                        [<8000e988>] ret_from_fork+0x14/0x2c
>    INITIAL USE at:
>                    [<8005f640>] mark_lock+0x15c/0x6d8
>                    [<8005fee0>] __lock_acquire+0x324/0x1cc8
>                    [<80061d9c>] lock_acquire+0x68/0x7c
>                    [<8064da38>] mutex_trylock+0x110/0x20c
>                    [<804b5550>] clk_prepare_lock+0x14/0xec
>                    [<804b7548>] __clk_init+0x20/0x458
>                    [<804b7a50>] _clk_register+0xd0/0x168
>                    [<804b7b98>] clk_register+0x3c/0x88
>                    [<804b857c>] clk_register_fixed_rate+0x88/0xd4
>                    [<804b8630>] of_fixed_clk_setup+0x68/0x90
>                    [<80899088>] of_clk_init+0x44/0x6c
>                    [<8086b2c8>] time_init+0x2c/0x38
>                    [<808679f0>] start_kernel+0x1dc/0x360
>                    [<10008074>] 0x10008074
>  }
>  ... key      at: [<808fd198>] prepare_lock+0x38/0x48
>  ... acquired at:
>    [<8005f170>] check_usage+0x41c/0x5f4
>    [<8005f3a0>] check_irq_usage+0x58/0xb4
>    [<80060ce0>] __lock_acquire+0x1124/0x1cc8
>    [<80061d9c>] lock_acquire+0x68/0x7c
>    [<8064f57c>] mutex_lock_nested+0x5c/0x3b4
>    [<804b55b4>] clk_prepare_lock+0x78/0xec
>    [<804b5fc8>] clk_get_rate+0x14/0x64
>    [<80497c74>] esdhc_pltfm_set_clock+0x20/0x2a8
>    [<80492b60>] sdhci_set_clock+0x4c/0x424
>    [<804944b8>] sdhci_do_set_ios+0x314/0x728
>    [<804948f4>] sdhci_set_ios+0x28/0x34
>    [<80481560>] mmc_set_bus_mode+0x20/0x24
>    [<804858d4>] mmc_attach_mmc+0x140/0x1a0
>    [<80482348>] mmc_rescan+0x28c/0x2dc
>    [<8003df48>] process_one_work+0x1a4/0x444
>    [<8003ec7c>] worker_thread+0x120/0x3e4
>    [<8004539c>] kthread+0xcc/0xe8
>    [<8000e988>] ret_from_fork+0x14/0x2c
> 
> 
> stack backtrace:
> CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.13.0-rc3+ #4
> Workqueue: kmmcd mmc_rescan
> Backtrace:
> [<80012218>] (dump_backtrace+0x0/0x10c) from [<800123b8>] (show_stack+0x18/0x1c)
>  r6:00000000 r5:809c53f0 r4:00000000 r3:bf872d00
> [<800123a0>] (show_stack+0x0/0x1c) from [<8064a720>] (dump_stack+0x78/0x94)
> [<8064a6a8>] (dump_stack+0x0/0x94) from [<8005f190>] (check_usage+0x43c/0x5f4)
>  r4:00000001 r3:bf872d00
> [<8005ed54>] (check_usage+0x0/0x5f4) from [<8005f3a0>] (check_irq_usage+0x58/0xb4)
> [<8005f348>] (check_irq_usage+0x0/0xb4) from [<80060ce0>] (__lock_acquire+0x1124/0x1cc8)
>  r8:bf8730e8 r7:809c53f0 r6:80e46a54 r5:bf8730d0 r4:00000003
> [<8005fbbc>] (__lock_acquire+0x0/0x1cc8) from [<80061d9c>] (lock_acquire+0x68/0x7c)
> [<80061d34>] (lock_acquire+0x0/0x7c) from [<8064f57c>] (mutex_lock_nested+0x5c/0x3b4)
>  r7:00000000 r6:80dfc7bc r5:804b55b4 r4:808fd160
> [<8064f520>] (mutex_lock_nested+0x0/0x3b4) from [<804b55b4>] (clk_prepare_lock+0x78/0xec)
> [<804b553c>] (clk_prepare_lock+0x0/0xec) from [<804b5fc8>] (clk_get_rate+0x14/0x64)
>  r6:bf020c40 r5:000186a0 r4:bf828380 r3:80497c54
> [<804b5fb4>] (clk_get_rate+0x0/0x64) from [<80497c74>] (esdhc_pltfm_set_clock+0x20/0x2a8)
>  r5:000186a0 r4:bf020c40
> [<80497c54>] (esdhc_pltfm_set_clock+0x0/0x2a8) from [<80492b60>] (sdhci_set_clock+0x4c/0x424)
> [<80492b14>] (sdhci_set_clock+0x0/0x424) from [<804944b8>] (sdhci_do_set_ios+0x314/0x728)
> [<804941a4>] (sdhci_do_set_ios+0x0/0x728) from [<804948f4>] (sdhci_set_ios+0x28/0x34)
> [<804948cc>] (sdhci_set_ios+0x0/0x34) from [<80481560>] (mmc_set_bus_mode+0x20/0x24)
>  r5:806947d0 r4:bf020800
> [<80481540>] (mmc_set_bus_mode+0x0/0x24) from [<804858d4>] (mmc_attach_mmc+0x140/0x1a0)
> [<80485794>] (mmc_attach_mmc+0x0/0x1a0) from [<80482348>] (mmc_rescan+0x28c/0x2dc)
>  r5:806947d0 r4:bf020af8
> [<804820bc>] (mmc_rescan+0x0/0x2dc) from [<8003df48>] (process_one_work+0x1a4/0x444)
>  r7:bf9bc100 r6:bf80dc00 r5:bf020af8 r4:bf82d880
> [<8003dda4>] (process_one_work+0x0/0x444) from [<8003ec7c>] (worker_thread+0x120/0x3e4)
> [<8003eb5c>] (worker_thread+0x0/0x3e4) from [<8004539c>] (kthread+0xcc/0xe8)
> [<800452d0>] (kthread+0x0/0xe8) from [<8000e988>] (ret_from_fork+0x14/0x2c)
>  r7:00000000 r6:00000000 r5:800452d0 r4:bf840580
> mmc2: BKOPS_EN bit is not set
> mmc2: new high speed MMC card at address 0001
> 
> -- 
> Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles

