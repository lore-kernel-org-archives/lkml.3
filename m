Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaAJCwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:52:13 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:46529 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAJCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:52:11 -0500
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 18:52:08 -0800
Message-ID: <CACUGKYMKe37F4VQVi9ZFL1ks+uCC8_ERN5O+y_MLV6G19uVjDw@mail.gmail.com>
Subject: BUG: bad unlock balance detected
From: John Tobias <john.tobias.ph@gmail.com>
To: "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        daniel.lezcano@linaro.org, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Any idea on these bug?.

Regards,

john


[ 559.972748] =====================================
[ 559.977457] [ BUG: bad unlock balance detected! ]
[ 559.982169] 3.13.0-rc1 #1 Tainted: G O
[ 559.986790] -------------------------------------
[ 559.991499] swapper/0 is trying to release lock (master_lock) at:
[ 559.997642] <8001d708> imx6q_enter_wait+0x80/0x8c
[ 560.002524] but there are no more locks to release!
[ 560.007404]
[ 560.007404] other info that might help us debug this:
[ 560.013939] no locks held by swapper/0.
[ 560.017779]
[ 560.017779] stack backtrace:
[ 560.022147] CPU: 0 PID: 0 Comm: swapper Tainted: G O 3.13.0-rc1 #1
[ 560.029200] Backtrace:
[ 560.031685] <80011fb4> (dump_backtrace+0x0/0x10c) from <80012150>
(show_stack+0x18/0x1c)
[ 560.040128] :806c00e8 :8001d708 :806bd1b0 :00000000
[ 560.045869] <80012138> (show_stack+0x0/0x1c) from <804eeef0>
(dump_stack+0x20/0x28)
[ 560.053889] <804eeed0> (dump_stack+0x0/0x28) from <8004b2a8>
(print_unlock_imbalance_bug+0xb4/0xe4)
[ 560.063296] <8004b1f4> (print_unlock_imbalance_bug+0x0/0xe4) from
<8004e338> (lock_release+0x184/0x1bc)
[ 560.073037] :80be210c :806bd1b0 :806b2000 :00000000
[ 560.078771] <8004e1b4> (lock_release+0x0/0x1bc) from <804f546c>
(_raw_spin_unlock+0x20/0x2c)
[ 560.087572] <804f544c> (_raw_spin_unlock+0x0/0x2c) from <8001d708>
(imx6q_enter_wait+0x80/0x8c)
[ 560.096620] :806f2f14 :806bd1b0
[ 560.100246] <8001d688> (imx6q_enter_wait+0x0/0x8c) from <80305d84>
(cpuidle_enter_state+0x44/0xfc)
[ 560.109554] :806dcae0 :00000082 :6128317f :8001d688
[ 560.115285] <80305d40> (cpuidle_enter_state+0x0/0xfc) from
<80305f28> (cpuidle_idle_call+0xec/0x15c)
[ 560.124767] :806b2000 :806dcae4 :806c00f8 :00000001 :80c37030
:806dcae0
[ 560.132701] <80305e3c> (cpuidle_idle_call+0x0/0x15c) from <8000fd08>
(arch_cpu_idle+0x10/0x44)
[ 560.141662] :00000001 :806e8d8a :806b2000 :806ba0dc :806b2000
:00000000
[ 560.149595] <8000fcf8> (arch_cpu_idle+0x0/0x44) from <80056be4>
(cpu_startup_entry+0x50/0x114)
[ 560.158568] <80056b94> (cpu_startup_entry+0x0/0x114) from <804ea1e0>
(rest_init+0xb4/0xdc)
[ 560.167181] :8181af00 :00000000
[ 560.170808] <804ea12c> (rest_init+0x0/0xdc) from <80684a98>
(start_kernel+0x2f0/0x348)
[ 560.179074] :ffffffff :806f2b80 :806ba158
[ 560.183750] <806847a8> (start_kernel+0x0/0x348) from <80008070> (0x80008070)
