Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3K0PCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:02:38 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:44322 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3K0PCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:02:35 -0500
Date: Wed, 27 Nov 2013 16:01:09 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Roberto Sassu <roberto.sassu@polito.it>
cc: jmorris@namei.org, zohar@linux.vnet.ibm.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ima: store address of template_fmt_copy in a pointer
 before calling strsep
In-Reply-To: <1385559644-9217-1-git-send-email-roberto.sassu@polito.it>
Message-ID: <alpine.LFD.2.10.1311271600400.3966@c4eb>
References: <5295E9B3.202@polito.it> <1385559644-9217-1-git-send-email-roberto.sassu@polito.it>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112715-5024-0000-0000-000007F5BF95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Nov 2013, Roberto Sassu wrote:
> This patch stores the address of the 'template_fmt_copy' variable in a new
> variable, called 'template_fmt_ptr', so that the latter is passed as an
> argument of strsep() instead of the former. This modification is needed
> in order to correctly free the memory area referenced by
> 'template_fmt_copy' (strsep() modifies the pointer of the passed string).
> 

This one helped. Thanks!

Sebastian

> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
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
> -- 
> 1.8.1.4
> 
> 

