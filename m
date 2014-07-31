Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaGaKr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:47:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56849 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaGaKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:47:24 -0400
Date: Thu, 31 Jul 2014 11:46:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/ARM64: don't enter kgdb when userspace executes a
 kgdb break instruction.
Message-ID: <20140731104653.GM26853@arm.com>
References: <20140730071245.GA8954@mew.web-pass.com>
 <20140730112414.GJ12239@arm.com>
 <20140731053323.GA15523@mew.web-pass.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731053323.GA15523@mew.web-pass.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:33:23AM +0100, Omar Sandoval wrote:
> Hi,

Hi Omar,

> On Wed, Jul 30, 2014 at 12:24:14PM +0100, Will Deacon wrote:
> > Whilst this sounds like a worrying problem, I've failed to reproduce it
> > on arm64.  Executing a brk instruction with either KGDB_DYN_DGB_BRK_IMM or
> > KDBG_COMPILED_DBG_BRK_IMM immediates from userspace results in a SIGTRAP being
> > delivered, assumedly because kgdb_handle_exception simply returns when kgdb
> > isn't active.
> 
> From what I can tell, the break hooks are registered so long as kgdb is enabled
> at all - i.e., the kernel was compiled with CONFIG_KGDB=y and, for example,
> CONFIG_KGDB_SERIAL_CONSOLE=y and kgdboc was passed on the kernel command line.
> kgdb_handle_exception doesn't seem to check whether the debugger is active.
> 
> > The following (totally untested) diff is simpler for arm64, but again, I'm
> > not sure we even have a problem here.
> 
> This diff also fixes the problem. I don't have a strong preference for either
> approach, so I can revise the patch with this approach instead if you'd prefer
> that.

I'll merge the arm64 diff I proposed. Could you repost the ARM part please?

> > On which systems have you managed to reproduce this and how?
> 
> I first reproduced this on a Raspberry Pi. The recommended distro, Raspbian,
> distributes a kernel compiled with CONFIG_KGDB=y, CONFIG_KGDB_KDB=y, and
> CONFIG_KDB_KEYBOARD=y, so it was sufficient to have a keyboard plugged in.
> However, I also reproduced it by booting with kgdboc on the command line, as
> CONFIG_KGDB_SERIAL_CONSOLE was also enabled. Additionally, I reproduced it and
> then verified that my patch fixed it on self-compiled kernels.

I think enabling and activating kgdb by default is a pretty crazy thing to
do, but I agree that we shouldn't allow userspace to trap into it either.

Once you repost the ARM patches, we can look at getting them merged via rmk.

Cheers,

Will
