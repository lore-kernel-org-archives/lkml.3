Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaDKGqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:46:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26747 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaDKGqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:46:37 -0400
Date: Fri, 11 Apr 2014 14:44:31 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 2/5] pinctrl: berlin: add a pinctrl driver for
 Marvell Berlin SoCs
Message-ID: <20140411144431.04fb148d@xhacker>
In-Reply-To: <1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_03:2014-04-11,2014-04-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404110116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Thu, 10 Apr 2014 06:07:51 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

...
> +static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
> +                               unsigned function,
> +                               unsigned group)
> +{
> +       struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> +       struct berlin_pinctrl_group *group_desc = pctrl->groups + group;
> +       struct berlin_pinctrl_function *function_desc =
> +               pctrl->functions + function;
> +       unsigned long flags;
> +       u32 regval;
> +
> +       spin_lock_irqsave(&pctrl->lock, flags);
> +
> +       regval = readl(group_desc->reg);
> +       regval &= group_desc->mask;
> +       regval |= function_desc->muxval << group_desc->lsb;
> +       writel(regval, group_desc->reg);

Could we use relaxed version instead?

Thanks,
Jisheng
