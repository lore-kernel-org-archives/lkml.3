Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaK0PRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:17:47 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33931 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaK0PRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:17:41 -0500
MIME-Version: 1.0
Reply-To: cw00.choi@samsung.com
In-Reply-To: <2120788.f3P3CC6nYQ@wuerfel>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
	<2232281.fbydzq3GMs@wuerfel>
	<CAGTfZH3KmwhJNFdmeWnujbbUbtLf5vSi6i2dbV62DeCtV7n4TQ@mail.gmail.com>
	<2120788.f3P3CC6nYQ@wuerfel>
Date: Fri, 28 Nov 2014 00:17:40 +0900
Message-ID: <CAGTfZH1DdBGYKXv6VgWYfqfcyWVMm8MLux1U7sn_rX5h3-TGNQ@mail.gmail.com>
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 November 2014 22:41:49 Chanwoo Choi wrote:
>> 2014년 11월 27일 목요일, Arnd Bergmann<arnd@arndb.de>님이 작성한 메시지:
>>
>> > On Thursday 27 November 2014 21:58:53 Chanwoo Choi wrote:
>> > > Dear Arnd,
>> > >
>> > > On 11/27/2014 09:35 PM, Arnd Bergmann wrote:
>> > > > On Thursday 27 November 2014 13:12:08 Sylwester Nawrocki wrote:
>> > > >> On 27/11/14 12:56, Chanwoo Choi wrote:
>> > > >>> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
>> > > >>>>> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
>> > > >>>>>>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
>> > > >>>>>>> +    and "samsung,exynos5433-cmu-bus2" - clock controller
>> > compatible for CMU_BUS
>> > > >>>>>>> +    which generates global data buses clock and global
>> > peripheral buses clock.
>> > > >>>>>>>
>> > > >>>>>>>  - reg: physical base address of the controller and length of
>> > memory mapped
>> > > >>>>>>>    region.
>> > > >>>>>>>
>> > > >>>>>
>> > > >>>>> This looks like you are duplicating the bindings and the code, but
>> > > >>>>> it's really the same hardware multiple times with minor variations
>> > > >>>>> that you should be able to describe properly here. Why not make
>> > > >>>>> three nodes with the same compatible string and have them handled
>> > > >>>>> by the same code?
>> > > >>>
>> > > >>> Each CMU_BUSx domain of Exynos5433 have different base address as
>> > following:
>> > > >>> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
>> > > >>> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
>> > > >>> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
>> > > >>>
>> > > >>> So, I implement CMU_BUSx domain which has each compatible string.
>> > > >
>> > > > But the base address is in the reg property, not in the compatible
>> > > > property. What I mean is to have multiple nodes like
>> > >
>> > > The merged clock driver in mainline have different compatible string
>> > > if base addresss of clock domain is different. So, I implemented each
>> > CMU_BUSx domain
>> > > with different compatible string.
>> >
>> > Why?
>>
>>
>> As I explained on below, each clock domain have different clocks.
>> So, clocks have unique clock name.
>>
>>  If clock driver use only one compatible for various clock domain, clock
>> driver have to know the base address of each domain for distinction of
>> clock domain. I think It is stong dependency between device and driver.
>
> No, not at all. You can have lots of clock controllers with the same
> compatible string defining different instances of the same IP block,
> e.g. for compatible="fixed-clock".

But, "fixed-clock" pass all properties from dt file to
driver/clk/clk-fixed-rate.c.
and "fixed-clock" driver has not the data dependent on h/w. e.g.,
clock offset, parent clock.

>
>> >
>> > > >     clock-controller@113600000 {
>> > > >             reg = <0 0x113600000 0 0x1000>;
>> > > >             compatible = "samsung,exynos5433-cmu";
>> > > >             #clock-cells = <1>;
>> > > >     };
>> > > >
>> > > >     clock-controller@114800000 {
>> > > >             reg = <0 0x114800000 0 0x1000>;
>> > > >             compatible = "samsung,exynos5433-cmu";
>> > > >             #clock-cells = <1>;
>> > > >     };
>> > > >
>> > > > The code will just map the local registers for each instance and then
>> > > > provide the clocks of the right instance when asked for it.
>> > >
>> > > Each clock domain has not the same mux/divider/clock. So, just one
>> > compatible
>> > > string could not support all of clock domains.
>> >
>> > What are the specific differences?
>>
>>
>>
>> > I'm not sure that difference among clock domains because I think it is
>> dependent on the opinion of architect of SoC.
>>
>> cmu_bus0/1/2 are much similar. Just cmu_bus2 has one more mux/gate clock
>> than cmu_bus0/1.
>
> Yes, that's what I mean. You can simply model that extra mux/gate
> in the driver, as long as nothing ever tries to access the clock.

If only use one compatible to support CMU_BUSx domains,
I would implement it as following with Sylwester's guide.

