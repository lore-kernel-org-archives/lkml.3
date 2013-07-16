Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3GPKEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:04:06 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54344 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3GPKED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <1372927830-2949-4-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-4-git-send-email-l.majewski@samsung.com>
Date: Tue, 16 Jul 2013 15:34:02 +0530
Message-ID: <CAKohpomdkF-XVWXaxNx+SfnHvHE_N6=gcU06YD6D7_oB0-M9aA@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code
 to work with common boost solution
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
>  static void __init acpi_cpufreq_boost_init(void)
> @@ -953,33 +937,22 @@ static void __init acpi_cpufreq_boost_init(void)
>                 if (!msrs)
>                         return;
>
> -               boost_supported = true;
> -               boost_enabled = boost_state(0);
> +               cpufreq_set_boost_enabled(boost_state(0));
> +               acpi_cpufreq_driver.boost_supported = true;

You are again doing the same mistake. Boost must be
always supported for acpi-cpufreq with read permissions, as it was
earlier.
