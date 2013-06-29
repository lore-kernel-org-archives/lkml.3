Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3F2RWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 13:22:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35047 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3F2RWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 13:22:09 -0400
Date: Sat, 29 Jun 2013 18:21:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
Message-ID: <20130629172123.GA3353@n2100.arm.linux.org.uk>
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com> <20130629152959.GB31339@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629152959.GB31339@mtj.dyndns.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 08:29:59AM -0700, Tejun Heo wrote:
> I suppose LPAE on arm is analogous to PAE on x86, IOW, high memory?
> This does affect memory initilization as you need to register memory
> areas which aren't addressable directly; however, why does it affect
> generic code which is just allocating memory?  Note that x86 already
> does highmem and the existing code works fine.  Once all bootmem users
> are gone, we can remove the bootmem wrappers but I don't what the
> point is with introducing yet another wrapper.

The reason is actually quite simple: on x86 you always have memory
starting at physical address zero.

Unfortunately, that has not been true on ARM - it's very common for
there to be an offset on physical memory, sometimes of the order of
3GB or more.  This is because on reset, ARMs start executing the code
at physical address zero, which therefore can't be RAM - and there's
a desire to avoid complex switching games in hardware to temporarily
map ROM there instead of RAM.

On these SoCs which Santosh is working on, the main physical memory
mapping is above 4GB, with just a small alias below 4GB to allow the
system to boot without the MMU being on, as they may have more than
4GB of RAM.  As I understand it, the small alias below 4GB is not
suitable for use as a "lowmem" mapping.
