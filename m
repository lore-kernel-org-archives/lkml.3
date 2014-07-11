Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaGKV7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:59:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaGKV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:59:40 -0400
Message-ID: <53C05E4A.2030708@codeaurora.org>
Date: Fri, 11 Jul 2014 14:59:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/3] asm-generic/io.h: Implement generic {read,write}s*()
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 08:31, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> This patch implements generic versions of readsb(), readsw(), readsl(),
> readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> these string functions for I/O accesses (ins*() and outs*() as well as
> ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> new functions.
>
> While at it, also make sure that any of the functions provided as
> fallback for architectures that don't override them can't be overridden
> subsequently.
>
> This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> find or build a cross-compiler that would run on my system. But by code
> inspection they shouldn't break with this patch.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

There isn't any mention of why we're doing this in the commit text. It
looks like patch 2 and 3 sort of mention why.

I also wonder if it could be explained how this about turn is desired,
given that patch b2656a138ab7 (asm-generic: io: remove {read,write}
string functions, 2012-10-17) did the complete opposite. Can you please
explain?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

