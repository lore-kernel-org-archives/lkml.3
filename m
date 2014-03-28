Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaC1KTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:19:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64714 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaC1KTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:19:51 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-42-53354cc5af7b
Date: Fri, 28 Mar 2014 11:19:43 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: create another field .flags in
 cpufreq_frequency_table
Message-id: <20140328111943.272d0bea@amdc2363>
In-reply-to: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
 <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd1jPqbBBjNeslk8bfrBbvFj1QdW
	i/eHnjFbXN41h83ic+8RRoszpy+xWlz+ep3ZouXjeiaLjV89HDg97lzbw+bx4NBmFo/b/x4z
	e2y52s7i8XmTXABrFJdNSmpOZllqkb5dAlfGsUNP2AqOCVZMfrKGuYGxiaeLkZNDQsBE4siG
	SawQtpjEhXvr2UBsIYHpjBLtL5Ug7F+MEteX1YDYLAKqEnuOTwarYRPQk/h89ylTFyMHh4iA
	lsTLm6ldjFwczAK3mCV6bp5iBYkLC4RJTJ1pBVLOC1T+aP9csFWcAgkSM7fuZwGpFxLYzCjx
	dP1psAS/gKRE+78fzBD32Emc+7SBHaJZUOLH5HssIDYz0K7N25pYIWx5ic1r3jJPYBSchaRs
	FpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjoZnUjsYVzZYHGIU4GBU4uF1
	sDAJFmJNLCuuzD3EKMHBrCTCu8TWNFiINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTE
	ktTs1NSC1CKYLBMHp1QD4+IG9sVssub/bvSFbay5lpHE5KBgvXJSh5l22me+T1VLJkZkHChQ
	v8G8Ja3wq6lJSXXAPKGoDTqJN1x4nBPCDqzm9vwZ1fnFNkLkKN82+zp3nU7hj99r2ozsGq6c
	mjBd4f1Fhn6BzU41rR0FFRrdWy8wLrya2Phuosnu7uPrE/5LV7/1kfZSYinOSDTUYi4qTgQA
	ZcwT1IICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c
> b/drivers/cpufreq/exynos4x12-cpufreq.c index 7c11ace..8c4c6a5 100644
> --- a/drivers/cpufreq/exynos4x12-cpufreq.c
> +++ b/drivers/cpufreq/exynos4x12-cpufreq.c
> @@ -30,21 +30,21 @@ static unsigned int exynos4x12_volt_table[] = {
>  };
> 
>  static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
> -       {CPUFREQ_BOOST_FREQ, 1500 * 1000},
> -       {L1, 1400 * 1000},
> -       {L2, 1300 * 1000},
> -       {L3, 1200 * 1000},
> -       {L4, 1100 * 1000},
> -       {L5, 1000 * 1000},
> -       {L6,  900 * 1000},
> -       {L7,  800 * 1000},
> -       {L8,  700 * 1000},
> -       {L9,  600 * 1000},
> -       {L10, 500 * 1000},
> -       {L11, 400 * 1000},
> -       {L12, 300 * 1000},
> -       {L13, 200 * 1000},
> -       {0, CPUFREQ_TABLE_END},
> +       {CPUFREQ_BOOST_FREQ, 0, 1500 * 1000},
> +       {0, L1, 1400 * 1000},
> +       {0, L2, 1300 * 1000},
> +       {0, L3, 1200 * 1000},
> +       {0, L4, 1100 * 1000},
> +       {0, L5, 1000 * 1000},
> +       {0, L6,  900 * 1000},
> +       {0, L7,  800 * 1000},
> +       {0, L8,  700 * 1000},
> +       {0, L9,  600 * 1000},
> +       {0, L10, 500 * 1000},
> +       {0, L11, 400 * 1000},
> +       {0, L12, 300 * 1000},
> +       {0, L13, 200 * 1000},
> +       {0, 0, CPUFREQ_TABLE_END},
>  };

Looks correct for me.

One little remark - since cpufreq_frequency_tables are defined as
static it seems like we don't need to explicitly specify the 0, for
flags field.

Something like {, L13, 200 * 1000}, shall be enough.

> +/* Special Values of .flags field */
> +#define CPUFREQ_BOOST_FREQ     0x1

Maybe (1 << 0) to explicitly show that those are flags.

> 
>  struct cpufreq_frequency_table {
> +       unsigned int    flags;
>         unsigned int    driver_data; /* driver specific data, not

The driver_data shall be changed to int. However I suppose that it will
be done at separate patch.

> used by core */ unsigned int    frequency; /* kHz - doesn't need to
> be in ascending
>                                     * order */

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
