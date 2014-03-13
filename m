Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaCMKnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:43:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40378 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbaCMKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:43:05 -0400
Date: Thu, 13 Mar 2014 11:43:03 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
 (BG2Q) device tree
Message-ID: <20140313104303.GB4418@piout.net>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
 <1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com>
 <532182EB.7090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532182EB.7090002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/2014 at 10:05:31 +0000, Sebastian Hesselbarth wrote :
> On 03/12/2014 11:06 AM, Antoine Ténart wrote:
> >+			compatible = "arm,cortex-a9-twd-timer";
> >+			reg = <0xad0600 0x20>;
> >+			clocks = <&sysclk>;
> 
> Playing with Chromecast, I remember local-timer running at sysclk/3 or
> something. I know berlin2/berlin2cd is wrong here. Can you check that
> for berlin2q local-timer also runs at sysclk/n?
> 

Actually, what we have is sysclk = cpuclk/3 so I guess it depends on
what you call sysclk.

> >+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> >+			status = "okay";
> >+		};
> >+
> >+		apb@e80000 {
> >+			compatible = "simple-bus";
> >+			#address-cells = <1>;
> >+			#size-cells = <1>;
> >+
> >+			ranges = <0 0xe80000 0x10000>;
> >+			interrupt-parent = <&aic>;
> >+
> >+			timer0: timer@2c00 {
> >+				compatible = "snps,dw-apb-timer";
> >+				reg = <0x2c00 0x14>;
> >+				interrupts = <8>;
> >+				clock-freq = <100000000>;
> >+				status = "okay";
> >+			};
> >+
> >+			timer1: timer@2c14 {
> >+				compatible = "snps,dw-apb-timer";
> >+				reg = <0x2c14 0x14>;
> >+				clock-freq = <100000000>;
> >+				status = "disabled";
> >+			};
> 
> berlin2/berlin2cd have a vast amount of 8 apb timers. Any timers missing
> here or did Marvell remove them?
> 
> 
> Also for uart, can you please double-check if there is no uart2?
> 

We don't have those informations, maybe Jisheng can help ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
