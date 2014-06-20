Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaFTEmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:42:49 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55590 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaFTEmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:42:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140619215557.875556819@linutronix.de>
References: <20140619215347.139324048@linutronix.de>
	<20140619215557.875556819@linutronix.de>
Date: Fri, 20 Jun 2014 10:12:46 +0530
X-Google-Sender-Auth: o4o28vGBgemHhJOpSN7p00sleEg
Message-ID: <CAOh2x==eh=k-LWK89QY_B0f9e7ctZE035NQm_vumayBYf3Mtnw@mail.gmail.com>
Subject: Re: [patch 2/2] dts: spear: Add missing i2c1 interrupt
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:26 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/boot/dts/spear320.dtsi |    5 +++++
>  1 file changed, 5 insertions(+)
>
> Index: linux/arch/arm/boot/dts/spear320.dtsi
> ===================================================================
> --- linux.orig/arch/arm/boot/dts/spear320.dtsi
> +++ linux/arch/arm/boot/dts/spear320.dtsi
> @@ -123,6 +123,11 @@
>                                 status = "disabled";
>                         };
>
> +                       i2c1: i2c@a7000000 {
> +                               interrupts = <21>;
> +                               interrupt-parent = <&shirq>;
> +                       };

Isn't this already available ?

                        i2c1: i2c@a7000000 {
                                #address-cells = <1>;
                                #size-cells = <0>;
                                compatible = "snps,designware-i2c";
                                reg = <0xa7000000 0x1000>;
                                interrupts = <21>;
                                interrupt-parent = <&shirq>;
                                status = "disabled";
                        };
