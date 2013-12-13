Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3LMJ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:58:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55070 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3LMJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:58:08 -0500
Date: Fri, 13 Dec 2013 09:56:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, ulli.kroll@googlemail.com, arnd@arndb.de,
        olof@lixom.net
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Message-ID: <20131213095655.GB4360@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 09:09:09AM +0100, Jonas Jensen wrote:
> CPU_FA526 lacks thumb state support and doesn't get along with some
> of the options enabled by ARCH_MULTI_V4T.
> 
> More specifically it doesn't get along with CPU_ARM920T:
> 
> CPU_ABRT_EV4T
> CPU_CACHE_V4WT
> CPU_COPY_V4WB
> CPU_TLB_V4WBI

Having these selected doesn't change how the kernel is compiled or how
the kernel uses the code which these provide.  These mainly control
which files are built.

They also control indirectly how the code is called - but the ultimate
decision is made by the CPU which is detected and the block in
__fa526_proc_info.

So, having these symbols enabled (provided the right ones for FA526 are
also enabled) makes no difference.  So I don't buy your explanation.
