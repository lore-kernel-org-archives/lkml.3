Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3IYLfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:35:15 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39543 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3IYLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
	<1380108138-30402-2-git-send-email-l.majewski@samsung.com>
Date: Wed, 25 Sep 2013 17:05:11 +0530
Message-ID: <CAK9yfHzb8VA+E38iQ3b31Yjfd9BvKcEMBc_gijJ3hERa_fBqFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework
 to set APLL clock rate
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukasz,

On 25 September 2013 16:52, Lukasz Majewski <l.majewski@samsung.com> wrote:
>
>  static void exynos4x12_set_apll(unsigned int index)
>  {
> -       unsigned int tmp, pdiv;
> +       unsigned int tmp, freq = apll_freq_4x12[index].freq;

nit: It is better to put the 'freq' assignment on a new line.

>
> -       /* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
> +       /* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
>         clk_set_parent(moutcore, mout_mpll);
>
>         do {
> @@ -140,24 +140,9 @@ static void exynos4x12_set_apll(unsigned int index)
>                 tmp &= 0x7;
>         } while (tmp != 0x2);
>
> -       /* 2. Set APLL Lock time */
> -       pdiv = ((apll_freq_4x12[index].mps >> 8) & 0x3f);
> +       clk_set_rate(mout_apll, freq * 1000);

Don't we need to check the return value of this?

Same comments for the second patch too.

-- 
With warm regards,
Sachin
