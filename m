Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaEOHYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:24:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60699 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaEOHYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:24:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: thierry.reding@gmail.com, michal.simek@xilinx.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
Date: Thu, 15 May 2014 09:23:59 +0200
Message-ID: <4262573.aEBTd7FzV5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5gPFHRrE84nz/Pj9262iLUC0GU7A9z4u2oUOdQYZzRx
 4UFcg36Kpf8cXZHa+h9wSG2UpEmApk1Ju7AQMJ8nZrOy/nohgB
 mwsS3j1S/ddnw328k1XQdUa8Hhcg0zimoDU2hUMFBhUiWTqxxC
 kura64MjHW4KWCMInvgBu2HoPgGrPFJ6asegoZsz4sph+8OhXA
 +gyp5WN+iF3xXcmOqp3AvXd5CmKwhUf18WPylFN7WzTyOiwfcY
 o/jSr/0nlt4NihBkaID9ckyYRk8TtX97IiXf+S1XiNEOm+vQaM
 MbonW31ChC5ep+e0nczFH1EJkrmb3ys38ChHgCWhoq5vWoqUdp
 qHm+GaRW8vEk5cY9OJPU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 13:26:13 Bart Tanghe wrote:
> @@ -0,0 +1,20 @@
> +Xilinx PWM controller
> +
> +Required properties:
> +- compatible: should be "xlnx,pwm-xlnx"
> +- add a clock source to the description
> +
> +Examples:
> +
> +               axi_timer_0: timer@42800000 {
> +                       clock-frequency = <100000000>;
> +                       clocks = <&clkc 15>;
> +                       compatible = "xlnx,xlnx-pwm";
> +                       reg = <0x42800000 0x10000>;
> +                       xlnx,count-width = <0x20>;
> +                       xlnx,gen0-assert = <0x1>;
> +                       xlnx,gen1-assert = <0x1>;
> +                       xlnx,one-timer-only = <0x0>;
> +                       xlnx,trig0-assert = <0x1>;
> +                       xlnx,trig1-assert = <0x1>;
> +               } ;
> 

It seems you are missing a mandatory "#pwm-cells" property.
How is anybody supposed to use this?

	Arnd
