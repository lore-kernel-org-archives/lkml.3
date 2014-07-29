Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaG2Xjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:39:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54661 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaG2XjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:39:14 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 RESEND 2/4] drivers: of: initialize and assign
 reserved memory to newly created devices
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <53D7B3E8.6070906@samsung.com>
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
	<1405326487-15346-3-git-send-email-m.szyprowski@samsung.com>
	<20140728141700.55FC4C408EA@trevor.secretlab.ca>
	<53D7B3E8.6070906@samsung.com>
Date: Tue, 29 Jul 2014 13:46:46 -0600
Message-Id: <20140729194646.D9764C40685@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014 16:47:04 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
> 
> On 2014-07-28 16:17, Grant Likely wrote:
> > On Mon, 14 Jul 2014 10:28:05 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >> Use recently introduced of_reserved_mem_device_init() function to
> >> automatically assign respective reserved memory region to the newly created
> >> platform and amba device.
> >>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > I'm still not okay with this patch. I don't think it is appropriate to
> > add the hook into the generic path that gets used for every platform
> > device. The devices that need reserved memory should explicitly request
> > it, and any setup be done at that time.
> 
> Okay... I thought that it will be easier to have it done in generic 
> code, if You don't
> think so, then I give up and we will add it in all drivers requiring 
> such memory regions.

The problem is that it makes the big assumption that every device is
going to conform to the pattern without any recourse if something
special needs to be done (such as to handle quirks). It also puts this
code into the probe path of every device, when the vast majority of
device drivers just don't care. When code like this is run
unconditionally from generic code, it becomes really difficult to
override when needed.

I've made the same comment on the PM clock domain patches.

> What about patch 3/4 and 4/4? Would it be possible to have your ack to 
> get them merged?
> Right now patch 4/4 depends on changes from akpm tree, so it will be 
> best to merge them
> to akpm tree.

I'll take a look.

g.

