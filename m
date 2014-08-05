Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaHEJSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:18:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:55693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbaHEJSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:18:49 -0400
Message-ID: <1407230219.3073.5.camel@pasglop>
Subject: Re: [PATCH] arch/powerpc/mm/numa.c: Fix break placement
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: paulus@samba.org, mpe@ellerman.id.au, akpm@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        qiuxishi@huawei.com, wangyun@linux.vnet.ibm.com,
        qiudayu@linux.vnet.ibm.com, joe@perches.com, alistair@popple.id.au,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 05 Aug 2014 19:16:59 +1000
In-Reply-To: <1407183190-1397-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1407183190-1397-1-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 23:13 +0300, Andrey Utkin wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Thanks, I wonder how that managed to remain unnoticed for so long !

Cheers,
Ben.

> ---
>  arch/powerpc/mm/numa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 3b181b2..d3e9a78 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -611,8 +611,8 @@ static int cpu_numa_callback(struct notifier_block *nfb, unsigned long action,
>  	case CPU_UP_CANCELED:
>  	case CPU_UP_CANCELED_FROZEN:
>  		unmap_cpu_from_node(lcpu);
> -		break;
>  		ret = NOTIFY_OK;
> +		break;
>  #endif
>  	}
>  	return ret;


