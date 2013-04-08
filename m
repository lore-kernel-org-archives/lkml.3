Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab3DHIgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:36:42 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:55759 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694Ab3DHIgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <2949363.nNl2A6XIoS@vostro.rjw.lan>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
	<2949363.nNl2A6XIoS@vostro.rjw.lan>
Date: Mon, 8 Apr 2013 14:06:38 +0530
X-Google-Sender-Auth: QxBXebhXEFOiQ69ymv-PLDyTDJE
Message-ID: <CADGdYn7ZRCSymU7k3Sn4mbS6B=dxy1N+vhQuyiFnhOQLLzrTbw@mail.gmail.com>
Subject: Re: [PATCH V5 0/4] cpufreq: exynos5440: support for cpufreq driver
From: amit daniel kachhap <amit.daniel@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 6:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, March 28, 2013 01:35:18 PM Amit Daniel Kachhap wrote:
>> Submitting the V5 version of exynos5440 cpufreq driver. This patchset addresses
>> all the coding and design concerns raised especially by Viresh.
>>
>> Changes in V5:
>> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
>> * Fixed all coding and comments issue raised by Viresh.
>>
>> Changes in V4:
>> * Added dev_err logs instead of pr_err.
>> * Used the devm_ioremap_resource API.
>> * Implemented several coding guidelines and minor error comments from Sylwester,
>>   Russell and Viresh.
>>
>> Changes in V3:
>> * Converted the driver to probe based as suggested by Viresh. This is also
>>   beneficial for multiplatform kernel.
>> * Other coding guidelines related changes.
>> * Moved the DT node outside cpu0 node as the driver is now a platform
>>   driver.
>>
>> Changes in V2:
>> * Added OPP library support to parse DT parameters.
>> * Removed a hack to handle interrupts in bootup.
>> * Implemented other review comments from Viresh and Inder.
>>
>> All these patches are dependent on Thomas Abraham common clock patches.
>> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html)
>> This whole patch series is based on 3.9-rc4.
>>
>> Amit Daniel Kachhap (4):
>>   cpufreq: exynos: Add cpufreq driver for exynos5440
>>   cpufreq: exynos: Remove error return even if no soc is found
>>   arm: exynos: Enable OPP library support for exynos5440
>>   arm: dts: Add cpufreq controller node for Exynos5440 SoC
>>
>>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   28 ++
>>  arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
>>  arch/arm/mach-exynos/Kconfig                       |    2 +
>>  drivers/cpufreq/Kconfig.arm                        |    9 +
>>  drivers/cpufreq/Makefile                           |    1 +
>>  drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
>>  drivers/cpufreq/exynos5440-cpufreq.c               |  474 ++++++++++++++++++++
>>  7 files changed, 527 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c
>
> Is this for me or the Samsung tree?
>
> If it's for me, I need ACKs from the Samsung tree maintainers.  Also, please
> address the Viresh's comments.
>
> Thanks,
> Rafael
>
Hi Rafael,

I submitted the V6 version with all comments from Viresh addressed.

Hi Kukjin Kim,

Any suggestion on how this patch should be merged. In my opinion it
should go via Rafael's tree as this patch uses some fixes present in
Rafael's tree like modified cpufreq_notify_transition API.

Thanks,
Amit Daniel
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
