Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaDYK22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:28:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49615 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751563AbaDYK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:28:24 -0400
Date: Fri, 25 Apr 2014 11:27:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 6/7] ARM: rtc: update CMOS RTC to support MMIO and
	private lock
Message-ID: <20140425102732.GI26756@n2100.arm.linux.org.uk>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com> <1398418275-9671-7-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398418275-9671-7-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:31:14AM +0100, Marc Zyngier wrote:
> So far, the CMOS RTC (PC-style mc146818) has always been used
> through an ISA I/O port of some sort, with each platform configuring
> the address in a static way.
> 
> Some platforms (KVM with kvmtools, for example) offer a MMIO version
> of the CMOS RTC, which requires a different access method.
> 
> This patch select the RTC_DRV_CMOS_MMIO configuration in order to
> support MMIO accesses as well as the older IO port method.
> 
> While we're at it, switch to RTC_DRV_CMOS_PRIV_LOCK and remove the
> ancient rtc_lock.

rtc_lock is there so that if you build the RTC driver and nvram driver
in, and load them, they will both want to access the RTC via its
indexed registers, and they need to share the lock to avoid trampling
on each others toes.

Yes, it should be handled in a more modern way, but I don't think you
can simply get rid of this in this manner.  We can have both these
drivers loaded on ARM platforms.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
