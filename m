Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaICNA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:00:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60268 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbaICNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:00:24 -0400
Message-ID: <1409749216.21827.62.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/8] ima: simplify conditional statement to improve
 performance
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 03 Sep 2014 09:00:16 -0400
In-Reply-To: <0e28e9a1e1bd839f7d551052b33bba6f266bd749.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
	 <0e28e9a1e1bd839f7d551052b33bba6f266bd749.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090313-7164-0000-0000-000004519E57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 10:19 +0300, Dmitry Kasatkin wrote: 
> Precede bit testing before string comparison makes code
> faster. Also refactor statement as a single line pointer
> assignment.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Functionally the code hasn't change, but the resulting conditional
statement isn't as clear, at least to me, as the original code.  Please
include here in the patch description a short explanation of what the
code is doing.

thanks,

Mimi

> ---
>  security/integrity/ima/ima_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index f82cf9b..f7b85bf 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -206,10 +206,8 @@ static int process_measurement(struct file *file, const char *filename,
>  	}
> 
>  	template_desc = ima_template_desc_current();
> -	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
> -		if (action & IMA_APPRAISE_SUBMASK)
> -			xattr_ptr = &xattr_value;
> -	} else
> +	if ((action & IMA_APPRAISE_SUBMASK) ||
> +		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
>  		xattr_ptr = &xattr_value;
> 
>  	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);


