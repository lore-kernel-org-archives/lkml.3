Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3GBRyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:54:03 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60248 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3GBRyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:54:00 -0400
Date: Tue, 2 Jul 2013 13:53:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Joseph Lo <josephl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 07/32] arm: delete __cpuinit/__CPUINIT usage from all ARM
 users
Message-ID: <20130702175257.GC21817@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-8-git-send-email-paul.gortmaker@windriver.com>
 <1372755120.2874.18.camel@jlo-ubuntu-64.nvidia.com>
 <20130702085818.GD24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130702085818.GD24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 07/32] arm: delete __cpuinit/__CPUINIT usage from all ARM users] On 02/07/2013 (Tue 09:58) Russell King - ARM Linux wrote:

> On Tue, Jul 02, 2013 at 04:52:00PM +0800, Joseph Lo wrote:
> > I just tested this series on Tegra platform. It looks broken CPU hotplug
> > function for Tegra at least. The CPU can't plug-in after unplugging. And
> > the system resume function also not working when "enable_nonboot_cpus".
> > 
> > Both of the issue cause system hang up. Are we missing something for
> > __cpuinit removal work?
> 
> Check that any assembly code you're using where the __CPUINIT* marker has
> been removed is not preceded by an __INIT or similar.   This code needs
> to end up in the normal .text, .data or .bss sections now.

Yes, As Russell says it is entirely possible that the earlier section
was __INIT and there was already a missing __FINIT (or .previous).

Hence what was __cpuinit got grandfathered into __INIT instead of
.text/.data/.bss

I'm offline at the moment but will double check myself later this
evening if nothing obvious has been found by then.

Thanks,
Paul.
--
