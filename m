Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200AbaFRIvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:51:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20636 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934104AbaFRIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:51:38 -0400
Date: Wed, 18 Jun 2014 09:51:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/24] ARM64:ILP32: Use the same syscall names as LP64.
Message-ID: <20140618085124.GA11977@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-10-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-10-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:04AM -0700, Andrew Pinski wrote:
> diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
> index 1caadc2..067eab0 100644
> --- a/arch/arm64/include/uapi/asm/unistd.h
> +++ b/arch/arm64/include/uapi/asm/unistd.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2012 ARM Ltd.
> + * Copyright (C) 2014 Cavium Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -13,4 +14,10 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +
> +/* For ILP32 AARCH64, we want to use the non compat names. */
> +#if defined(__aarch64__) && defined(__ILP32__)

Another inconsistency for !__LP64__ vs __ILP32__. BTW, do we still need
__aarch64__ check? Do we expect these headers to be used with AArch32?

> +#define __SYSCALL_NONCOMPAT

As I mentioned in a previous patch, I prefer something like
__ARCH_WANT...

-- 
Catalin
