Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaEAQ2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:28:07 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30123 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850AbaEAQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:28:04 -0400
Date: Thu, 1 May 2014 17:27:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 15/21] of/fdt: move memreserve and dtb memory
 reservations into core
Message-ID: <20140501162729.GA28745@arm.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
 <1398215901-25609-16-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398215901-25609-16-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 08:18:15PM -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Move the /memreserve/ processing and dtb memory reservations into
> early_init_fdt_scan_reserved_mem. This converts arm, arm64, and powerpc
> as they are the only users of early_init_fdt_scan_reserved_mem.
> 
> memblock_reserve is safe to call on the same region twice, so the
> reservation check for the dtb in powerpc 32-bit reservations is safe to
> remove.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
> v2: No change
> 
>  arch/arm/include/asm/prom.h |  2 --
>  arch/arm/kernel/devtree.c   | 27 ---------------------------
>  arch/arm/mm/init.c          |  1 -
>  arch/arm64/mm/init.c        | 21 ---------------------
>  arch/powerpc/kernel/prom.c  | 22 ----------------------
>  drivers/of/fdt.c            | 16 ++++++++++++++++
>  6 files changed, 16 insertions(+), 73 deletions(-)

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
