Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaLCNza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:55:30 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:44559 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaLCNz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:55:27 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <b24fa471ae56c6a7aeb0adbe48b46484>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547F1639.3030102@rock-chips.com>
Date: Wed, 03 Dec 2014 21:55:05 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>, Doug Anderson <dianders@chromium.org>
CC: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the
 power of cpu and some external
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>	<7htx1f409k.fsf@deeprootsystems.com>	<CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>	<CAD=FV=XuQk17CTNKJY++J+w9Ab9_OUX0ca0A99m7yKPAWSs2=w@mail.gmail.com> <7hmw763kql.fsf@deeprootsystems.com>
In-Reply-To: <7hmw763kql.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/02/2014 09:26 AM, Kevin Hilman wrote:
> Doug Anderson <dianders@chromium.org> writes:
>
>> Hi,
>>
>> On Mon, Dec 1, 2014 at 2:08 PM, Doug Anderson <dianders@chromium.org> wrote:
>>> Hi,
>>>
>>> On Mon, Dec 1, 2014 at 11:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>>>> Chris Zhong <zyw@rock-chips.com> writes:
>>>>
>>>>> devices, since we still lack power_domain driver, so the other power rail
>>>>> of rk3288 need keep power on.
>>>>> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
>>>>> "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
>>>>> determined in sleep mode, then press power button to wakeup it.
>>>> I tested this on top of today's linux-next (next-20141201) and it
>>>> suspends, but doesn't wake up from any of the button presses.  What
>>>> wakeup sources are configured for the rk3288-evb-rk808?
>>> Just to close the loop (I talked with Kevin over IM about this, too):
>>>
>>> I have a huge description of how I tested this as part of my patch at
>>> <https://patchwork.kernel.org/patch/5414941/>.  Chris:  I think Kevin
>>> has asked you several times to include information like this in your
>>> cover letter.  Please, please, please can you try to remember to do
>>> this?
>> Talked to Chris offline.  He said that in his tests the other patches
>> weren't needed, so he didn't list any other patches.  Things just
>> worked for him.  ...so I guess he did post the instructions that
>> worked for him.  Sorry for the complaint.  Possibly things are
>> different on "next-20141112" and that's where Chris said he tested.
> This series doesn't apply cleanly to next-20141112.  Manually applying
> (with fuzz), it boots but I have the same results: it suspends, but none
> of the buttons wake it up.
>
> Kevin
>
Hi, Kevin

I have test these patches on evb board base on next-20141128 with a 
defconfig[0], and with u-boot[1].
As Doug said, we need below 3 patches for resume.

1.https://patchwork.kernel.org/patch/5051881/  - clocksource:
    arch_timer: Allow the device tree to specify uninitialized timer
    registers

2.https://patchwork.kernel.org/patch/5363671/  - clocksource:
    arch_timer: Fix code to use physical timers when requested

3.https://patchwork.kernel.org/patch/5382141/  - ARM: dts: rk3288: add
    arm,cpu-registers-not-fw-configured


And it will auto wakeup, as Heiko said in v8.  But I have never notice 
before, since the u-boot never enable edp,
and I use the coreboot with edp display.
Actually it is a bug in rk3288, the rk3288 have not 27Mhz clock source, 
but the edp initially set to this
non-existent clock. At this time, edp is working on a unknown state, and 
it always bring a interrupt, this
interrupt avoid system enter suspend. So if we want to enter suspend 
normally, the edp_24m_sel(bit 15) of
CRU_CLKSEL28_CON(0xff7600d0) must be set to 1.

[0] 
https://github.com/mmind/linux-rockchip/blob/devel/workbench/arch/arm/configs/rk3288_defconfig 

[1] https://githubremotes/origin/u-boot-rk3288

here is my local  work around:

diff --git a/arch//cpu/armv7/rk32xx/clock-rk3288.c 
b/arch/arm/cpu/armv7/rk32xx/clock-rk3288.c
index cfd0acd..3df0900 100755
--- a/arch/arm/cpu/armv7/rk32xx/clock-rk3288.c
+++ b/arch/arm/cpu/armv7/rk32xx/clock-rk3288.c
@@ -1233,7 +1233,6 @@ int rkclk_lcdc_clk_set(uint32 lcdc_id, uint32 dclk_hz)
         }
  }

-
  /*
   * rkplat set nandc clock div
   * nandc_id:   nandc id
@@ -1270,6 +1269,11 @@ int rkclk_set_nandc_div(uint32 nandc_id, uint32 
pllsrc, uint32 freq)
         return 0;
  }

+void rkclk_init_edp_source(void)
+{
+       cru_writel(1<<15 | 1<<31, CRU_CLKSELS_CON(28));
+}
+
  /*
   * rkplat set sd clock src
   * 0: codec pll; 1: general pll; 2: 24M
diff --git a/board/rockchip/rk32xx/rk32xx.c b/board/rockchip/rk32xx/rk32xx.c
index bfdcf0e..3e19f5d 100755
--- a/board/rockchip/rk32xx/rk32xx.c
+++ b/board/rockchip/rk32xx/rk32xx.c
@@ -114,7 +114,7 @@ void rk_backlight_ctrl(int brightness)

  void rk_fb_init(unsigned int onoff)
  {
-
+       rkclk_init_edp_source();
  #ifdef CONFIG_OF_LIBFDT
         if (lcd_node == 0) rk_lcd_parse_dt(gd->fdt_blob);