To Sylwester, Tomaz,
Are you agree following method to support CMU_BUSx domains
by using one compatible string?

+/*
+ * Register offset definitions for CMU_BUS{0|1}
+ */
+#define DIV_BUS                0x0600
+#define DIV_STAT_BUS            0x0700
+#define ENABLE_ACLK_BUS            0x0800
+#define ENABLE_PCLK_BUS            0x0900
+#define ENABLE_IP_BUS0            0x0b00
+#define ENABLE_IP_BUS1            0x0b04
+
+#define bus_clk_regs(num)                \
+static unsigned long bus##num_clk_regs[] __initdata = {    \
+    DIV_BUS,                    \
+    DIV_STAT_BUS,                    \
+    ENABLE_ACLK_BUS,                \
+    ENABLE_PCLK_BUS,                \
+    ENABLE_IP_BUS0,                    \
+    ENABLE_IP_BUS1,                    \
+};                            \
+
+#define bus_div_clks(num)                        \
+static struct samsung_div_clock bus##num_div_clks[] __initdata = {    \
+    /* DIV_BUS */                            \
+    DIV(CLK_DIV_PCLK_BUS##num_133, "div_pclk_bus"#num"_133",    \
+            "aclk_bus"#num"_400", DIV_BUS##num, 0, 3),    \
+};                                    \
+
+#define bus_gate_clks(num)                        \
+static struct samsung_gate_clock bus##num_gate_clks[] __initdata = {    \
+    /* ENABLE_ACLK_BUS */                        \
+    GATE(CLK_ACLK_AHB2APB_BUS##num, "aclk_ahb2apb_bus"#num"p",    \
+            "div_pclk_bus"#num"_133", ENABLE_ACLK_BUS##num,    \
+            4, CLK_IGNORE_UNUSED, 0),            \
+    GATE(CLK_ACLK_BUS##numNP_133, "aclk_bus"#num"np_133",        \
+            "div_pclk_bus"##num"_133", ENABLE_ACLK_BUS##num,\
+            2, CLK_IGNORE_UNUSED, 0),            \
+    GATE(CLK_ACLK_BUS##numND_400, "aclk_bus"#num"nd_400",        \
+            "aclk_bus"#num"_400", ENABLE_ACLK_BUS##num,    \
+            0, CLK_IGNORE_UNUSED, 0),            \
+                                    \
+    /* ENABLE_PCLK_BUS */                        \
+    GATE(CLK_PCLK_BUS##numSRVND_133, "pclk_bus"#num"srvnd_133",    \
+            "div_pclk_bus"#num"_133", ENABLE_PCLK_BUS##num,    \
+            2, 0, 0),                    \
+    GATE(CLK_PCLK_PMU_BUS##num, "pclk_pmu_bus"#num,            \
+            "div_pclk_bus"#num"_133", ENABLE_PCLK_BUS##num,    \
+            1, CLK_IGNORE_UNUSED, 0),            \
+    GATE(CLK_PCLK_SYSREG_BUS##num, "pclk_sysreg_bus"#num,        \
+            "div_pclk_bus"#num"_133", ENABLE_PCLK_BUS##num,    \
+            0, 0, 0),                    \
+};                                    \
+
+#define bus_clk_regs(0)
+#define bus_div_clks(0)
+#define bus_gate_clks(0)
+
+#define bus_clk_regs(1)
+#define bus_div_clks(1)
+#define bus_gate_clks(1)
+
+static void __init exynos5433_cmu_bus_init(struct device_node *np)
+{
+    void __iomem *reg_base_bus0, *reg_base_bus1;
+
+    reg_base_bus0 = of_iomap(np, 0);
+    reg_base_bus1 = of_iomap(np, 1);
+
+    bus0_ctx = samsung_clk_init(np, reg_base_bus0, BUS0_NR_CLKS);
+    bus1_ctx = samsung_clk_init(np, reg_base_bus0, BUS0_NR_CLKS);
+
+    samsung_clk_register_div(bus0_ctx, bus0_div_clks,
+                    ARRAY_SIZE(bus0_div_clks));
+    samsung_clk_register_gate(bus0_ctx, bus0_gate_clks,
+                    ARRAY_SIZE(bus0_gate_clks));
+    samsung_clk_register_div(bus1_ctx, bus1_div_clks,
+                    ARRAY_SIZE(bus1_div_clks));
+    samsung_clk_register_gate(bus1_ctx, bus1_gate_clks,
+                    ARRAY_SIZE(bus1_gate_clks));
+
+    samsung_clk_of_provider(np, bus0_ctx);
+    samsung_clk_of_provider(np, bus1_ctx);
+
+}
+CLK_OF_DECLARE(exynos5433_cmu_bus, "samsung,exynos5433-cmu-bus",
+        exynos5433_cmu_bus_init);

Best Regards,
Chanwoo Choi
