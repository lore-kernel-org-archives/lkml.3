Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBVKRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:17:11 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46749 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322AbaBVKRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:17:08 -0500
Date: Sat, 22 Feb 2014 10:16:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140222101655.GE21483@n2100.arm.linux.org.uk>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org> <20140219161254.GB19343@e102568-lin.cambridge.arm.com> <20140219193315.3732.21819@capellas-linux> <20140220162754.GC15994@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220162754.GC15994@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 04:27:55PM +0000, Lorenzo Pieralisi wrote:
> I still do not understand why switching to idmap, which is a clone of
> init_mm + 1:1 kernel mappings is required here. Why idmap ?
> 
> And while at it, can't the idmap be overwritten _while_ copying back the
> resume kernel ? Is it safe to use idmap page tables while copying ?
> 
> I had a look at x86 and there idmap page tables used to resume are created
> on the fly using safe pages, on ARM idmap is created at boot.

That's fine.

Remember, you're required to boot exactly the same kernel image when
resuming as the kernel which created the suspend image.  Unless you
have random allocations going on, you should get the same layout for
the idmap stuff at each boot.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
