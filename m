Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab3GaPWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:22:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:35031 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760340Ab3GaPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:22:04 -0400
Date: Wed, 31 Jul 2013 17:21:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        George Cherian <george.cherian@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Roger Quadros <rogerq@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] of: provide of_platform_unpopulate()
Message-ID: <20130731152158.GA10501@linutronix.de>
References: <1374257691-31981-1-git-send-email-bigeasy@linutronix.de>
 <51EBF33A.4050207@gmail.com>
 <51EC4908.4040504@gmail.com>
 <CACxGe6sqv2Wsp26MWqqs9W_eWO3tjs-+2z3z8fC=2fe-BjJvkA@mail.gmail.com>
 <51EDA117.10605@gmail.com>
 <20130724141958.9156F3E0A24@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130724141958.9156F3E0A24@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2013-07-24 15:19:58 [+0100]:

>> Was there more breakage than imx6 and amba devices? Your first version
>> had a fallback case for powerpc. Couldn't we do just allow that for more
>> than just powerpc? I'd much rather see some work-around within the core
>> DT code with a warning to prevent more proliferation than putting this
>> into drivers.
>
>It's tricky stuff. I've not figured out a solution I'm happy with.
>Trying to figure out when to apply a work around is hard because the
>resource reservation makes assumptions about the memory range layout
>that doesn't match the assumptions made by device tree code.

I can't really follow. Do you have a simple at hand?

>One /possible/ option is to not add the resources to the devices at all
>when the device is registered and instead resolve them right at bind
>time. Jean Christophe proposed doing this already to solve a different
>problem; obtaining resources that require other drivers to be probed
>first. If the resources are resolved at .probe() time, then the resource
>registration problem should also go away.
>
>The downside to that approach is that it makes each deferred probe more
>expensive; potentially a *lot* more expensive depending on how much work
>the xlate functions have to do. It would be worth prototyping though to
>see how well it works.

So you say defer the io ressources until the device-tree device is
actually probed. I don't really understand why that defer part should
solve the problem but I would try and see how it goes.
Jean-Christophe proposed that only, that means no patches yet, right?

>g.

Sebastian
