Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaCNIJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:09:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55678 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbaCNIJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:09:27 -0400
Message-ID: <5322B91B.4020401@ti.com>
Date: Fri, 14 Mar 2014 10:08:59 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>, Nishanth Menon <nm@ti.com>,
        Suman Anna <s-anna@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/5] ARM: dts: am33xx: Set parent clock for timer through
 DT
References: <1394742919-32163-1-git-send-email-joelf@ti.com> <1394742919-32163-3-git-send-email-joelf@ti.com>
In-Reply-To: <1394742919-32163-3-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 10:35 PM, Joel Fernandes wrote:
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 4e6c959..51b7008 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -352,6 +352,7 @@
>   			interrupts = <67>;
>   			ti,hwmods = "timer1";
>   			ti,timer-alwon;
> +			ti,default-parent = <&sys_clkin_ck>;
>   		};
>
>   		timer2: timer@48040000 {
> @@ -360,6 +361,7 @@
>   			reg = <0x48040000 0x400>;
>   			interrupts = <68>;
>   			ti,hwmods = "timer2";
> +			ti,default-parent = <&sys_clkin_ck>;
>   		};
>
>   		timer3: timer@48042000 {
>

I don't think this works, the ti,default-parent property is only 
supported for clock nodes (at least I didn't quickly find anything from 
your clocksource driver that would handle this.) You should do something 
like this:

&timer1_fck {
	ti,default-parent = <&sys_clkin_ck>;
};

&timer2_fck {
	ti,default-parent = <&sys_clkin_ck>;
};

-Tero

