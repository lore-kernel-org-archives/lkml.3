Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3F2PaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 11:30:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59928 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3F2PaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 11:30:03 -0400
Date: Sat, 29 Jun 2013 08:29:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
Message-ID: <20130629152959.GB31339@mtj.dyndns.org>
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I haven't looked at bootmem for a while so could be a bit out of touch
but a couple questions.

On Fri, Jun 28, 2013 at 09:01:03PM -0400, Santosh Shilimkar wrote:
> - Started replacing bootmem_* usage with dirty hacked memblock based API.
> This can be letter wrapped with only needed parameter export.

You can't use memblock directly?

> - Couple of ARM related patch-ups were fine but soon realized that we need
> to patch generic kernel multiple places .. So decided to stop and check again
> These changes are becoming too much...

I suppose LPAE on arm is analogous to PAE on x86, IOW, high memory?
This does affect memory initilization as you need to register memory
areas which aren't addressable directly; however, why does it affect
generic code which is just allocating memory?  Note that x86 already
does highmem and the existing code works fine.  Once all bootmem users
are gone, we can remove the bootmem wrappers but I don't what the
point is with introducing yet another wrapper.

Thanks.

-- 
tejun
