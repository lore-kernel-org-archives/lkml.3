Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaIEQur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:50:47 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55875 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166AbaIEQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:50:46 -0400
Date: Fri, 5 Sep 2014 17:50:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Introduce dummy version of asm/fiq.h
Message-ID: <20140905165033.GD10976@arm.com>
References: <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
 <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org>
 <1409931198-22600-5-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409931198-22600-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:33:17PM +0100, Daniel Thompson wrote:
> Drivers that are shared between arm and arm64 and which employ
> FIQ on arm cannot include asm/fiq.h without #ifdef'ing. This patch
> introduces a dummy version of asm/fiq.h to arm64 to avoid this.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/fiq.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 arch/arm64/include/asm/fiq.h
> 
> diff --git a/arch/arm64/include/asm/fiq.h b/arch/arm64/include/asm/fiq.h
> new file mode 100644
> index 0000000..909ec54
> --- /dev/null
> +++ b/arch/arm64/include/asm/fiq.h
> @@ -0,0 +1,18 @@
> +/*
> + * arch/arm64/include/asm/fiq.h
> + *
> + * Placeholder to reduce #ifdef'ing in shared arm/arm64 drivers.
> + */
> +
> +#ifndef __ASM_FIQ_H
> +#define __ASM_FIQ_H
> +
> +/*
> + * This placeholder allows code of the following form to be simplified:
> + *
> + * #ifdef CONFIG_FIQ
> + * #include <asm/fiq.h>
> + * #endif
> + */
> +
> +#endif

OK, we add a dummy file, but please keep it simple. Comments are fine
but no need for header guards (nor the file name, on arm64 we try to get
rid of them, though some still slip through).

Thanks.

-- 
Catalin
