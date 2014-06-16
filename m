Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaFPOzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:55:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48457 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaFPOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:55:22 -0400
Message-ID: <539F0551.30305@linux.vnet.ibm.com>
Date: Mon, 16 Jun 2014 09:55:13 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] drivers/crypto/nx/nx-842.c: use PAGE_ALIGNED instead
 of IS_ALIGNED(PAGE_SIZE
References: <1402783795-12331-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402783795-12331-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061614-7182-0000-0000-00000AE266A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2014 05:09 PM, Fabian Frederick wrote:
> use mm.h definition
> 
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
>  drivers/crypto/nx/nx-842.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 502edf0..923c4b6 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -350,7 +350,7 @@ int nx842_compress(const unsigned char *in, unsigned int inlen,
>  	 * the alignment is guaranteed.
>  	*/
>  	inbuf = (unsigned long)in;
> -	if (!IS_ALIGNED(inbuf, PAGE_SIZE) || inlen != PAGE_SIZE)
> +	if (!PAGE_ALIGNED(inbuf) || inlen != PAGE_SIZE)
>  		return -EINVAL;
> 
>  	rcu_read_lock();
> @@ -545,7 +545,7 @@ int nx842_decompress(const unsigned char *in, unsigned int inlen,
> 
>  	/* Ensure page alignment and size */
>  	outbuf = (unsigned long)out;
> -	if (!IS_ALIGNED(outbuf, PAGE_SIZE) || *outlen != PAGE_SIZE)
> +	if (!PAGE_ALIGNED(outbuf) || *outlen != PAGE_SIZE)
>  		return -EINVAL;
> 
>  	rcu_read_lock();
> 

