Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaBFN0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:26:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49781 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaBFN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:26:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f5-52f38d769f7d
Message-id: <52F38D75.4030704@samsung.com>
Date: Thu, 06 Feb 2014 14:26:13 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 4/5] ARM: init: add support for reserved memory defined
 by device tree
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
 <1391515773-6112-5-git-send-email-m.szyprowski@samsung.com>
 <20140205101510.59A95C40A89@trevor.secretlab.ca>
In-reply-to: <20140205101510.59A95C40A89@trevor.secretlab.ca>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RW0iTYRzGeb/D9m009jk1XowMFhFILQUZL6JiXcRXXRSDER3Ili4PbFO2
	lEyqNUxttSl6MRnptNSLeZ7Z5lLSkTOVTjgU0xQVKnWWuiFp26q1G+9+D/ye/3Pxp3CBi4ij
	8lS35GqVTCFkcYmJ0KjneLHBJ0k0WcQoWONmow3dQxxZ3rwnUZW3iURDAQdAXkMlgfo7fwD0
	TudlI/ujOjbyexYxZFueIlFTeTOBJp1PWah7ZRhDLdOfMNQ4WkaigCkejU/7WKja1EEg20IH
	QEG7jUCrw+UE6qpbI5DVGQAZkGlvaAfM790awKzVVgNm0mjAmH7zFzbzxFtGMnNTAyymt/k+
	MxtaxhnPWx3JdAZWMaYqmMgYX1gB47PFMz310gv8y9zUbLkir1iuPpF+nZtrnnVjhS/p22a7
	HdeCHp4ecChIJ0Pt100iwvvhx/kulh5wKQHdAmDrjANEwhaAr4fcWNji0QlwbsP5nwn6CGwc
	+c4OM4tOgvp1/b82RcXSUthQL4roUfBX7TwRvhNDjwEYGjSywwGnB0monxtkhwvRdCb0V5RG
	xhwAbo9VgnCbQ6fBnaEmVphxWgyXyjrxCB+Cve3reDWgzXtGzHs08x6tEeBWECsvyirU3MhR
	Jok0MqWmSJUjyipQ2kDk734HeO5OcQGaAsJ9vO6uLYmAlBVrSpQuAClcGMOT63wSAS9bVnJH
	ri7IVBcp5BoXwChOnBacXk3xP8vIv+v7eZTrNKnYVwra+IaR9OED+flLm9cEfyY8tZscg914
	zHO+RTEw9qp5xghmt+0KRZtYds/Rx9VaSknzqbPfqKiQwSKl+04mnxlPlcS3xl1dTxm3rkSD
	izWHzwX94semm47Pl/ii+YqFHWl/xWJa/cEH/N0PDiGhyZUlJeBqjewvls+W7dUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-05 11:15, Grant Likely wrote:
> On Tue, 04 Feb 2014 13:09:32 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > Enable reserved memory initialization from device tree.
> >
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Laura Abbott <lauraa@codeaurora.org>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  arch/arm/mm/init.c |    3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > index 804d61566a53..ebafdb479410 100644
> > --- a/arch/arm/mm/init.c
> > +++ b/arch/arm/mm/init.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/nodemask.h>
> >  #include <linux/initrd.h>
> >  #include <linux/of_fdt.h>
> > +#include <linux/of_reserved_mem.h>
> >  #include <linux/highmem.h>
> >  #include <linux/gfp.h>
> >  #include <linux/memblock.h>
> > @@ -323,6 +324,8 @@ void __init arm_memblock_init(struct meminfo *mi,
> >  	if (mdesc->reserve)
> >  		mdesc->reserve();
> >
> > +	early_init_dt_scan_reserved_mem();
> > +
>
> The new binding is being made fundamental. If the reserved-memory node
> is present, then it needs to be honored, even if the kernel doesn't know
> how to use the regions. Therefore, This needs to be unconditional for
> all architectures. The hook should be called in early_init_dt_scan()
> (drivers/of/fdt.c) immediately after the early_init_dt_scan_memory()
> hook.

In theory this will be the best solution, but it practice there is a
problem. early_init_dt_scan() is called as the first function from kernel
booting code. That time there is no memory yet added to the system, so it
would be really hard to reserve anything. Memory nodes are being added
later either with memblock_add() or by some other arch specific way.

Finally, once all memory has been added to the system we can parse and
reserve all regions defined in the device tree. This really requires
creating another function which will be called by arch specific code.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

