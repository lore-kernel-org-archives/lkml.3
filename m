Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657AbaFTF7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:59:31 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33314 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaFTF73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v67zkwvspdDr-rKv=5uT5mvP4e1ZyzHSSOXmvaiOxA+7OA@mail.gmail.com>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-18-git-send-email-wens@csie.org> <20140618122646.GS19730@lukather>
 <CAGb2v67zkwvspdDr-rKv=5uT5mvP4e1ZyzHSSOXmvaiOxA+7OA@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 20 Jun 2014 13:59:07 +0800
X-Google-Sender-Auth: dE0FYyON7GWynFn1lfgI6RkNF10
Message-ID: <CAGb2v65VMBLBf787UmUkmTqhXAZZxSqmFUMwDAWTFtSi7s0yqQ@mail.gmail.com>
Subject: Fwd: [linux-sunxi] Re: [PATCH v2 17/20] ARM: sunxi: Introduce
 Allwinner A23 support
To: "maxime.ripard" <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 8:26 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Jun 17, 2014 at 10:52:54PM +0800, Chen-Yu Tsai wrote:
>> The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
>> the IPs found in previous SoCs, notably the A31.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/mach-sunxi/Kconfig |  8 ++++++++
>>  arch/arm/mach-sunxi/sunxi.c | 10 ++++++++++
>>  2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
>> index 0fbd4f1..6434e3b 100644
>> --- a/arch/arm/mach-sunxi/Kconfig
>> +++ b/arch/arm/mach-sunxi/Kconfig
>> @@ -35,4 +35,12 @@ config MACH_SUN7I
>>       select HAVE_ARM_ARCH_TIMER
>>       select SUN5I_HSTIMER
>>
>> +config MACH_SUN8I
>> +     bool "Allwinner A23 (sun8i) SoCs support"
>> +     default ARCH_SUNXI
>> +     select ARCH_HAS_RESET_CONTROLLER
>> +     select ARM_GIC
>> +     select MFD_SUN6I_PRCM
>> +     select RESET_CONTROLLER
>> +
>>  endif
>> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
>> index 3f9587b..962ff30 100644
>> --- a/arch/arm/mach-sunxi/sunxi.c
>> +++ b/arch/arm/mach-sunxi/sunxi.c
>> @@ -53,3 +53,13 @@ static const char * const sun7i_board_dt_compat[] = {
>>  DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
>>       .dt_compat      = sun7i_board_dt_compat,
>>  MACHINE_END
>> +
>> +static const char * const sun8i_board_dt_compat[] = {
>> +     "allwinner,sun8i-a23",
>> +     NULL,
>> +};
>> +
>> +DT_MACHINE_START(SUN8I_DT, "Allwinner sun8i (A23) Family")
>> +     .init_time      = sun6i_timer_init,
>
> I haven't seen anything in your code that needed to use this
> function. Am I missing something?

(Adding Maxime back to recipients...)

My mistake. From the log I thought all timers needed the reset
controller. Turns out only the high speed timer does.

I'll remove the call in the next version.


ChenYu
