Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3CKDoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:44:44 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47794 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3CKDom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130307153736.GC4977@n2100.arm.linux.org.uk>
References: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
	<5138B200.7060906@samsung.com>
	<20130307153736.GC4977@n2100.arm.linux.org.uk>
Date: Mon, 11 Mar 2013 09:14:42 +0530
Message-ID: <CADGdYn4dzKnK-LJe6qGcJWLW8ZjGr4V8T3hqaZKFjPmHxthLxw@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
From: amit kachhap <amit.kachhap@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Mar 7, 2013 at 9:07 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Mar 07, 2013 at 04:28:00PM +0100, Sylwester Nawrocki wrote:
>> On 03/07/2013 05:13 AM, Amit Daniel Kachhap wrote:
>> > +   dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
>> > +   if (IS_ERR_OR_NULL(dvfs_info->cpu_clk)) {
>>
>> devm_clk_get() return value needs to be checked with IS_ERR(),
>> not IS_ERR_OR_NULL().
>>
>> > +           pr_err("Failed to get cpu clock\n");
>> > +           ret = PTR_ERR(dvfs_info->cpu_clk);
>> > +           goto err_free_table;
>
> Amit, to illustrate why this is wrong, consider this:
> 1. Set cpu_clk to NULL.
> 2. Realise IS_ERR_OR_NULL(NULL) is true.
> 3. What is the value of PTR_ERR(NULL) ?
> 4. What effect does that have when you jump to err_free_table ?
> 5. What value is returned from this function in that case ?
> 6. What does that return value mean to the driver core ?

Thanks for the detailed explaination. Usage of IS_ERR_OR_NULL is not
suitable here.

Thanks,
Amit D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
