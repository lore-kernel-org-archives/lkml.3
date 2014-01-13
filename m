Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaAMEz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:55:57 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:65366 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMEzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:55:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140113032603.GG23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
	<1389321592-33220-2-git-send-email-john.tobias.ph@gmail.com>
	<20140113032603.GG23525@S2101-09.ap.freescale.net>
Date: Sun, 12 Jan 2014 20:55:52 -0800
Message-ID: <CACUGKYP9DWx7JRNnBGoAxGhDi5iNQ3Q_5NSZPcz6QQpYVqxWbQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] cpufreq: imx6q-cpufreq driver depends on SOC_IMX6Q/SOC_IMX6SL
From: John Tobias <john.tobias.ph@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@rjwysocki.net, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's ok.

On Sun, Jan 12, 2014 at 7:26 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Thu, Jan 09, 2014 at 06:39:52PM -0800, John Tobias wrote:
>> The ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP are moved up to ARCH_MCX.
>> The driver should show if the SOC_IMX6Q and/or SOC_IMX6SL is/are selected.
>>
>> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
>> ---
>>  drivers/cpufreq/Kconfig.arm | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>> index 3ba5dcc..230c663 100644
>> --- a/drivers/cpufreq/Kconfig.arm
>> +++ b/drivers/cpufreq/Kconfig.arm
>> @@ -80,7 +80,7 @@ config ARM_HIGHBANK_CPUFREQ
>>
>>  config ARM_IMX6Q_CPUFREQ
>>       tristate "Freescale i.MX6 cpufreq support"
>> -     depends on ARCH_MXC
>> +     depends on SOC_IMX6Q || SOC_IMX6SL
>
> No.  We do not want to touch this line where there is another IMX6xx can
> reuse the driver.  Depending on ARCH_MXC is good enough, since we
> already have the symbol prompt and help text to tell the targets that
> the driver supports.
>
> Shawn
>
>>       depends on REGULATOR_ANATOP
>>       help
>>         This adds cpufreq driver support for Freescale i.MX6 series SoCs.
>> --
>> 1.8.3.2
>>
>
