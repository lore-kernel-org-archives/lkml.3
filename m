Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaJ2TCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:02:52 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50049 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbaJ2TCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:02:49 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: disable unused clocks
Date: Wed, 29 Oct 2014 20:05:49 +0100
Message-ID: <3943503.LSOI2HCfVt@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
References: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart12981156.RrJpkYRpVC"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart12981156.RrJpkYRpVC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Kever,

Am Mittwoch, 29. Oktober 2014, 18:06:07 schrieb Kever Yang:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

I did test it on all three socs I have and two issues popped up.

the easy issue:
- aclk_strc_sys in common_clk_branches
- aclk_core in rk3188_clk_branches
need to also stay on in clk-rk3188.c


the hard issue:
With this patch applied and the above fixed, both the Radxa Rock (rk3188) and 
Hayou Marsboard (rk3066a) produce imprecise external aborts when entering 
userspace.

I guess there is still a clock in there that should stay on. I've attached 
logs that highlight the clocks that get disabled in the late_initcall. [error 
happens with and without these extra messages].


I'll investigate further, but if you have an idea which of the clocks might be 
responsible I would be very glad :-)


thanks
Heiko

--nextPart12981156.RrJpkYRpVC
Content-Disposition: attachment; filename="screenlog.0.fail-rk3066a"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="screenlog.0.fail-rk3066a"

[...]
TCP: cubic registered
NET: Registered protocol family 17
Registering SWP/SWPB emulation handler
sdmmc-supply: 3000 mV 
sdmmc-supply: supplied by vcc_io
input: gpio-keys as /devices/gpio-keys/input/input0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
tps65910-rtc tps65910-rtc: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
sdmmc-supply: disabling
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: sclk_tsadc to 0
clk_gate_endisable: spdif_pre to 0
clk_gate_endisable: i2s2_frac to 0
clk_gate_endisable: i2s2_pre to 0
clk_gate_endisable: i2s1_frac to 0
clk_gate_endisable: i2s1_pre to 0
clk_gate_endisable: i2s0_frac to 0
clk_gate_endisable: i2s0_pre to 0
clk_gate_endisable: aclk_gpu to 0
clk_gate_endisable: aclk_gpu_src to 0
clk_gate_endisable: aclk_smc to 0
clk_gate_endisable: hclk_usbotg1 to 0
clk_gate_endisable: hclk_emmc to 0
clk_gate_endisable: hclk_sdio to 0
clk_gate_endisable: hclk_sdmmc to 0
clk_gate_endisable: hclk_pidfilter to 0
clk_gate_endisable: hclk_hsadc to 0
clk_gate_endisable: hclk_usbotg0 to 0
clk_gate_endisable: hclk_usb_peri to 0
clk_gate_endisable: hclk_nandc0 to 0
clk_gate_endisable: hclk_emac to 0
clk_gate_endisable: hclk_emem_peri to 0
clk_gate_endisable: hclk_peri_ahb_arbi to 0
clk_gate_endisable: hclk_peri_axi_matrix to 0
clk_gate_endisable: sclk_emmc to 0
clk_gate_endisable: sclk_sdio to 0
clk_gate_endisable: sclk_sdmmc to 0
clk_gate_endisable: pclk_tsadc to 0
clk_gate_endisable: pclk_saradc to 0
clk_gate_endisable: pclk_i2c4 to 0
clk_gate_endisable: pclk_i2c3 to 0
clk_gate_endisable: pclk_i2c2 to 0
clk_gate_endisable: pclk_spi1 to 0
clk_gate_endisable: pclk_spi0 to 0
clk_gate_endisable: pclk_wdt to 0
clk_gate_endisable: pclk_pwm23 to 0
clk_gate_endisable: sclk_spi1 to 0
clk_gate_endisable: sclk_spi0 to 0
clk_gate_endisable: mac_src to 0
clk_gate_endisable: hsadc_frac to 0
clk_gate_endisable: hsadc_src to 0
clk_gate_endisable: uart3_frac to 0
clk_gate_endisable: uart3_pre to 0
clk_gate_endisable: uart2_frac to 0
clk_gate_endisable: uart2_pre to 0
clk_gate_endisable: uart1_frac to 0
clk_gate_endisable: uart1_pre to 0
clk_gate_endisable: uart0_frac to 0
clk_gate_endisable: uart0_pre to 0
clk_gate_endisable: dclk_lcdc1_src to 0
clk_gate_endisable: dclk_lcdc0_src to 0
clk_gate_endisable: hclk_vepu to 0
clk_gate_endisable: aclk_vepu to 0
clk_gate_endisable: hclk_vdpu to 0
clk_gate_endisable: aclk_vdpu to 0
clk_gate_endisable: aclk_ipp to 0
clk_gate_endisable: aclk_cif0 to 0
clk_gate_endisable: aclk_lcdc0 to 0
clk_gate_endisable: aclk_vio0 to 0
clk_gate_endisable: aclk_cif1 to 0
clk_gate_endisable: aclk_rga to 0
clk_gate_endisable: aclk_lcdc1 to 0
clk_gate_endisable: aclk_vio1 to 0
clk_gate_endisable: aclk_lcdc1_pre to 0
clk_gate_endisable: cif1_pre to 0
clk_gate_endisable: cif0_pre to 0
clk_gate_endisable: core_dbg to 0
clk_gate_endisable: hclk_ahb2apb to 0
clk_gate_endisable: hclk_hdmi to 0
clk_gate_endisable: hclk_cif1 to 0
clk_gate_endisable: hclk_i2s2 to 0
clk_gate_endisable: hclk_i2s1 to 0
clk_gate_endisable: hclk_rga to 0
clk_gate_endisable: hclk_ipp to 0
clk_gate_endisable: hclk_cif0 to 0
clk_gate_endisable: hclk_lcdc0 to 0
clk_gate_endisable: hclk_vio_bus to 0
clk_gate_endisable: hclk_cpubus to 0
clk_gate_endisable: hclk_spdif to 0
clk_gate_endisable: hclk_i2s0 to 0
clk_gate_endisable: hclk_rom to 0
clk_gate_endisable: trace to 0
clk_gate_endisable: atclk to 0
clk_gate_endisable: atclk_cpu to 0
clk_gate_endisable: pclk_timer1 to 0
clk_gate_endisable: pclk_dbg to 0
clk_gate_endisable: pclk_ddrpubl to 0
clk_gate_endisable: pclk_ddrupctl to 0
clk_gate_endisable: pclk_tzpc to 0
clk_gate_endisable: pclk_efuse to 0
clk_gate_endisable: pclk_i2c0 to 0
clk_gate_endisable: pclk_pwm01 to 0
clk_gate_endisable: hclk_lcdc1 to 0
clk_gate_endisable: timer1 to 0
clk_gate_endisable: sclk_saradc to 0
clk_gate_endisable: spdif_frac to 0
clk_gate_endisable: pclkin_cif1 to 0
clk_gate_endisable: jtag to 0
clk_gate_endisable: pclkin_cif0 to 0
Freeing unused kernel memory: 2072K (c055a000 - c0760000)
Unhandled fault: imprecise external abort (0x1406) at 0x0011b9c3
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007

