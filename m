Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaDASDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:03:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40505 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDASDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:03:39 -0400
Message-ID: <533AFF77.5030106@codeaurora.org>
Date: Tue, 01 Apr 2014 11:03:35 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>,
        linux-arm-kernel@lists.infradead.org
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if CONFIG_JUMP_LABEL
 is enabled
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2014 3:04 AM, Alexander Holler wrote:
> CONFIG_DEBUG_SET_MODULE_RONX sounds like a nice security feature, but
> things might fail late (and unexpected) if module code is set to read-only
> while CONFIG_JUMP_LABEL is enabled (e.g. modprobe bridge).
> 
> Avoid this.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  arch/arm/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 0531da8..6627b9e 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1197,7 +1197,7 @@ config PID_IN_CONTEXTIDR
>  
>  config DEBUG_SET_MODULE_RONX
>  	bool "Set loadable kernel module data as NX and text as RO"
> -	depends on MODULES
> +	depends on MODULES && !JUMP_LABEL
>  	---help---
>  	  This option helps catch unintended modifications to loadable
>  	  kernel module's text and read-only data. It also prevents execution
> 

Kees Cook has something similar[1] for not-module space as well, we probably want
this there as well. A shame we keep finding reasons these features will be turned
off. Looks good to me otherwise. 

Laura

[1]http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/232644.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
