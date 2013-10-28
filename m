Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3J1EKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:10:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36664 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3J1EKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:10:47 -0400
X-Spam-Score: -100.8
Message-ID: <526DE389.30404@asianux.com>
Date: Mon, 28 Oct 2013 12:09:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: export symbol for pm_power_off in reset.c
References: <526DDEDB.4030503@asianux.com>
In-Reply-To: <526DDEDB.4030503@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



After this patch, and with limitations below, arc finishes allmodconfig.

 - with EXTRA_CFLAGS=-mmedium-calls.

 - disable CONFIG_CC_OPTIMIZE_FOR_SIZE.

 - by pass 5-7 gcc issues (4-5 may duplicate).

 - by pass 1 binutils issue (when disable CONFIG_CC_OPTIMIZE_FOR_SIZE).


Next (within 2013-10-31) I will/should:

 - shrink cross-compilers information, at least.

 - finish the patch for "portable assembler code - newline"


Left:

 - it also content sevaval warnings (even not use "EXTRA_CFLAGS=-W").

 - for next-20130927 tree, arc can not pass defconfig, either.

 - not let it run under kvm (I don't know whether we support kvm).


Thanks.

On 10/28/2013 11:49 AM, Chen Gang wrote:
> Need export symbol for it, or can not pass compiling, the related error
> with allmodconfig: 
> 
>     MODPOST 2994 modules
>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>   ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arc/kernel/reset.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arc/kernel/reset.c b/arch/arc/kernel/reset.c
> index e227a2b..2768fa1 100644
> --- a/arch/arc/kernel/reset.c
> +++ b/arch/arc/kernel/reset.c
> @@ -31,3 +31,4 @@ void machine_power_off(void)
>  }
>  
>  void (*pm_power_off) (void) = NULL;
> +EXPORT_SYMBOL(pm_power_off);
> 


-- 
Chen Gang
