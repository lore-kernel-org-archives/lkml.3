Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaJ1Mwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:52:37 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57698 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaJ1Mwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:52:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, Neil Zhang <zhangwm@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: ARCH_PFN_OFFSET should be unsigned long
Date: Tue, 28 Oct 2014 13:51:56 +0100
Message-ID: <1971110.TLNM8kRvV0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028123610.GC12136@arm.com>
References: <1414475041-31480-1-git-send-email-zhangwm@marvell.com> <20141028123610.GC12136@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WRmjZeFyE+KeUr7NAxWm/F4V0y2RpUmPHMSv8wvwZJv
 8ZY6wemyq7WLfpT/Wj5J+B3vRcLKj70ZXWX/liY3N6POXX8mQ+
 oWkX/NCHeSxl5DDsihwAi2B08kNhRv5xlZAeSenj6KKm3oXav9
 MW7MuMCikcVZ003c0ghjFRvIRz6Isieg/Jc2VQDrnd8MHG8PQV
 tlCqkPmPHXl+PV6okEx2FMjpSr2L9U/4ZfWw/zwBw4c3lXg8sz
 nRYgCwVkhKQ/sqiQQJ9k6kGFnA9pmPZYQyprPhuRhwE2ToHmbQ
 EtkZtGbKZSaxHKFpiu5euJaNEudBzBEe+ZiBRDoDGzV7/0B71B
 LhZHm2GQ9mk34gRgY120=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 12:36:11 Will Deacon wrote:
> On Tue, Oct 28, 2014 at 05:44:01AM +0000, Neil Zhang wrote:
> > pfns are unsigned long, but PHYS_PFN_OFFSET is phys_addr_t. This leads
> > to page_to_pfn() returning phys_addr_t which cause type mismatches in
> > some print statements.
> 
> Do you have a specific example? Both of those types are 64-bit on arm64.
> 
> 

printf warns about the fact that phys_addr_t is defined as 'u64', which
is 'unsigned long long' rather than 'unsigned long'. It's the same size
but not the same printf format string.

	Arnd
