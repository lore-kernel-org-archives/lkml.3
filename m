Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaEOGMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:12:13 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36951 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaEOGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:12:10 -0400
MIME-Version: 1.0
In-Reply-To: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 15 May 2014 11:42:09 +0530
Message-ID: <CAKohpokm3WVnu_DggKc4PbhVAKNexrJ4051F-gnVFFTDOyz9ew@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Frequency resolution in CCF vs. cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 04:00, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> I have one or two problems with cpufreq and the CCF, which are caused by
> rounding/different frequency resolutions.
>
> cpufreq works with kHz, while the CCF uses Hz. On Zynq our default frequency is
> 666666666 Hz which the CCF, due to rounding, reports as 666666660. And for
> cpufreq, which simply divides values it obtains through clk_round_rate() by
> 1000, 666666.
> Since passing 666666 to clk_round_rate() does not result in 666666660
> (clk_round_rate() always rounds down!), we chose to put 666667 in the OPP. This
> causes issue 1: cpufreq stats are broken.

I know it might a big exercise, but wouldn't it be worth to make cpufreq start
using frequencies in Hz ?
