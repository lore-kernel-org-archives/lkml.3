Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaLDKLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:11:33 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44521 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaLDKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:11:27 -0500
Date: Thu, 4 Dec 2014 10:11:31 +0000
From: Will Deacon <will.deacon@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/include/asm: Fixed a warning about 'struct pt_regs'
Message-ID: <20141204101131.GE13224@arm.com>
References: <zcyirq.h>
 <1417674575-10855-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417674575-10855-1-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 06:29:35AM +0000, Chunyan Zhang wrote:
> If I include asm/irq.h on the top of my code, and set ARCH=arm64,
> I'll get a compile warning, details are below:
> warning: ‘struct pt_regs’
> declared inside parameter list [enabled by default]
> 
> This patch is suggested by Arnd, see:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308270.html
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---
>  arch/arm64/include/asm/irq.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
> index e1f7ecd..acedc7e 100644
> --- a/arch/arm64/include/asm/irq.h
> +++ b/arch/arm64/include/asm/irq.h
> @@ -3,6 +3,8 @@
>  
>  #include <asm-generic/irq.h>
>  
> +struct pt_regs;
> +
>  extern void (*handle_arch_irq)(struct pt_regs *);
>  extern void migrate_irqs(void);
>  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));

Fair enough, applied with trivial conflict resolution.

Will
