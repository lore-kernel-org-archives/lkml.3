Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaDIElR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:41:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60347 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaDIElQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <1396996485-632-1-git-send-email-elder@linaro.org>
References: <1396996485-632-1-git-send-email-elder@linaro.org>
Date: Wed, 9 Apr 2014 10:11:15 +0530
X-Google-Sender-Auth: z6x_w_rChlC1YDuG3l1b61Tg0vo
Message-ID: <CAOh2x=mQF3MLbJwfaBqE3K4Hf-qUrnbHe=6zW0XeK0GEk9raLg@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: spear: add __init to spear_clocksource_init()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        Vipin Kumar <vk.vipin@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 4:04 AM, Alex Elder <elder@linaro.org> wrote:
> I get a build warning because spear_clocksource_init() calls
> clocksource_mmio_init(), but it doesn't have an __init annotation.
> Fix that.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  arch/arm/mach-spear/time.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
> index 218ba5b..c4d0931 100644
> --- a/arch/arm/mach-spear/time.c
> +++ b/arch/arm/mach-spear/time.c
> @@ -71,7 +71,7 @@ static void clockevent_set_mode(enum clock_event_mode mode,
>  static int clockevent_next_event(unsigned long evt,
>                                  struct clock_event_device *clk_event_dev);
>
> -static void spear_clocksource_init(void)
> +static void __init spear_clocksource_init(void)
>  {
>         u32 tick_rate;
>         u16 val;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
