Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3LCOqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:46:31 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41695 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3LCOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
	<1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 3 Dec 2013 20:16:26 +0530
Message-ID: <CAM4voam5GS5HORbb_r57C_61cMafKjQnBnR0dxD7x-9iTBps8Q@mail.gmail.com>
Subject: Re: [RFC v2 1/4] power: asv: Add common ASV support for Samsung SoCs
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "myungjoo.ham" <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Andrew Bresticker <abrestic@google.com>,
        Doug Anderson <dianders@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CC'ing Doug and Andrew who have also worked on ASV.

[...]

> diff --git a/drivers/power/asv/Kconfig b/drivers/power/asv/Kconfig
> new file mode 100644
> index 000000000000..761119d9f7f8
> --- /dev/null
> +++ b/drivers/power/asv/Kconfig
> @@ -0,0 +1,10 @@
> +menuconfig POWER_ASV
> +       bool "Adaptive Supply Voltage (ASV) support"
Select POWER_SUPPLY here ?
> +       help
> +         ASV is a technique used on Samsung SoCs which provides the
> +         recommended supply voltage for some specific parts(like CPU, MIF, etc)
> +         that support DVFS. For a given operating frequency, the voltage is
> +         recommended based on SoCs ASV group. ASV group info is provided in the
> +         chip id info which depends on the chip manufacturing process.
> +

[...]
> +
> +       if (asv_info->ops->init_asv)
> +               ret = asv_info->ops->init_asv(asv_info);
> +               if (ret) {
> +                       pr_err("asv_init failed for %s : %d\n",
> +                               asv_info->name, ret);
> +                       goto err;
> +               }
> +
> +       /* In case of parsing table from DT, we may need to add flag to identify
> +       DT supporting members and call init_asv_table from asv_init_opp_table(
> +       after getting dev_node from dev,if required), instead of calling here.
> +       */
Please fix Multi-line comment here and through the rest of the patches as well.

[...]
> + * @nr_dvfs_level: Number of dvfs levels supported by member.
> + * @dvfs_table: Table containing supported ASV freqs and corresponding volts.
> + * @asv_grp: ASV group of member.
> + * @flags: ASV flags
What are the ASV flags you had in mind ?
> + */
> +struct asv_info {
> +       const char              *name;
> +       enum asv_type_id        type;
> +       struct asv_ops          *ops;
> +       unsigned int            nr_dvfs_level;
> +       struct asv_freq_table   *dvfs_table;
> +       unsigned int            asv_grp;
> +       unsigned int            flags;
> +};

[...]
> +
> +#ifdef CONFIG_POWER_ASV
> +/* asv_get_volt - get the ASV for target_freq for particular target_type.
> + *     returns 0 if target_freq is not supported
Could you add a comment for asv_init_opp_table as well.
> + */
> +extern unsigned int asv_get_volt(enum asv_type_id target_type,
> +                                       unsigned int target_freq);
> +extern int asv_init_opp_table(struct device *dev,
> +                                       enum asv_type_id target_type);
> +#else
> +static inline unsigned int asv_get_volt(enum asv_type_id target_type,
> +                               unsigned int target_freq) { return 0; }
> +static int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
> +       { return 0; }
> +
> +#endif /* CONFIG_POWER_EXYNOS_AVS */
> +#endif /* __ASV_H */

Regards,
Abhilash
