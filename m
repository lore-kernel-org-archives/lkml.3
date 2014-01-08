Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaAHNlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:41:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbaAHNlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:41:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references late
Date: Wed, 08 Jan 2014 14:41:19 +0100
Message-ID: <4589157.TquA4Q59fC@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1389185477-507-1-git-send-email-treding@nvidia.com>
References: <20140108011957.GK5074@atomide.com> <1389185477-507-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5xeP46aozvxxxm6elq3YqXYuLJ8vvjBEsP+gSjOQCV0
 I+PZwB+GDCxJahlvFL99R62EQ5r1Yf6tFfkM7VOXH5qV0/Ni7S
 AHkjZ+bWsN+TDIFgOoBp/yv1joxCTjiV5OqZT727AI5Fl3+Flt
 KSsf0NJX8E+r+oZdQWCf/M4WVgsbe96nAZJGhgfWmRDycQE0me
 Iilc5xot4aX3OYzOw88o84LJ9+4CiLnQY1d2T89fWykSsc+0Pa
 HlNWN/J6P3QMU6NeygtG0NsZq/wV+uIfLMOWzW8qBJpjZ99SRq
 Szk0CCtA3oivEyty1OXNE31KpcRbj6Ja5LTLvtXqhvX4dcQe3H
 LCXu0oq05M646P2b2YyY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 13:51:17 Thierry Reding wrote:
> When devices are probed from the device tree, any interrupts that they
> reference are resolved at device creation time. This causes problems if
> the interrupt provider hasn't been registered yet at that time, which
> results in the interrupt being set to 0.

Thanks for looking at this problem, it has bothered a lot of people
for a long time. I'm sorry I wasn't there for the discussion in November,
but when it came up before, I suggested a different solution that
apparently didn't get implemented.

> Note that this patch is the easy way out to fix a large part of the
> problems for now. A more proper solution for the long term would be to
> transition drivers to an API that always resolves resources of any kind
> (not only interrupts) at probe time.
> 
> For some background and discussion on possible solutions, see:
> 
> 	https://lkml.org/lkml/2013/11/22/520

I hope I read this thread correctly, sorry if I missed an important
part. My idea was to add the code not in platform_get_irq() but add
the resource in platform_drv_probe(), and just bail out with
-EPROBE_DEFER there if necessary.

We could then skip adding the resources at device creation time.
Is this something you already plan to do later, or is there a reason
it wouldn't work?

In the meantime, I don't see anything with your patch, but it also
wouldn't hurt to do it now if it solves all the problems.

	Arnd
