Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966297AbaLLLb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:31:59 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:52888 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbaLLLb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:31:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
Date: Fri, 12 Dec 2014 12:31:30 +0100
Message-ID: <1521226.qVx3V7aJT6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <548A9D27.1000504@samsung.com>
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com> <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com> <548A9D27.1000504@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:xXiqxVDgYuRk8lkvZq+e8yw9e61HsF3C8xErCSN7eZs1quBpb1j
 IJGqXvo04WSDW7nuHHb5sdy/RnQxrTwiNIpqr7AJgMrQk7CnnIPRy+WC741YB7SvuPaaJUP
 IDZXGs/VFHgxRWN3AzLbOTCIx4WYAQw9UkVtFwmhgw/jFBfYOLueWlqMmfXey39hyAD3jd8
 e3L3G1w2XQ6hq9uC+1J1Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2014 13:15:43 Pankaj Dubey wrote:
> >> +
> >> +static void __iomem *exynos_chipid_base;
> >> +
> >> +struct exynos_chipid_info exynos_soc_info;
> >> +EXPORT_SYMBOL(exynos_soc_info);
> >
> > The soc_device already has similar data.Why is this needed? Is it
> > temporary for compatibility?
> 
> struct soc_device_attribute can hold these two (product_id, and 
> revision) but they are defined as char * in soc_device_atttribute, and I 
> feel it's more specific for exposing via sysfs.
> Also existing code in mach-exynos compares them via product_id/revision 
> macros, so I can say to keep compatibility.

We had a similar discussion about the Marvell SoCs a while ago, and at
the time we concluded that it would be best to create a platform-
independent API to match the strings in soc_device_attribute against
a list of strings in the driver, either by matching the start of the
string, or using the glob_match() function. Would that work for you?

	Arnd
