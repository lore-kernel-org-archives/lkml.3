Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaAIAwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:52:01 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8211 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756820AbaAIAv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:51:59 -0500
Date: Wed, 8 Jan 2014 16:53:33 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/6] ARM: Add Krait L2 accessor functions
Message-ID: <20140109005332.GB23276@sonymobile.com>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1388434457-4194-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 09:14:14PM +0100, Stephen Boyd wrote:
> Krait CPUs have a handful of L2 cache controller registers that
> live behind a cp15 based indirection register. First you program
> the indirection register (l2cpselr) to point the L2 'window'
> register (l2cpdr) at what you want to read/write.  Then you
> read/write the 'window' register to do what you want. The
> l2cpselr register is not banked per-cpu so we must lock around
> accesses to it to prevent other CPUs from re-pointing l2cpdr
> underneath us.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/common/Kconfig                   |  3 ++
>  arch/arm/common/Makefile                  |  1 +
>  arch/arm/common/krait-l2-accessors.c      | 58 +++++++++++++++++++++++++++++++
>  arch/arm/include/asm/krait-l2-accessors.h | 20 +++++++++++
>  4 files changed, 82 insertions(+)
>  create mode 100644 arch/arm/common/krait-l2-accessors.c
>  create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
[...]
> +
> +extern void set_l2_indirect_reg(u32 addr, u32 val);
> +extern u32 get_l2_indirect_reg(u32 addr);

As these are Krait specific, please rename the functions to reflect
this.

-Courtney
