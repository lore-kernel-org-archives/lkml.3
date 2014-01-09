Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaAIIip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:38:45 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:46241 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaAIIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:38:36 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
Date: Thu, 9 Jan 2014 00:38:35 -0800
Message-ID: <CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com>
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Mon, Jan 6, 2014 at 5:54 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
> CPUs clk rate, has similar sort of code used for most of them.
>
> This patch adds a generic ->get() which will do the same thing for them. All
> those drivers are required to now is to set .get to cpufreq_generic_get() and
> set their clk pointer in policy->clk during ->init().
>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Rafael,
>
> V2->V3: As asked by you earlier, I have merged all 23 patches here as they had
> common log and were touching separate drivers. This is already acked by many
> people.  Please see if looks okay for 3.14.

This patch breaks a bunch of ARM boards. In particular, the following
defconfigs no longer build:

          assabet_defconfig
          badge4_defconfig
          cerfcube_defconfig
          collie_defconfig
          h3600_defconfig
          hackkit_defconfig
          jornada720_defconfig
          lart_defconfig
          neponset_defconfig
          pleb_defconfig
          shannon_defconfig
          simpad_defconfig

Error is:

drivers/built-in.o: In function `cpufreq_generic_get':
drivers/cpufreq/cpufreq.c:189: undefined reference to `clk_get_rate'

Seems like this needs to be guarded by HAVE_CLK?


-Olof
