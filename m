Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaBRXHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:07:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41678 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754128AbaBRXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:07:38 -0500
Date: Tue, 18 Feb 2014 23:07:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv4 2/2] arm: Get rid of meminfo
Message-ID: <20140218230710.GO21483@n2100.arm.linux.org.uk>
References: <1392761733-32628-1-git-send-email-lauraa@codeaurora.org> <1392761733-32628-3-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392761733-32628-3-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:15:33PM -0800, Laura Abbott wrote:
> memblock is now fully integrated into the kernel and is the prefered
> method for tracking memory. Rather than reinvent the wheel with
> meminfo, migrate to using memblock directly instead of meminfo as
> an intermediate.

>  #define NR_BANKS	CONFIG_ARM_NR_BANKS
>  
> -struct membank {
> -	phys_addr_t start;
> -	phys_addr_t size;
> -	unsigned int highmem;
> -};
> -
> -struct meminfo {
> -	int nr_banks;
> -	struct membank bank[NR_BANKS];
> -};

Doesn't this make NR_BANKS (and CONFIG_ARM_NR_BANKS) unused?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
