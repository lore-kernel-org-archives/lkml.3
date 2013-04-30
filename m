Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3D3E72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:59:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3D3E7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:59:25 -0400
Date: Tue, 30 Apr 2013 06:59:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: dummy irq trace 'Flags mismatch'
In-Reply-To: <20130429211605.GA4102@redhat.com>
Message-ID: <alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz>
References: <20130429211605.GA4102@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Dave Jones wrote:

> When set to built-in, the dummy irq driver causes this trace when I boot..
> 
> [    3.996055] genirq: Flags mismatch irq 0. 00000080 (dummy_irq) vs. 00015a20 (timer)
> [    3.997055] Pid: 1, comm: swapper/0 Not tainted 3.9.0+ #29
> [    3.997768] Call Trace:
> [    3.998127]  [<ffffffff810f8635>] __setup_irq+0x515/0x550
> [    3.998827]  [<ffffffff81f00e8c>] ? loop_init+0x150/0x150
> [    3.999530]  [<ffffffff8146adf0>] ? transfer_xor+0x160/0x160
> [    4.000259]  [<ffffffff810f8809>] request_threaded_irq+0xf9/0x1a0
> [    4.001041]  [<ffffffff81f00e8c>] ? loop_init+0x150/0x150
> [    4.001740]  [<ffffffff81f00eb8>] dummy_irq_init+0x2c/0x60
> [    4.002450]  [<ffffffff810002e2>] do_one_initcall+0x122/0x170
> [    4.003191]  [<ffffffff81ecef5c>] kernel_init_freeable+0x15b/0x1db
> [    4.003978]  [<ffffffff81ece7da>] ? do_early_param+0x88/0x88
> [    4.004710]  [<ffffffff816a87e0>] ? rest_init+0x140/0x140
> [    4.005413]  [<ffffffff816a87ee>] kernel_init+0xe/0x180
> [    4.006094]  [<ffffffff816ce91c>] ret_from_fork+0x7c/0xb0
> [    4.006789]  [<ffffffff816a87e0>] ? rest_init+0x140/0x140
> [    4.007561] dummy-irq: cannot register IRQ 0

Thanks for the report, Dave. That's actually kind of expected -- when one 
of the handlers on the IRQ line that is being debugged doesn't share IRQs, 
this is exactly what you want to get by the dummy-irq debugging facility.

In this case you haven't specified any IRQ# to the dummy-irq driver via 
kernel commandline, i.e. IRQ# is 0, and timer is not sharing IRQs, 
therefore dummy-irq debugging facility did its job, and you know that the 
IRQ can't be shared.

Not really sure whether this is something to fix. We could make dummy-irq 
a module-only thing, but that might be counter-productive in cases you 
really want to debug very early problems.

Or have it depend on CONFIG_EXPERT would probably make most sense ... ?

Thanks,

-- 
Jiri Kosina
SUSE Labs
