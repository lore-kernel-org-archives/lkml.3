Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaICNyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:54:08 -0400
Received: from fm2nodo5.polito.it ([130.192.180.14]:56691 "EHLO
	fm2nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbaICNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:54:07 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 09:54:06 EDT
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <54071D66.4040101@polito.it>
Date: Wed, 03 Sep 2014 15:53:42 +0200
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dmitry Kasatkin <d.kasatkin@samsung.com>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [Linux-ima-devel] [PATCH 5/8] ima: add missing '__init' keywords
References: <cover.1409728712.git.d.kasatkin@samsung.com> <d867d0c80076e9f79279e29a3b7fa8c7ba0ea66c.1409728712.git.d.kasatkin@samsung.com>
In-Reply-To: <d867d0c80076e9f79279e29a3b7fa8c7ba0ea66c.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-SYSTEM-WL: 130.192.180.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 09:19 AM, Dmitry Kasatkin wrote:
> Add missing keywords to the function definition to cleanup
> to discard initialization code.
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>   security/integrity/ima/ima.h          | 2 --
>   security/integrity/ima/ima_crypto.c   | 2 +-
>   security/integrity/ima/ima_template.c | 4 ++--
>   3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index c6990a7..8e4bb88 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -107,8 +107,6 @@ void ima_print_digest(struct seq_file *m, u8 *digest, int size);
>   struct ima_template_desc *ima_template_desc_current(void);
>   int ima_init_template(void);
>
> -int ima_init_template(void);
> -
>   /*
>    * used to protect h_table and sha_table
>    */
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 3b26472..d34e7df 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -97,7 +97,7 @@ static int ima_kernel_read(struct file *file, loff_t offset,
>   	return ret;
>   }
>
> -int ima_init_crypto(void)
> +int __init ima_init_crypto(void)
>   {
>   	long rc;
>
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index a076a96..f682606 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -152,7 +152,7 @@ out:
>   	return result;
>   }
>
> -static int init_defined_templates(void)
> +static int __init init_defined_templates(void)
>   {
>   	int i = 0;
>   	int result = 0;
> @@ -178,7 +178,7 @@ struct ima_template_desc *ima_template_desc_current(void)
>   	return ima_template;
>   }
>
> -int ima_init_template(void)
> +int __init ima_init_template(void)
>   {
>   	int result;
>

Hi Dmitry

ok, I'm fine with this change.

Thanks

Roberto Sassu


>