CPU: 0 PID: 1 Comm: init Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:ee859b40 r5:00000000 r4:c0773e74 r3:00400704
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c040cf34>] (panic+0x90/0x1ec)
 r5:c076e4d8 r4:ee859b40
[<c040cea8>] (panic) from [<c0022bf4>] (do_exit+0x454/0x88c)
 r3:ee83bdc0 r2:ee859b40 r1:00000007 r0:c04d6112
 r7:ee85a000
[<c00227a0>] (do_exit) from [<c002316c>] (do_group_exit+0x54/0xcc)
 r7:ee83aac0
[<c0023118>] (do_group_exit) from [<c002be6c>] (get_signal+0x4b8/0x528)
 r7:ee83aac0 r6:ee85bed0 r5:00000007 r4:ee85a000
[<c002b9b4>] (get_signal) from [<c040cb5c>] (do_signal+0x8c/0x358)
 r10:00000000 r9:ee85a000 r8:00000000 r7:00000000 r6:00000000 r5:ee85bfb0
 r4:ee85bfb0
[<c040cad0>] (do_signal) from [<c0011524>] (do_work_pending+0x50/0xc8)
 r10:00000000 r8:00000000 r7:10c5387d r6:00000000 r5:ee85bfb0 r4:0000f210
[<c00114d4>] (do_work_pending) from [<c000ece0>] (work_pending+0xc/0x20)
 r6:ffffffff r5:00000030 r4:0000f210 r3:ee859b40
CPU1: stopping
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:c075eb94 r5:00000000 r4:c0773e74 r3:00200040
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c0013b3c>] (handle_IPI+0xd4/0x16c)
 r5:c0793c18 r4:00000001
[<c0013a68>] (handle_IPI) from [<c0008658>] (gic_handle_irq+0x60/0x68)
 r6:c0769174 r5:ee879f70 r4:f0002100 r3:00000005
