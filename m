Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3LINfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:35:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34401 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3LINfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:35:00 -0500
Message-ID: <1386596095.23828.29.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH-v2 2/6] ima: added new template helper
 lookup_template_desc_by_fmt()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Mon, 09 Dec 2013 08:34:55 -0500
In-Reply-To: <1384864428-3895-3-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
	 <1384864428-3895-3-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120913-0928-0000-0000-000004788EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 13:33 +0100, Roberto Sassu wrote: 
> This patch adds a new helper to search a template descriptor by its format.

The initial template and larger hash digest patch set was quite large.
In order not to break backward compatibility and move forward, functions
were added before they were actually used.  For future reference, we
normally define new functions and use them in the same patch.

thanks,

Mimi

> Also, the old function lookup_template_desc(), which performs the search
> by name, has been renamed to lookup_template_desc_by_name().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/integrity/ima/ima_template.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index 33c911a..c849723 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -38,7 +38,7 @@ static struct ima_template_field supported_fields[] = {
>  };
> 
>  static struct ima_template_desc *ima_template;
> -static struct ima_template_desc *lookup_template_desc(const char *name);
> +static struct ima_template_desc *lookup_template_desc_by_name(const char *name);
>  static struct ima_template_field *lookup_template_field(const char *field_id);
> 
>  static int __init ima_template_setup(char *str)
> @@ -53,7 +53,7 @@ static int __init ima_template_setup(char *str)
>  	 * Verify that a template with the supplied name exists.
>  	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
>  	 */
> -	template_desc = lookup_template_desc(str);
> +	template_desc = lookup_template_desc_by_name(str);
>  	if (!template_desc) {
>  		pr_err("IMA: template %s not found, using %s\n",
>  		       str, CONFIG_IMA_DEFAULT_TEMPLATE);
> @@ -117,7 +117,7 @@ static int __init ima_template_fmt_setup(char *str)
>  }
>  __setup("ima_template_fmt=", ima_template_fmt_setup);
> 
> -static struct ima_template_desc *lookup_template_desc(const char *name)
> +static struct ima_template_desc *lookup_template_desc_by_name(const char *name)
>  {
>  	int i;
> 
> @@ -129,6 +129,18 @@ static struct ima_template_desc *lookup_template_desc(const char *name)
>  	return NULL;
>  }
> 
> +static struct ima_template_desc *lookup_template_desc_by_fmt(const char *fmt)
> +{
> +	struct ima_template_desc *desc;
> +
> +	list_for_each_entry(desc, &defined_templates[0].list, list) {
> +		if (strcmp(desc->fmt, fmt) == 0)
> +			return desc;
> +	}
> +
> +	return NULL;
> +}
> +
>  static struct ima_template_field *lookup_template_field(const char *field_id)
>  {
>  	int i;
> @@ -232,7 +244,7 @@ struct ima_template_desc *ima_template_desc_current(void)
>  {
>  	if (!ima_template)
>  		ima_template =
> -		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
> +		    lookup_template_desc_by_name(CONFIG_IMA_DEFAULT_TEMPLATE);
>  	return ima_template;
>  }
> 


