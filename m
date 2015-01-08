Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbbAHWmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:42:05 -0500
Received: from ozlabs.org ([103.22.144.67]:60737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbbAHWmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:42:03 -0500
Message-ID: <1420756921.1211.14.camel@neuling.org>
Subject: Re: [PATCH] cxl: remove redundant increment of hwirq
From: Michael Neuling <mikey@neuling.org>
To: Colin King <colin.king@canonical.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Jan 2015 09:42:01 +1100
In-Reply-To: <1420756607-23459-1-git-send-email-colin.king@canonical.com>
References: <1420756607-23459-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 22:36 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> hwirq has not been initialized, however it is being incremented
> and also not being referenced in a loop.  This error was detected with
> cppcheck:
> 
> [drivers/misc/cxl/irq.c:439]: (error) Uninitialized variable: hwirq
> 
> Commit 80fa93fce37d ("cxl: Name interrupts in /proc/interrupt") 
> introduced this error.
> 
> This is a simple fix that removes the redundant increment.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks.  Looks good.

Acked-By: Michael Neuling <mikey@neuling.org>

> ---
>  drivers/misc/cxl/irq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
> index c294925..68ab608 100644
> --- a/drivers/misc/cxl/irq.c
> +++ b/drivers/misc/cxl/irq.c
> @@ -436,7 +436,7 @@ int afu_register_irqs(struct cxl_context *ctx, u32 count)
>  	 */
>  	INIT_LIST_HEAD(&ctx->irq_names);
>  	for (r = 1; r < CXL_IRQ_RANGES; r++) {
> -		for (i = 0; i < ctx->irqs.range[r]; hwirq++, i++) {
> +		for (i = 0; i < ctx->irqs.range[r]; i++) {
>  			irq_name = kmalloc(sizeof(struct cxl_irq_name),
>  					   GFP_KERNEL);
>  			if (!irq_name)

