Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaAWNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:16:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50396 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaAWNQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:16:25 -0500
Date: Thu, 23 Jan 2014 13:16:21 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        patches@opensource.wolfsonmicro.com, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 19/73] arm: mach-s3c64xx mach-crag6410-module.c is not
	modular
Message-ID: <20140123131621.GD11589@opensource.wolfsonmicro.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-20-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-20-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:22:22PM -0500, Paul Gortmaker wrote:
> Despite the name mach-crag6410-module.c, the code is built for
> MACH_WLF_CRAGG_6410 -- which is bool, and hence this code is
> either present or absent.  It will never be modular, so using
> module_init as an alias for __initcall can be somewhat
> misleading.
> 
> Fix this up now, so that we can relocate module_init from
> init.h into module.h in the future.  If we don't do this, we'd
> have to add module.h to obviously non-modular code, and that
> would be a worse thing.
> 
> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of device_initcall
> directly in this change means that the runtime impact is
> zero -- it will remain at level 6 in initcall ordering.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: patches@opensource.wolfsonmicro.com
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

Tested-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
