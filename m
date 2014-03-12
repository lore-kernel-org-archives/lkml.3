Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCLMGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:06:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4634 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbaCLMGt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:06:49 -0400
Date: Wed, 12 Mar 2014 20:04:28 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
CC: "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP
 device tree
Message-ID: <20140312200428.23178d69@xhacker>
In-Reply-To: <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
	<1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_04:2014-03-12,2014-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403120039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Wed, 12 Mar 2014 04:06:04 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile         |  3 ++-
>  arch/arm/boot/dts/berlin2q-dmp.dts | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/berlin2q-dmp.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 032030361bef..1a2adadfb962 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -52,7 +52,8 @@ dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
>  dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
>  dtb-$(CONFIG_ARCH_BERLIN) += \
>  	berlin2-sony-nsz-gs7.dtb	\
> -	berlin2cd-google-chromecast.dtb
> +	berlin2cd-google-chromecast.dtb	\
> +	berlin2q-dmp.dtb
>  dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>  	da850-evm.dtb
>  dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
> diff --git a/arch/arm/boot/dts/berlin2q-dmp.dts
> b/arch/arm/boot/dts/berlin2q-dmp.dts new file mode 100644
> index 000000000000..6a98860e0251
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2q-dmp.dts
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +/dts-v1/;
> +#include "berlin2q.dtsi"
> +
> +/ {
> +	model = "Marvell BG2-Q DMP";
> +	compatible = "marvell,berlin2q-dmp", "marvell,berlin2q",
> "marvell,berlin"; +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x00000000 0x40000000>;

The memory size of BG2Q DMP is 2GB. And IIRC, all BG2Q boards have 2GB memory.
So would it be better to put memory dt node in berlin2q.dtsi?

Thanks,
Jisheng
