Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaGKKJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:09:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52602 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaGKKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:09:40 -0400
Message-ID: <53BFB7DF.3010205@gmail.com>
Date: Fri, 11 Jul 2014 15:39:35 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Tushar Behera <tushar.b@samsung.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org
Subject: Re: [PATCH 0/2] clk: exynos-audss: Adapt to exising clock framework
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com> <53BFB39F.6040606@samsung.com>
In-Reply-To: <53BFB39F.6040606@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 03:21 PM, Tomasz Figa wrote:
> Hi Tushar,
> 
> On 11.07.2014 11:37, Tushar Behera wrote:
>> The patchset is targetted as moving exising exynos-audss clock driver from being
>> a module driver. The driver is now registered through CLK_OF_DECLARE and is
>> inline with other Samsung clock drivers.
> 
> I'm afraid I have to NAK this series or at least the part converting the
> driver back to use CLK_OF_DECLARE().
> 

Considering the more prevalent usage of CLK_OF_DECLARE() in drivers/clk
led me into thinking it was the normal way for the clock drivers.
Keeping only one clock driver using a different approach looked odd to
me. Anyways, I don't have any other reason to pursue this case.

> We have deliberately made this driver a platform driver, because this is
> how drivers should be modeled in Linux kernel whenever possible.
> CLK_OF_DECLARE() should be only considered a hack to work around late
> initialization of driver model. Reverting this change without a good
> reason (and you haven't provided such) is just going backwards.
> 
> Rest of this series is actually quite nice, though, as reusing Samsung
> clock helpers reduces the line count significantly, so if you could
> rework this to keep this driver a platform driver then we could get
> something I could ack.
> 

Sure. There are still some valid cleanups even if we plan to retain the
platform driver infrastructure. I will split and repost.

> Best regards,
> Tomasz
> 


-- 
Tushar Behera
