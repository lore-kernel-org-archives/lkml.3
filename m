Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaJ1NhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:37:06 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49729 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJ1NhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:37:02 -0400
Date: Tue, 28 Oct 2014 13:36:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "zhangwm@marvell.com" <zhangwm@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: ARCH_PFN_OFFSET should be unsigned long
Message-ID: <20141028133651.GA29706@arm.com>
References: <1414475041-31480-1-git-send-email-zhangwm@marvell.com>
 <20141028123610.GC12136@arm.com>
 <1971110.TLNM8kRvV0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1971110.TLNM8kRvV0@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:51:56PM +0000, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 12:36:11 Will Deacon wrote:
> > On Tue, Oct 28, 2014 at 05:44:01AM +0000, Neil Zhang wrote:
> > > pfns are unsigned long, but PHYS_PFN_OFFSET is phys_addr_t. This leads
> > > to page_to_pfn() returning phys_addr_t which cause type mismatches in
> > > some print statements.
> > 
> > Do you have a specific example? Both of those types are 64-bit on arm64.
> > 
> > 
> 
> printf warns about the fact that phys_addr_t is defined as 'u64', which
> is 'unsigned long long' rather than 'unsigned long'. It's the same size
> but not the same printf format string.

Ok, fair enough. I'll let Catalin pick this up for 3.18.

Will
