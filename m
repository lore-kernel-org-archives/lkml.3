Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaCRKtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:49:15 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56756 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753829AbaCRKtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:49:13 -0400
Date: Tue, 18 Mar 2014 10:48:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Liu Hua <sdu.liu@huawei.com>
Cc: wangnan0@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peifeiyue@huawei.com
Subject: Re: [PATCH] ARM: kdump: Avoid overflow when converting pfn to
	physaddr
Message-ID: <20140318104855.GU21483@n2100.arm.linux.org.uk>
References: <1395138042-62364-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395138042-62364-1-git-send-email-sdu.liu@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 06:20:42PM +0800, Liu Hua wrote:
> When we configure CONFIG_LPAE=y, pfn << PAGE_SHIFT will
> overflow if pfn >= 0x100000 in copy_oldmem_page.
> 
> So use __pfn_to_phys for converting.

Yes.  The sad thing is that if you grep the kernel for similar things,
it's littered with this problem.  I'm not sure whether anyone
particularly "owns" the crash_dump.c file - Mika Westerberg and
Olaf Hering were the last two to touch it... I guess put this in my
patch system please.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