[<c00085f8>] (gic_handle_irq) from [<c0012640>] (__irq_svc+0x40/0x54)
Exception stack(0xee879f70 to 0xee879fb8)
9f60:                                     ffffffed 00000000 00000000 c001ce40
9f80: ee878000 00000000 00000000 ffffffed 00000000 413fc090 00000000 ee879fc4
9fa0: ee879fc8 ee879fb8 c000f888 c000f88c 60000113 ffffffff
 r6:ffffffff r5:60000113 r4:c000f88c r3:c000f888
[<c000f858>] (arch_cpu_idle) from [<c004ac0c>] (cpu_startup_entry+0xb8/0x204)
[<c004ab54>] (cpu_startup_entry) from [<c001382c>] (secondary_start_kernel+0x128/0x148)
 r7:c0793c44 r3:00000085
[<c0013704>] (secondary_start_kernel) from [<600086e4>] (0x600086e4)
 r4:8e86006a r3:c00086cc
---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007


--nextPart12981156.RrJpkYRpVC
Content-Disposition: attachment; filename="screenlog.0.fail-rk3188"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="screenlog.0.fail-rk3188"

[...]
TCP: cubic registered
NET: Registered protocol family 17
Registering SWP/SWPB emulation handler
sdmmc-supply: 3300 mV 
sdmmc-supply: supplied by VCC_IO
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
clk_gate_endisable: hclk_emac to 1
rockchip_emac 10204000.ethernet: ARC EMAC detected with id: 0x7fd02
rockchip_emac 10204000.ethernet: IRQ is 51
rockchip_emac 10204000.ethernet: MAC address is now 36:8c:46:23:5a:e1
libphy: Synopsys MII Bus: probed
rockchip_emac 10204000.ethernet: connected to SMSC LAN8710/LAN8720 phy with id 0x7c0f1
input: gpio-keys as /devices/gpio-keys/input/input0
rtc-hym8563 1-0051: no valid clock/calendar values available
rtc-hym8563 1-0051: hctosys: unable to read the hardware clock
sdmmc-supply: disabling
clk_gate_endisable: timer6 to 0
clk_gate_endisable: timer5 to 0
clk_gate_endisable: timer4 to 0
clk_gate_endisable: timer3 to 0
clk_gate_endisable: timer2 to 0
clk_gate_endisable: hclk_imem1 to 0
clk_gate_endisable: hclk_imem0 to 0
clk_gate_endisable: hclk_rga to 0
clk_gate_endisable: hclk_ipp to 0
clk_gate_endisable: hclk_cif0 to 0
clk_gate_endisable: hclk_lcdc0 to 0
clk_gate_endisable: hclk_vio_bus to 0
clk_gate_endisable: hclk_cpubus to 0
clk_gate_endisable: hclk_spdif to 0
clk_gate_endisable: hclk_i2s0 to 0
clk_gate_endisable: hclk_rom to 0
clk_gate_endisable: trace to 0
clk_gate_endisable: atclk to 0
clk_gate_endisable: atclk_cpu to 0
clk_gate_endisable: pclk_timer3 to 0
clk_gate_endisable: pclk_dbg to 0
clk_gate_endisable: pclk_ddrpubl to 0
clk_gate_endisable: pclk_ddrupctl to 0
clk_gate_endisable: pclk_tzpc to 0
clk_gate_endisable: pclk_efuse to 0
clk_gate_endisable: pclk_i2c0 to 0
clk_gate_endisable: pclk_timer0 to 0
clk_gate_endisable: pclk_pwm01 to 0
clk_gate_endisable: hclk_lcdc1 to 0
clk_gate_endisable: spdif_pre to 0
clk_gate_endisable: i2s0_frac to 0
clk_gate_endisable: i2s0_pre to 0
clk_gate_endisable: aclk_gps to 0
clk_gate_endisable: aclk_smc to 0
clk_gate_endisable: hclk_hsic to 0
clk_gate_endisable: hclk_usbotg1 to 0
clk_gate_endisable: hclk_emmc to 0
clk_gate_endisable: hclk_sdio to 0
clk_gate_endisable: hclk_sdmmc to 0
clk_gate_endisable: hclk_pidfilter to 0
clk_gate_endisable: hclk_hsadc to 0
clk_gate_endisable: hclk_usbotg0 to 0
clk_gate_endisable: hclk_usb_peri to 0
clk_gate_endisable: hclk_nandc0 to 0
clk_gate_endisable: hclk_emem_peri to 0
clk_gate_endisable: hclk_peri_ahb_arbi to 0
clk_gate_endisable: hclk_peri_axi_matrix to 0
clk_gate_endisable: sclk_emmc to 0
clk_gate_endisable: sclk_sdio to 0
clk_gate_endisable: sclk_sdmmc to 0
clk_gate_endisable: pclk_saradc to 0
clk_gate_endisable: pclk_i2c4 to 0
clk_gate_endisable: pclk_i2c3 to 0
clk_gate_endisable: pclk_i2c2 to 0
clk_gate_endisable: pclk_spi1 to 0
clk_gate_endisable: pclk_spi0 to 0
clk_gate_endisable: pclk_wdt to 0
clk_gate_endisable: pclk_pwm23 to 0
clk_gate_endisable: sclk_spi1 to 0
clk_gate_endisable: sclk_spi0 to 0
clk_gate_endisable: hsadc_frac to 0
clk_gate_endisable: hsadc_src to 0
clk_gate_endisable: uart3_frac to 0
clk_gate_endisable: uart3_pre to 0
clk_gate_endisable: uart2_frac to 0
clk_gate_endisable: uart2_pre to 0
clk_gate_endisable: uart1_frac to 0
clk_gate_endisable: uart1_pre to 0
clk_gate_endisable: uart0_frac to 0
clk_gate_endisable: uart0_pre to 0
clk_gate_endisable: aclk_gpu to 0
clk_gate_endisable: aclk_gpu_src to 0
clk_gate_endisable: dclk_lcdc1 to 0
clk_gate_endisable: dclk_lcdc0 to 0
clk_gate_endisable: hclk_vepu to 0
clk_gate_endisable: aclk_vepu to 0
clk_gate_endisable: hclk_vdpu to 0
clk_gate_endisable: aclk_vdpu to 0
clk_gate_endisable: aclk_ipp to 0
clk_gate_endisable: aclk_cif0 to 0
clk_gate_endisable: aclk_lcdc0 to 0
clk_gate_endisable: aclk_vio0 to 0
clk_gate_endisable: aclk_rga to 0
clk_gate_endisable: aclk_lcdc1 to 0
clk_gate_endisable: aclk_vio1 to 0
clk_gate_endisable: aclk_lcdc1_pre to 0
clk_gate_endisable: cif0_pre to 0
clk_gate_endisable: core_dbg to 0
clk_gate_endisable: timer1 to 0
clk_gate_endisable: timer0 to 0
clk_gate_endisable: sclk_saradc to 0
clk_gate_endisable: sclk_hsicphy_480m to 0
clk_gate_endisable: spdif_frac to 0
clk_gate_endisable: jtag to 0
clk_gate_endisable: pclkin_cif0 to 0
clk_gate_endisable: pclk_i2c1 to 1
clk_gate_endisable: pclk_i2c1 to 0
Freeing unused kernel memory: 2072K (c055a000 - c0760000)
Unhandled fault: imprecise external abort (0x1406) at 0x0011b9c3
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007

