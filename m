Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaEFUqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:46:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbaEFUqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:46:49 -0400
Date: Tue, 6 May 2014 13:46:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 1/1] arch/unicore32/mm/ioremap.c: convert printk/warn_on
 to warn(1
Message-Id: <20140506134647.8eae8b38be9e503805168b8f@linux-foundation.org>
In-Reply-To: <20140506190734.56036e71639f391e57c6ed00@skynet.be>
References: <20140506190734.56036e71639f391e57c6ed00@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:07:34 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> +coalesce formats
> 
> (This is untested)
> 
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  arch/unicore32/mm/ioremap.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/unicore32/mm/ioremap.c b/arch/unicore32/mm/ioremap.c
> index 13068ee..5d9568c 100644
> --- a/arch/unicore32/mm/ioremap.c
> +++ b/arch/unicore32/mm/ioremap.c
> @@ -143,13 +143,8 @@ void __iomem *__uc32_ioremap_pfn_caller(unsigned long pfn,
>  	/*
>  	 * Don't allow RAM to be mapped
>  	 */
> -	if (pfn_valid(pfn)) {
> -		printk(KERN_WARNING "BUG: Your driver calls ioremap() on\n"
> -			"system memory.  This leads to architecturally\n"
> -			"unpredictable behaviour, and ioremap() will fail in\n"
> -			"the next kernel release. Please fix your driver.\n");
> -		WARN_ON(1);
> -	}
> +	if (pfn_valid(pfn))
> +		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
>  

I don't think that was an improvement.  Particularly with all
those \n's in there.

checkpatch is a just a guide.  It can and should be overruled by common
sense and taste.

--- a/arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix
+++ a/arch/unicore32/mm/ioremap.c
@@ -144,7 +144,10 @@ void __iomem *__uc32_ioremap_pfn_caller(
 	 * Don't allow RAM to be mapped
 	 */
 	if (pfn_valid(pfn))
-		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
+		WARN(1, "BUG: Your driver calls ioremap() on\n"
+			"system memory.  This leads to architecturally\n"
+			"unpredictable behaviour, and ioremap() will fail in\n"
+			"the next kernel release. Please fix your driver.\n");
 
 	type = get_mem_type(mtype);
 	if (!type)
_

