Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaBRXtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:49:12 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59543 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaBRXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:49:07 -0500
Date: Tue, 18 Feb 2014 18:49:04 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Laura Abbott <lauraa@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
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
        Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv4 2/2] arm: Get rid of meminfo
In-Reply-To: <20140218230710.GO21483@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1402181848140.17677@knanqh.ubzr>
References: <1392761733-32628-1-git-send-email-lauraa@codeaurora.org> <1392761733-32628-3-git-send-email-lauraa@codeaurora.org> <20140218230710.GO21483@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Russell King - ARM Linux wrote:

> On Tue, Feb 18, 2014 at 02:15:33PM -0800, Laura Abbott wrote:
> > memblock is now fully integrated into the kernel and is the prefered
> > method for tracking memory. Rather than reinvent the wheel with
> > meminfo, migrate to using memblock directly instead of meminfo as
> > an intermediate.
> 
> >  #define NR_BANKS	CONFIG_ARM_NR_BANKS
> >  
> > -struct membank {
> > -	phys_addr_t start;
> > -	phys_addr_t size;
> > -	unsigned int highmem;
> > -};
> > -
> > -struct meminfo {
> > -	int nr_banks;
> > -	struct membank bank[NR_BANKS];
> > -};
> 
> Doesn't this make NR_BANKS (and CONFIG_ARM_NR_BANKS) unused?

Still used in atag_to_fdt.c but I just sent a patch moving it there.


Nicolas