CPU: 1 PID: 1 Comm: init Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:ee057b40 r5:00000000 r4:c0773e74 r3:00400704
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c040cf34>] (panic+0x90/0x1ec)
 r5:c076e4d8 r4:ee057b40
[<c040cea8>] (panic) from [<c0022bf4>] (do_exit+0x454/0x88c)
 r3:ee039dc0 r2:ee057b40 r1:00000007 r0:c04d6112
 r7:ee058000
[<c00227a0>] (do_exit) from [<c002316c>] (do_group_exit+0x54/0xcc)
 r7:ee038ac0
[<c0023118>] (do_group_exit) from [<c002be6c>] (get_signal+0x4b8/0x528)
 r7:ee038ac0 r6:ee059ed0 r5:00000007 r4:ee058000
[<c002b9b4>] (get_signal) from [<c040cb5c>] (do_signal+0x8c/0x358)
 r10:00000000 r9:ee058000 r8:00000000 r7:00000000 r6:00000000 r5:ee059fb0
 r4:ee059fb0
[<c040cad0>] (do_signal) from [<c0011524>] (do_work_pending+0x50/0xc8)
 r10:00000000 r8:00000000 r7:10c5387d r6:00000000 r5:ee059fb0 r4:0000f210
[<c00114d4>] (do_work_pending) from [<c000ece0>] (work_pending+0xc/0x20)
 r6:ffffffff r5:00000030 r4:0000f210 r3:ee057b40
