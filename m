Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3IFW0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:26:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3IFW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:26:14 -0400
Date: Fri, 6 Sep 2013 23:20:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: behanw@converseincode.com
Cc: Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] arm: LLVMLinux: Add current_stack_pointer macro
	for ARM
Message-ID: <20130906222027.GR6617@n2100.arm.linux.org.uk>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com> <1378502899-1241-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378502899-1241-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:28:07PM -0400, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> A macro to get the current stack pointer which allows for a single place in
> which to do so with ASM. Before this named registers (a gcc extension) was used
> to get the stack pointer. Using ASM is a more portable way of getting the stack
> pointer which works with both gcc and clang.  This macro is of the same name
> used in the X86 arch.

This will result in less optimal code - rather than the compiler being
able to mask directly with 'sp', it's going to have to use this bit of
assembly to first move it into another register.

Why do we want this change?
