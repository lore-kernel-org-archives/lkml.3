Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaE3SCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:02:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34149 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbaE3SCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:02:12 -0400
Date: Fri, 30 May 2014 19:02:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Liu Hua <sdu.liu@huawei.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vitalya@ti.com" <vitalya@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "liusdu@126.co" <liusdu@126.co>, "cyril@ti.com" <cyril@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH v3 2/2] ARM : change fixmap mapping region to support 32
 CPUs
Message-ID: <20140530180212.GF22895@arm.com>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
 <1397559967-26050-3-git-send-email-sdu.liu@huawei.com>
 <CAL_JsqKE-L2PN3mXHNdTPMEyTMR9ZtbgGB=O_V6nOXN0YC0a4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKE-L2PN3mXHNdTPMEyTMR9ZtbgGB=O_V6nOXN0YC0a4A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 04:33:46PM +0100, Rob Herring wrote:
> On Tue, Apr 15, 2014 at 6:06 AM, Liu Hua <sdu.liu@huawei.com> wrote:
> > In 32-bit ARM systems, the fixmap mapping region can support
> > no more than 14 CPUs(total: 896k; one CPU: 64K). And we can
> > configure NR_CPUS up to 32. So there is a mismatch.
> >
> > This patch moves fixmapping region downwards to region
> > 0xffc00000-0xffe00000. Then the fixmap mapping region can
> > support up to 32 CPUs
> 
> Ugg, this series breaks using fixmap for anything other than kmap
> since 32 cpus requires all 2MB of the region and nothing is left.
> There's work in flight to support early_ioremap, early console, and RO
> text patching which all use the fixmap region.
> 
> There's a couple of options to solve this:
> 
> - Only support up to 16 cpus. It could be anywhere between 17-31, but
> that seems somewhat unlikely. Are we really ever going to see 32-bit
> 32 core systems?

I'd be fine with restricting the limit to 16 CPUs.

Will
