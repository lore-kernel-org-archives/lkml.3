Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaJANWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:22:14 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40093 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJANWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:22:12 -0400
Date: Wed, 1 Oct 2014 14:22:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 16/24] ARM64:ILP32: Support core dump for ILP32
Message-ID: <20141001132202.GL12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-17-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-17-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:10PM +0100, Andrew Pinski wrote:
> +/*
> + * If ILP32 is turned on, we want to define the compat_elf_greg_t to the non compat
> + * one and define PR_REG_SIZE/PRSTATUS_SIZE/SET_PR_FPVALID so we pick up the correct
> + * ones for AARCH32.
> + */
> +#ifdef CONFIG_ARM64_ILP32
> +typedef elf_greg_t			compat_elf_greg_t;
> +typedef elf_gregset_t			compat_elf_gregset_t;
> +#define COMPAT_PR_REG_SIZE(S)		(is_a32_compat_task() ? 72 : 272)
> +#define COMPAT_PRSTATUS_SIZE(S)		(is_a32_compat_task() ? 124 : 352)

Could you not use some sizeof() here instead of these magic numbers?

-- 
Catalin
