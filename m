Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3FJPgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:36:04 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32216 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3FJPgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:36:02 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-67-51b5f25be91c
From: Shuah Khan <shuah.kh@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH V2] drivers/rtc/class: convert from Legacy pm ops to
 dev_pm_ops
Thread-topic: [PATCH V2] drivers/rtc/class: convert from Legacy pm ops to
 dev_pm_ops
Thread-index: Ac5jJncjaDTr8BPFT+qb2qZHilxBvA==
Date: Mon, 10 Jun 2013 15:35:54 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61566A80@sisaex02sj>
References: <000301ce6326$98df9660$ca9ec320$@samsung.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9hP93oT1sDDVadlbZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djBZffzo4sHnsnHWX3WPPxJNsHidm/Gbx6NuyitFj+ryfTB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZbz50sVYsFGiYs7FT4wNjKtEuhg5OSQETCSeHzvOCmGLSVy4t56t
	i5GLQ0hgGaPEvV3rGSGcXiaJORN/QmXmM0p8376eGaSFTUBd4vPrHewgtoiAisTn9cfBipgF
	2pkkelasBprLwSEsECpx+YI0RE2YROOqDSwQtp7E7H2dYL0sAqoSvVumgJ3BK2AvMbXzIyOI
	LSRgKXFt3mkmEJsR6Lzvp9aA2cwC4hLNrTdZIM4WkFiy5zwzhC0q8fLxP7C1EgKKEttXW0GU
	a0ms33kcqlVb4sm7C1CrBCV+TL7HMoFRbBaSqbOQtMxC0jILScsCRpZVjGKlxckFxUnpqRXG
	esWJucWleel6yfm5mxgh8Vizg/HeV5tDjAIcjEo8vA9/bQkUYk0sK67MPcQowcGsJMKb/GZr
	oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGotsJDv01iovjykMDc4U8e1IKDQ880mW7y3Vbt2/K
	y83farLkHNMlL87bOvXsw2rp1b5ZEY+2JfFMmWIiZ/c8t4j51OFP5X0vIl4d/CI089O1ir+a
	HC1n69WuhQQ+0Jib/WFB7JfqPlsPLZUFx8JsDwnarG4wyDkYMbF3mbW1+afqZTpxPd5KLMUZ
	iYZazEXFiQDO1hrfpQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:28 PM, Jingoo Han wrote:
> From: Shuah Khan <shuah.kh@samsung.com>
>
> Convert drivers/rtc/class to use dev_pm_ops for power management and
> remove Legacy PM ops hooks.  With this change, rtc class registers
> suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
> class->suspend/resume.  When __device_suspend() runs call-backs, it will
> find class->pm ops for the rtc class.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> ---
> Changes since v1:
> - Added 'RTC_CLASS_DEV_PM_OPS' to fix buill errors.
> - Replaced '#if defined(CONFIG_PM)' with '#if defined(CONFIG_PM_SLEEP)'.
>
>   drivers/rtc/class.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 6638540..0242681 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -38,7 +38,7 @@ static void rtc_device_release(struct device *dev)
>   int rtc_hctosys_ret = -ENODEV;
>   #endif
>
> -#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
> +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
>   /*
>    * On suspend(), measure the delta between one RTC and the
>    * system's wall clock; restore it on resume().
> @@ -47,7 +47,7 @@ int rtc_hctosys_ret = -ENODEV;
>   static struct timespec old_rtc, old_system, old_delta;
>
>
> -static int rtc_suspend(struct device *dev, pm_message_t mesg)
> +static int rtc_suspend(struct device *dev)
>   {
>   	struct rtc_device	*rtc = to_rtc_device(dev);
>   	struct rtc_time		tm;
> @@ -135,9 +135,10 @@ static int rtc_resume(struct device *dev)
>   	return 0;
>   }
>
> +static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
> +#define RTC_CLASS_DEV_PM_OPS	(&rtc_class_dev_pm_ops)
>   #else
> -#define rtc_suspend	NULL
> -#define rtc_resume	NULL
> +#define RTC_CLASS_DEV_PM_OPS	NULL
>   #endif
>
>
> @@ -336,8 +337,7 @@ static int __init rtc_init(void)
>   		pr_err("couldn't create class\n");
>   		return PTR_ERR(rtc_class);
>   	}
> -	rtc_class->suspend = rtc_suspend;
> -	rtc_class->resume = rtc_resume;
> +	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
>   	rtc_dev_init();
>   	rtc_sysfs_init(rtc_class);
>   	return 0;
>

Looks good. Thanks for fixing the problem. My apologies for introducing 
the warnings. I had CONFIG_PM and  CONFIG_PM_SLEEP both enabled and 
didn't see this warning. I will be  careful with subsequent patches in 
this area.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
