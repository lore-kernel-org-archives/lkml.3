Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3JaG7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:59:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25958 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3JaG7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:59:48 -0400
X-Spam-Score: -100.8
Message-ID: <5271FFA5.1080909@asianux.com>
Date: Thu, 31 Oct 2013 14:58:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openrisc: include: asm: define empty SERIAL_PORT_DFNS
 in serial.h
References: <5271B83C.50807@asianux.com>
In-Reply-To: <5271B83C.50807@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 09:54 AM, Chen Gang wrote:
> For some architectures (e.g. openrisc, arc), BASE_BAUD isn't constant
> And SERIAL_PORT_DFNS always use BASE_BAUND, and also all drivers use
> SERIAL_PORT_DFNS to initialize static variables, statically.
> 
> So need define SERIAL_PORT_DFNS as empty to tell drivers they don't
> support SERIAL_PORT_DFNS (mostly like frv and parisc did).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/openrisc/include/asm/serial.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/openrisc/include/asm/serial.h b/arch/openrisc/include/asm/serial.h
> index 270a452..254d1ad 100644
> --- a/arch/openrisc/include/asm/serial.h
> +++ b/arch/openrisc/include/asm/serial.h
> @@ -31,6 +31,8 @@
>  
>  #define BASE_BAUD (cpuinfo.clock_frequency/16)
>  
> +#define SERIAL_PORT_DFNS
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __ASM_OPENRISC_SERIAL_H */
> 

Oh, sorry, this patch is incorrect, need fix within the driver.

Thanks.
-- 
Chen Gang