CPU3: stopping
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:c075eb94 r5:00000000 r4:c0773e74 r3:00200040
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c0013b3c>] (handle_IPI+0xd4/0x16c)
 r5:c0793c18 r4:00000003
[<c0013a68>] (handle_IPI) from [<c0008658>] (gic_handle_irq+0x60/0x68)
 r6:c0769174 r5:ee07bf70 r4:f0002100 r3:00000405
[<c00085f8>] (gic_handle_irq) from [<c0012640>] (__irq_svc+0x40/0x54)
Exception stack(0xee07bf70 to 0xee07bfb8)
bf60:                                     ffffffed 00000000 00000000 c001ce40
bf80: ee07a000 00000000 00000000 ffffffed 00000000 413fc090 00000000 ee07bfc4
bfa0: ee07bfc8 ee07bfb8 c000f888 c000f88c 60000113 ffffffff
 r6:ffffffff r5:60000113 r4:c000f88c r3:c000f888
[<c000f858>] (arch_cpu_idle) from [<c004ac0c>] (cpu_startup_entry+0xb8/0x204)
[<c004ab54>] (cpu_startup_entry) from [<c001382c>] (secondary_start_kernel+0x128/0x148)
 r7:c0793c44 r3:00000087
[<c0013704>] (secondary_start_kernel) from [<600086e4>] (0x600086e4)
 r4:8e05c06a r3:c00086cc
CPU0: stopping
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:c075eb94 r5:00000000 r4:c0773e74 r3:00200000
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c0013b3c>] (handle_IPI+0xd4/0x16c)
 r5:c0793c18 r4:00000000
[<c0013a68>] (handle_IPI) from [<c0008658>] (gic_handle_irq+0x60/0x68)
 r6:c0769174 r5:c0761f38 r4:f0002100 r3:00000405
[<c00085f8>] (gic_handle_irq) from [<c0012640>] (__irq_svc+0x40/0x54)
Exception stack(0xc0761f38 to 0xc0761f80)
1f20:                                                       ffffffed 00000000
1f40: 00000000 c001ce40 c0760000 00000000 00000000 ffffffed 00000000 413fc090
1f60: ef7fcc40 c0761f8c c0761f90 c0761f80 c000f888 c000f88c 60000113 ffffffff
 r6:ffffffff r5:60000113 r4:c000f88c r3:c000f888
[<c000f858>] (arch_cpu_idle) from [<c004ac0c>] (cpu_startup_entry+0xb8/0x204)
[<c004ab54>] (cpu_startup_entry) from [<c040bc4c>] (rest_init+0x68/0x80)
 r7:c05860f0 r3:00000000
[<c040bbe4>] (rest_init) from [<c055ac60>] (start_kernel+0x324/0x390)
[<c055a93c>] (start_kernel) from [<60008074>] (0x60008074)
CPU2: stopping
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.18.0-rc1+ #1305
Backtrace: 
[<c0011a14>] (dump_backtrace) from [<c0011ba8>] (show_stack+0x18/0x1c)
 r6:c075eb94 r5:00000000 r4:c0773e74 r3:00200040
[<c0011b90>] (show_stack) from [<c040e6a8>] (dump_stack+0x74/0x8c)
[<c040e634>] (dump_stack) from [<c0013b3c>] (handle_IPI+0xd4/0x16c)
 r5:c0793c18 r4:00000002
[<c0013a68>] (handle_IPI) from [<c0008658>] (gic_handle_irq+0x60/0x68)
 r6:c0769174 r5:ee079f70 r4:f0002100 r3:00000405
[<c00085f8>] (gic_handle_irq) from [<c0012640>] (__irq_svc+0x40/0x54)
Exception stack(0xee079f70 to 0xee079fb8)
9f60:                                     ffffffed 00000000 00000000 c001ce40
9f80: ee078000 00000000 00000000 ffffffed 00000000 413fc090 00000000 ee079fc4
9fa0: ee079fc8 ee079fb8 c000f888 c000f88c 60000113 ffffffff
 r6:ffffffff r5:60000113 r4:c000f88c r3:c000f888
[<c000f858>] (arch_cpu_idle) from [<c004ac0c>] (cpu_startup_entry+0xb8/0x204)
[<c004ab54>] (cpu_startup_entry) from [<c001382c>] (secondary_start_kernel+0x128/0x148)
 r7:c0793c44 r3:00000083
[<c0013704>] (secondary_start_kernel) from [<600086e4>] (0x600086e4)
 r4:8e05c06a r3:c00086cc
---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007


--nextPart12981156.RrJpkYRpVC--

