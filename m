Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3FCDWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:22:34 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:48520 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FCDW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:22:26 -0400
Date: Mon, 3 Jun 2013 06:22:19 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 02/10] clocksource: dw_apb_timer_of: add clock-handling
Message-ID: <20130603032219.GM11798@tarshish>
References: <201306030055.15413.heiko@sntech.de>
 <201306030056.37724.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306030056.37724.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Jun 03, 2013 at 12:56:37AM +0200, Heiko Stübner wrote:
> Add the possibility to get the clock-frequency from a timer clock instead
> of specifying it as dt property. Additionally also add the possibility
> to also define a controlling periphal clock for the timer block.
> 
> The clock-frequency property is kept to act as fallback if no clocks
> are specified.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  Documentation/devicetree/bindings/rtc/dw-apb.txt |   19 ++++++++++++++++
>  drivers/clocksource/dw_apb_timer_of.c            |   26 +++++++++++++++++++++-
>  2 files changed, 44 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rtc/dw-apb.txt b/Documentation/devicetree/bindings/rtc/dw-apb.txt
> index 93e2b0f..80ab1c1 100644
> --- a/Documentation/devicetree/bindings/rtc/dw-apb.txt
> +++ b/Documentation/devicetree/bindings/rtc/dw-apb.txt
> @@ -5,9 +5,20 @@ Required properties:
>  - reg: physical base address of the controller and length of memory mapped
>    region.
>  - interrupts: IRQ line for the timer.
> +- either clocks+clock-names or clock-frequency properties
> +
> +Optional properties:
> +- clocks	: list of clock specifiers, corresponding to entries in
> +		  the clock-names property;
> +- clock-names	: should contain "timer and "pclk" entries, matching entries

Missing closing quotes around "timer".

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
