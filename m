Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3FQIlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:41:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43026 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3FQIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:41:06 -0400
Date: Mon, 17 Jun 2013 09:40:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] arm: Remove sa1111 special case from
	arm_mm_memblock_reserve()
Message-ID: <20130617084033.GC2718@n2100.arm.linux.org.uk>
References: <1371429799-7128-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371429799-7128-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 01:43:19AM +0100, Grant Likely wrote:
> The machine desc structure has a hook for doing machine-specific
> memblock code, but the SA1111 still has a platform-specific hook in the
> generic code. This patch merely moves the needed memblock_reserve()
> into a callback.

And... the reason I left this in generic code was to avoid the problem
which you've created by doing this change - there is at least one PXA
platform which also can have SA1111 enabled, and by omitting this
reservation, you will make that platform blow up at boot time because
we will try and free the same region of RAM twice into the buddy
allocator.

It was left there because one of these currently has to stay in generic
code, so they both need to in order to ensure that both are properly
paired.

What problem, other than a distaste for having such things in generic
code, are you having with this?
