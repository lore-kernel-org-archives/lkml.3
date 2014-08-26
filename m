Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaHZJHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:07:16 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58021 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaHZJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:07:13 -0400
Date: Tue, 26 Aug 2014 10:07:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lgirdwood@gmail.com,
        broonie@kernel.org, grant.likely@linaro.org, khilman@linaro.org,
        haojian.zhuang@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        axel.lin@ingics.com, zhangnian@huawei.com
Subject: Re: [PATCH v6 4/6] mfd: Add hi6421 PMIC core driver
Message-ID: <20140826090706.GF9574@lee--X1>
References: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
 <1408367356-2628-5-git-send-email-guodong.xu@linaro.org>
 <20140820080912.GG4266@lee--X1>
 <53FAFF03.1000301@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FAFF03.1000301@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Guodong Xu wrote:
> On 08/20/2014 04:09 PM, Lee Jones wrote:
> > On Mon, 18 Aug 2014, Guodong Xu wrote:
> >> This adds driver to support HiSilicon Hi6421 PMIC. Hi6421 includes multi-
> >> functions, such as regulators, codec, ADCs, Coulomb counter, etc.
> >> This driver includes core APIs _only_.
> >>
> >> Drivers for individul components, like voltage regulators, are
> >> implemented in corresponding driver directories and files.
> >>
> >> Registers in Hi6421 are memory mapped, so using regmap-mmio API.
> >>
> >> Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
> >> ---
> >>  Documentation/devicetree/bindings/mfd/hi6421.txt |  37 +++++++

[...]

> >> + * Author: Guodong Xu <guodong.xu@linaro.org>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> > 
> > This should also contain a link to the full licence.
> > 
> > See: COPYING
> > 
> 
> Thanks. I checked COPYING, but there is no 'link' to full license. I

I was making reference to the fact that COPYING tells you to provide a
link to the full notice:

"To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found."

> copied a link from other c source: http://www.gnu.org/licenses/
> is that OK?

Yes, that's fine.

> >> +	platform_set_drvdata(pdev, pmic);
> > 
> > It's not _that_ important, but I like to see this at the end after you
> > know everything else has succeeded.
> 
> When I move this after mfd_add_devices(), it fails to boot. In mfd
> devices's probe, pmic->regmap is used.

You can move it to just before mfd_add_devices().

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
