Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab3D2VQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759615Ab3D2VQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:16:14 -0400
Date: Mon, 29 Apr 2013 17:16:06 -0400
From: Dave Jones <davej@redhat.com>
To: jkosina@suse.cz
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: dummy irq trace 'Flags mismatch'
Message-ID: <20130429211605.GA4102@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, jkosina@suse.cz,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When set to built-in, the dummy irq driver causes this trace when I boot..

[    3.996055] genirq: Flags mismatch irq 0. 00000080 (dummy_irq) vs. 00015a20 (timer)
[    3.997055] Pid: 1, comm: swapper/0 Not tainted 3.9.0+ #29
[    3.997768] Call Trace:
[    3.998127]  [<ffffffff810f8635>] __setup_irq+0x515/0x550
[    3.998827]  [<ffffffff81f00e8c>] ? loop_init+0x150/0x150
[    3.999530]  [<ffffffff8146adf0>] ? transfer_xor+0x160/0x160
[    4.000259]  [<ffffffff810f8809>] request_threaded_irq+0xf9/0x1a0
[    4.001041]  [<ffffffff81f00e8c>] ? loop_init+0x150/0x150
[    4.001740]  [<ffffffff81f00eb8>] dummy_irq_init+0x2c/0x60
[    4.002450]  [<ffffffff810002e2>] do_one_initcall+0x122/0x170
[    4.003191]  [<ffffffff81ecef5c>] kernel_init_freeable+0x15b/0x1db
[    4.003978]  [<ffffffff81ece7da>] ? do_early_param+0x88/0x88
[    4.004710]  [<ffffffff816a87e0>] ? rest_init+0x140/0x140
[    4.005413]  [<ffffffff816a87ee>] kernel_init+0xe/0x180
[    4.006094]  [<ffffffff816ce91c>] ret_from_fork+0x7c/0xb0
[    4.006789]  [<ffffffff816a87e0>] ? rest_init+0x140/0x140
[    4.007561] dummy-irq: cannot register IRQ 0

