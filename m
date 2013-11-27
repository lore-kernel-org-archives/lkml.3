Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3K0Oz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:55:28 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55025 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3K0OzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:55:24 -0500
Message-ID: <1385564119.5459.1.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] ima: store address of template_fmt_copy in a pointer
 before calling strsep
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: jmorris@namei.org, sebott@linux.vnet.ibm.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Nov 2013 09:55:19 -0500
In-Reply-To: <1385559644-9217-1-git-send-email-roberto.sassu@polito.it>
References: <5295E9B3.202@polito.it>
	 <1385559644-9217-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112714-3532-0000-0000-0000035E5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 14:40 +0100, Roberto Sassu wrote:
> This patch stores the address of the 'template_fmt_copy' variable in a new
> variable, called 'template_fmt_ptr', so that the latter is passed as an
> argument of strsep() instead of the former. This modification is needed
> in order to correctly free the memory area referenced by
> 'template_fmt_copy' (strsep() modifies the pointer of the passed string).
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/integrity/ima/ima_template.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index 913e192..635695f 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -110,7 +110,7 @@ static int template_desc_init_fields(const char *template_fmt,
>  				     struct ima_template_field ***fields,
>  				     int *num_fields)
>  {
> -	char *c, *template_fmt_copy;
> +	char *c, *template_fmt_copy, *template_fmt_ptr;
>  	int template_num_fields = template_fmt_size(template_fmt);
>  	int i, result = 0;
> 
> @@ -127,7 +127,9 @@ static int template_desc_init_fields(const char *template_fmt,
>  		result = -ENOMEM;
>  		goto out;
>  	}
> -	for (i = 0; (c = strsep(&template_fmt_copy, "|")) != NULL &&
> +
> +	template_fmt_ptr = template_fmt_copy;
> +	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
>  	     i < template_num_fields; i++) {
>  		struct ima_template_field *f = lookup_template_field(c);
> 


