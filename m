Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaEZJ0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:26:09 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39799 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEZJ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140525184636.GN10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-20-git-send-email-wens@csie.org> <20140525184636.GN10768@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 26 May 2014 17:25:43 +0800
X-Google-Sender-Auth: ag-Hztl58S-0rsGK9xGS6O_jevo
Message-ID: <CAGb2v66jL5-rmSy0W38og6bLiNkGu0wekEZfOuh0Fn2oOsJpaQ@mail.gmail.com>
Subject: Re: [PATCH 19/22] ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 2:46 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Fri, May 23, 2014 at 03:51:22PM +0800, Chen-Yu Tsai wrote:
>> sun6i/sun8i have a UART in the RTC block group, which can be used
>> as an early console. This is most useful on sun8i as UART0 is muxed
>> with MMC0, which is not available if we boot from MMC.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/Kconfig.debug | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index eab8ecb..9e22708 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -694,6 +694,14 @@ choice
>>                 Say Y here if you want kernel low-level debugging support
>>                 on Allwinner A1X based platforms on the UART1.
>>
>> +     config DEBUG_SUNXI_R_UART
>> +             bool "Kernel low-level debugging messages via sunXi R_UART"
>> +             depends on ARCH_SUNXI
>
> It should rather depend on MACH_SUN8I.

I assume no sun6i devices would use it, or have pads available for it?
If so, then MACH_SUN8I makes sense.


ChenYu
