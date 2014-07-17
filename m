Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaGQJLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:11:54 -0400
Received: from submit2.sa.ew.hu ([212.108.200.72]:56792 "EHLO submit2.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaGQJLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:11:51 -0400
Message-ID: <53C79351.2080406@denx.de>
Date: Thu, 17 Jul 2014 11:11:45 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org
CC: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: spi, spi_fsl-spi.c not working?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, NO_URI_FOUND 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __LINES_OF_YELLING 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I just tried a mpc83xx based board (similiar to the mpc8313erdb)
with linux v3.16-rc4 using the drivers/spi/spi-fsl-spi.c driver.
DT nodes for spi are the same as in arch/powerpc/boot/dts/mpc8313erdb.dts:

                 spi@7000 {
                         cell-index = <0>;
                         compatible = "fsl,spi";
                         reg = <0x7000 0x1000>;
                         interrupts = <16 0x8>;
                         interrupt-parent = <&ipic>;
                         mode = "cpu";
                 };

Bootlog shows:

[    1.341411] fsl_spi f0007000.spi: master is unqueued, this is deprecated
[    1.554405] ------------[ cut here ]------------
[    1.559080] WARNING: at c023a958 [verbose debug info unavailable]
[    1.565208] Modules linked in:
[    1.568305] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc4-ids720-patch1-01642-g69ef753 #20
[    1.577059] task: c782c000 ti: c781a000 task.ti: c781a000
[    1.582493] NIP: c023a958 LR: c0238bfc CTR: c027884c
[    1.587491] REGS: c781bb80 TRAP: 0700   Not tainted  (3.16.0-rc4-ids720-patch1-01642-g69ef753)
[    1.596149] MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 22002044  XER: 00000000
[    1.602851]
GPR00: c0238bfc c781bc30 c782c000 c051421c c6c62a00 c6c62b06 c03e392c 00000002
GPR08: c03de53c 00000001 c6c62ab8 00001032 82002042 00000000 c0004158 00000000
GPR16: 00000000 00000000 00000000 00000000 c0495c54 c0495cbc c0495cc8 c0495cd4
GPR24: 00000000 00000000 00000000 c050c6a4 c051421c c0544aa8 c0540000 c6c62a00
[    1.632952] NIP [c023a958] driver_probe_device+0x58/0x230
[    1.638397] LR [c0238bfc] bus_for_each_drv+0x50/0xac
[    1.643390] Call Trace:
[    1.645865] [c781bc30] [c023abf0] __device_attach+0x0/0x70 (unreliable)
[    1.652539] [c781bc50] [c0238bfc] bus_for_each_drv+0x50/0xac
[    1.658247] [c781bc80] [c023a8bc] device_attach+0xb4/0xd8
[    1.663693] [c781bca0] [c0239dd4] bus_probe_device+0xa0/0xc4
[    1.669400] [c781bcc0] [c0237d68] device_add+0x384/0x520
[    1.674762] [c781bd00] [c0279298] spi_add_device+0xb0/0x170
[    1.680383] [c781bd20] [c027aac4] spi_register_master+0x500/0x75c
[    1.686530] [c781bd70] [c027e138] of_fsl_spi_probe+0x494/0x594
[    1.692413] [c781bdd0] [c023c1ac] platform_drv_probe+0x28/0x68
[    1.698297] [c781bde0] [c023a98c] driver_probe_device+0x8c/0x230
[    1.704353] [c781be00] [c023abec] __driver_attach+0xbc/0xc0
[    1.709972] [c781be20] [c0238cb4] bus_for_each_dev+0x5c/0xa8
[    1.715681] [c781be50] [c023a038] bus_add_driver+0xf4/0x1e4
[    1.721300] [c781be70] [c023b394] driver_register+0x88/0x130
[    1.727013] [c781be80] [c0003ad0] do_one_initcall+0x8c/0x210
[    1.732732] [c781bef0] [c04d30ac] kernel_init_freeable+0x114/0x1c0
[    1.738962] [c781bf30] [c0004170] kernel_init+0x18/0x108
[    1.744331] [c781bf40] [c000e830] ret_from_kernel_thread+0x5c/0x64
[    1.750549] Instruction dump:

Did someone detected such a problem with this driver?

Is it maybe the missing "support for the SPI subsystem's queue SPI messages"?

Any hints?

Thanks!

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
