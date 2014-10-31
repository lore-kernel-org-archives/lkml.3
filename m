Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbaJaKnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:43:13 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:51398 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaJaKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:43:12 -0400
Date: Fri, 31 Oct 2014 10:43:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V6 3/3] arm64:add bitrev.h file to support rbit instruction
Message-ID: <20141031104305.GC6731@arm.com>
References: <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18274@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D18274@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 05:41:48AM +0000, Wang, Yalin wrote:
> This patch add bitrev.h file to support rbit instruction,
> so that we can do bitrev operation by hardware.
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  arch/arm64/Kconfig              |  1 +
>  arch/arm64/include/asm/bitrev.h | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
>  create mode 100644 arch/arm64/include/asm/bitrev.h
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d..b1ec1dd 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -35,6 +35,7 @@ config ARM64
>  	select HANDLE_DOMAIN_IRQ
>  	select HARDIRQS_SW_RESEND
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select HAVE_ARCH_BITREVERSE
>  	select HAVE_ARCH_JUMP_LABEL
>  	select HAVE_ARCH_KGDB
>  	select HAVE_ARCH_TRACEHOOK
> diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
> new file mode 100644
> index 0000000..706a209
> --- /dev/null
> +++ b/arch/arm64/include/asm/bitrev.h
> @@ -0,0 +1,21 @@
> +#ifndef __ASM_ARM64_BITREV_H
> +#define __ASM_ARM64_BITREV_H

Really minor nit, but we don't tend to include 'ARM64' in our header guards,
so this should just be __ASM_BITREV_H.

With that change,

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
