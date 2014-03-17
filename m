Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaCQWHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:07:55 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43993 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaCQWHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140316094650.GV21483@n2100.arm.linux.org.uk>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140307044251.GD9985@codeaurora.org>
	<CADHgK6s4K+K+OZuUZVbHKNzbFiHzm82Ss0WpSfkUdQgP+E3j=w@mail.gmail.com>
	<20140316094650.GV21483@n2100.arm.linux.org.uk>
Date: Mon, 17 Mar 2014 15:07:51 -0700
Message-ID: <CADHgK6u7caDEZbt6Kj6VpzwADKytpk1068u_wQFFMvd3r1v1gw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Len Brown <len.brown@intel.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Laura Abbott <lauraa@codeaurora.org>, Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Russell!

On 16 March 2014 02:46, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Mon, Mar 10, 2014 at 11:32:17AM -0700, Sebastian Capella wrote:
...
> Let's look at the implementations...
>
> #define __pa(x)                 __virt_to_phys((unsigned long)(x))
> static inline phys_addr_t __virt_to_phys(unsigned long x)
> {
>         return (phys_addr_t)x - PAGE_OFFSET + PHYS_OFFSET;
> }
>
> So, __pa() returns a phys_addr_t (which may be either 32-bit or 64-bit).
>
> #define virt_to_pfn(kaddr)  (__pa(kaddr) >> PAGE_SHIFT)
>
> And that will do an appropriate shift to convert the phys_addr_t to a PFN,
> which will be fine to assign to an unsigned long variable.
>
> #define __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
>
> This does the same thing, but has an explicit cast.
>
> So, the only difference between the two suggestions is that additional
> cast, which has no effect here.

Sounds good, thanks!

I was a little unsure about the page sizes that could affect all of
the implementations.

I'll make this change and repost, basically using virt_to_pfn in place
of the previous __pa_symbol, and remove unused declarations.

Thanks again!

Sebastian
