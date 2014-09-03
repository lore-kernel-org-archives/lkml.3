Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaICONm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:13:42 -0400
Received: from fm1nodo1.polito.it ([130.192.180.11]:56479 "EHLO
	antispam.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495AbaICONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:13:40 -0400
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <54071B91.4020404@polito.it>
Date: Wed, 03 Sep 2014 15:45:53 +0200
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dmitry Kasatkin <d.kasatkin@samsung.com>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [Linux-ima-devel] [PATCH 8/8] ima: initialize only required template
References: <cover.1409728712.git.d.kasatkin@samsung.com> <ee009655866311106c98cdf87371d52f242782af.1409728712.git.d.kasatkin@samsung.com>
In-Reply-To: <ee009655866311106c98cdf87371d52f242782af.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 09:20 AM, Dmitry Kasatkin wrote:
> IMA uses only one template. This patch initializes only required
> template to avoid unnecessary memory allocations.
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>   security/integrity/ima/ima_template.c | 28 ++++------------------------
>   1 file changed, 4 insertions(+), 24 deletions(-)
>
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index f682606..e854862 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -152,24 +152,6 @@ out:
>   	return result;
>   }
>
> -static int __init init_defined_templates(void)
> -{
> -	int i = 0;
> -	int result = 0;
> -
> -	/* Init defined templates. */
> -	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
> -		struct ima_template_desc *template = &defined_templates[i];
> -
> -		result = template_desc_init_fields(template->fmt,
> -						   &(template->fields),
> -						   &(template->num_fields));
> -		if (result < 0)
> -			return result;
> -	}
> -	return result;
> -}
> -
>   struct ima_template_desc *ima_template_desc_current(void)
>   {
>   	if (!ima_template)
> @@ -180,11 +162,9 @@ struct ima_template_desc *ima_template_desc_current(void)
>
>   int __init ima_init_template(void)
>   {
> -	int result;
> -
> -	result = init_defined_templates();
> -	if (result < 0)
> -		return result;
> +	struct ima_template_desc *template = ima_template_desc_current();
>
> -	return 0;
> +	return template_desc_init_fields(template->fmt,
> +					 &(template->fields),
> +					 &(template->num_fields));

Hi Dmitry

ok, I'm fine with the change even if the template
initialization routine will be used for other purposes
(array items will be added in a linked list to permit
templates dynamic registration).

Thanks

Roberto Sassu


>   }
>

