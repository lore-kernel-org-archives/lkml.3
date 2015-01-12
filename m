Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbbALLy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:54:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59888 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbbALLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:54:23 -0500
Date: Mon, 12 Jan 2015 11:54:15 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: George Bush <georgebush815@gmail.com>
Cc: "sebastian.capella@linaro.org" <sebastian.capella@linaro.org>,
        "Russ.Dill@ti.com" <Russ.Dill@ti.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "victor.kamensky@linaro.org" <victor.kamensky@linaro.org>,
        "r.sricharan@ti.com" <r.sricharan@ti.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "zhou0283@gmail.com" <zhou0283@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARM64: hibernation: How to use hibernation/suspend-to-disk on
 ARMv8?
Message-ID: <20150112115415.GB14519@red-moon>
References: <CADcZZT+nQ_0LfurU+z5wLC_OxNhEs6n0kCoLSkfoFCDqyOu04g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADcZZT+nQ_0LfurU+z5wLC_OxNhEs6n0kCoLSkfoFCDqyOu04g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 03:14:33PM +0000, George Bush wrote:
> Hi all
> 
> I notice we have hibernation.c in arm/kernel, however, I don't find it in arm64.
> Does it mean arm64 do not support hibernation/suspend-to-disk function?

Yes, not at the moment, but we have planned to implement it.

> I tried some path to search the reason, but found nothing, they all say arm64
> has the backward compatibility. So I send this email to the community and
> hope to get the reason.
> Thanks!
> 
> I ported the arm hibernation.c to arm64/kernel(with LP64), but failed in a
> strange way. When I do resume, the arch_restore_image() get a page_fault
> when it calls the copy_page(), like:
> "Unable to handle kernel paging request at virtual address 0xffffffbc055c3fa8"
> I'm sure the copy_page()'s parameters is in the memory area, why and how
> I get the strange address 0xffffffbc055c3fa8?
> 
> vmalloc:         0xffffff8000000000 - 0xffffffbb00000000
> vmemmap:     0xffffffbc01400000 - 0xffffffbc04f88000
> modules:       0xffffffbffc000000   -  0xffffffc000000000
> memory:        0xffffffc000000000 - 0xffffffc0be800000
> 
> 
> Look forward to your reply, thanks!

We need your patch, kernel version, config file, your board/SoC HW details
before even assuming what is happening. Please provide them and I
am happy to help you implement suspend-to-disk on arm64 properly.

Thanks,
Lorenzo
