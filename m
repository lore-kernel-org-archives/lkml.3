Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaF0DiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:38:22 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33921 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaF0DiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:38:20 -0400
Message-ID: <53ACE724.7090606@gmail.com>
Date: Fri, 27 Jun 2014 09:08:12 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Doug Anderson <dianders@google.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kukjin Kim <kgene.kim@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>	<1402464739-19044-3-git-send-email-tushar.b@samsung.com>	<CAD=FV=W5yh58fYTwRZxmZt=BORcZMSRV0oRe12yA74Q5h2S4YQ@mail.gmail.com>	<7hpphwlgn0.fsf@paris.lan>	<CAC5m3Bzey-YoPLmjAq4YNPQ13rojtVFWAbnhX6-ZFtYZwEdMWg@mail.gmail.com> <7h8uojk61a.fsf@paris.lan>
In-Reply-To: <7h8uojk61a.fsf@paris.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 09:38 PM, Kevin Hilman wrote:
> Tushar Behera <trblinux@gmail.com> writes:
> 
>> On Thu, Jun 26, 2014 at 4:51 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Doug Anderson <dianders@google.com> writes:
>>>
>>>> Tushar,
>>>>
>>>> On Tue, Jun 10, 2014 at 10:32 PM, Tushar Behera <tushar.b@samsung.com> wrote:
>>>>> Currently CLK_FOUT_EPLL was set as one of the parents of AUDSS mux.
>>>>> As per the user manual, it should be CLK_MAU_EPLL.
>>>>>
>>>>> The problem surfaced when the bootloader in Peach-pit board set
>>>>> the EPLL clock as the parent of AUDSS mux. While booting the kernel,
>>>>> we used to get a system hang during late boot if CLK_MAU_EPLL was
>>>>> disabled.
>>>>>
>>>>> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
>>>>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>>>>> Reported-by: Kevin Hilman <khilman@linaro.org>
>>>>> ---
>>>>>  arch/arm/boot/dts/exynos5420.dtsi |    2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> I've tested this myself now as well.
>>>>
>>>> Tested-by: Doug Anderson <dianders@chromium.org>
>>>
>>> For me, this patch alone (on top of -next) doesn't solve the boot hang.
>>> I still need clk_ignore_unused for a successful boot.
>>>
>>> So, this patch might be correct, but it doesn't prevent a boot hang
>>> using a chain-loaded nv_uboot on peach-pi.  There's still another clock
>>> being disabled that causes a hang.
>>>
>>> Kevin
>>
>> Kevin,
>>
>> Can you please check if adding patch 1/3 alongwith patch 2/3 fixes the
>> issue for you?
> 
> Yes, using patch 1/3 along with 2/3 fixes the issue.
> 

Okay, that adds some more reason to re-investigate patch 1/3.

Kevin,

Would you please provide me the environment setting of your u-boot?
U-boot environment on my board has been over-written, I would like to
set it same as yours and try to reproduce the issue at my end. With only
'sound init', I don't seem to hit this issue anymore.

>> Also can you please confirm that setting CLK_IGNORE_UNUSED flag
>> CLK_MAU_EPLL alone fixes the issue, without any need for
>> clk_ignore_unused in u-boot bootargs?
> 
> Yes, I have this patch[1] in my local branch which fixes the issue
> alone, without clk_ignore_unused on the command line.
> 
> Kevin
> 
> 
> [1]
> From ab1627127730ef4507ce96cbf95047d626bbb53f Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@linaro.org>
> Date: Thu, 5 Jun 2014 17:12:28 -0700
> Subject: [PATCH] KJH: leave mau_epll enabled
> 
> ---
>  drivers/clk/samsung/clk-exynos5420.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
> index 61eccf0dd72f..ed175088ee7e 100644
> --- a/drivers/clk/samsung/clk-exynos5420.c
> +++ b/drivers/clk/samsung/clk-exynos5420.c
> @@ -911,7 +911,7 @@ static struct samsung_gate_clock exynos5x_gate_clks[] __initdata = {
>  			SRC_MASK_TOP2, 24, 0, 0),
>  
>  	GATE(CLK_MAU_EPLL, "mau_epll", "mout_mau_epll_clk",
> -			SRC_MASK_TOP7, 20, 0, 0),
> +			SRC_MASK_TOP7, 20, CLK_IGNORE_UNUSED, 0),
>  
>  	/* sclk */
>  	GATE(CLK_SCLK_UART0, "sclk_uart0", "dout_uart0",
> 


-- 
Tushar Behera
