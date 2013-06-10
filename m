Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3FJLt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:49:57 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:45728 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab3FJLtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:49:55 -0400
Message-ID: <51B5BCB3.3060405@st.com>
Date: Mon, 10 Jun 2013 12:46:59 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v2 06/11] ARM:stixxxx: Add STiH415 SOC support
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856381-6644-1-git-send-email-srinivas.kandagatla@st.com> <CAHTX3d+dk3W_9b7SVUokWq4KYXnj=Z1=WPj5zJ-gUvJqqwE=+Q@mail.gmail.com>
In-Reply-To: <CAHTX3d+dk3W_9b7SVUokWq4KYXnj=Z1=WPj5zJ-gUvJqqwE=+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/13 12:15, Michal Simek wrote:

Thankyou for your comments,
> Hi,
> 
> hmm - that's a nice bug that thunderbird is not able to send this email. :-(
> Let's comment it again via gmail.
>     diff --git a/arch/arm/boot/dts/stih415.dtsi
>     b/arch/arm/boot/dts/stih415.dtsi
>     new file mode 100644
>     index 0000000..6dcf5b4
>     --- /dev/null
>     +++ b/arch/arm/boot/dts/stih415.dtsi
...
>     +
>     +       soc {
>     +               #address-cells = <1>;
>     +               #size-cells = <1>;
>     +               interrupt-parent = <&intc>;
>     +               ranges;
>     +               compatible      = "simple-bus";
> 
> 
> 
> Rob and Grant: what's the purpose of SoC node.
> It seems to me odd that SoC is compatible with simple-bus.

All the drivers on this SOC are based on platform bus, so we use
simple-bus, here.

>     diff --git a/arch/arm/boot/dts/stih41x.dtsi
>     b/arch/arm/boot/dts/stih41x.dtsi
>     new file mode 100644
>     index 0000000..7321403
>     --- /dev/null
>     +++ b/arch/arm/boot/dts/stih41x.dtsi
>     @@ -0,0 +1,38 @@
>     +/ {
>     +       #address-cells = <1>;
>     +       #size-cells = <1>;
>     +
>     +       cpus {
>     +               #address-cells = <1>;
>     +               #size-cells = <0>;
>     +               cpu@0 {
>     +                       compatible = "arm,cortex-a9";
>     +                       reg = <0>;
>     +               };
>     +               cpu@1 {
>     +                       compatible = "arm,cortex-a9";
>     +                       reg = <1>;
>     +               };
>     +       };
>     +
> 
> 
> I believe your SoC also has a bus here.

It does but there is no active driver to manage it.

>     --- /dev/null
>     +++ b/arch/arm/mach-stixxxx/board-dt.c
>     @@ -0,0 +1,47 @@

>     +
>     +void __init stih41x_l2x0_init(void)
>     +{
>     +       u32 way_size = 0x4;
>     +       u32 aux_ctrl;
>     +
>     +       aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
>     +               (0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
>     +               (0x1 << L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT) |
>     +               (way_size << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
> 
> 
> 
> #include <linux/bitops.h>
> Linus Walleij would write use  BIT() here

I will use BIT() macro.

>     diff --git a/arch/arm/mach-stixxxx/headsmp.S
>     b/arch/arm/mach-stixxxx/headsmp.S
>     new file mode 100644
>     index 0000000..3dd5c04
>     --- /dev/null
>     +++ b/arch/arm/mach-stixxxx/headsmp.S
>     @@ -0,0 +1,44 @@
>     +/*
>     + *  arch/arm/plat-stixxxx/headsmp.S
> 

>     +       .long   pen_release
> 
> 
> check that your SoC has no option to start/reset cpus separately.
> If yes, then you shouldn't use pen_release.
> We discussed this with Russel some days ago.
No, stih41x series can't reset the cores separately.
>  
> 
>     diff --git a/arch/arm/mach-stixxxx/platsmp.c
>     b/arch/arm/mach-stixxxx/platsmp.c
>     new file mode 100644
>     index 0000000..ffc40c0
>     --- /dev/null
>     +++ b/arch/arm/mach-stixxxx/platsmp.c
>     @@ -0,0 +1,117 @@
>     +/*
>     + *  arch/arm/plat-stixxxx/platsmp.c
> 
> 
> wrong.

Left over, will clean it up in next version.

>     + *  arch/arm/plat-stixxxx/platsmp.c
> 
> 
> incorrect.
Left over, will clean it up in next version.
>  
>     +extern struct smp_operations   stixxxx_smp_ops;
>     +extern void __iomem *stixxxx_scu_base_addr;
> 
> 
> Unused variable in this patch.
yes, I will remove stixxxx_scu_base_addr.

thanks,
srini


