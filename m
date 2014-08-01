Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaHAQE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbaHAQE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:04:57 -0400
Date: Fri, 1 Aug 2014 12:03:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: dan.carpenter@oracle.com, keyrings@linux-nfs.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] PKCS#7: issuer and subject are mandatory fields in the
 ASN.1
Message-ID: <20140801160328.GA5100@redhat.com>
References: <20140731141103.16348.91901.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731141103.16348.91901.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 03:11:03PM +0100, David Howells wrote:
> issuer and subject are mandatory fields in the ASN.1 and so their existence
> needn't be tested for.  They are guaranteed to end up with an empty string if
> the name material has nothing we can use (see x509_fabricate_name()).
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  crypto/asymmetric_keys/pkcs7_verify.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index 51ff36f3a913..c62cf8006e1f 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -190,14 +190,12 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
>  		if (ret < 0)
>  			return ret;
>  
> -		if (x509->issuer)
> -			pr_debug("- issuer %s\n", x509->issuer);
> +		pr_debug("- issuer %s\n", x509->issuer);
>  		if (x509->authority)
>  			pr_debug("- authkeyid %s\n", x509->authority);
>  
>  		if (!x509->authority ||
> -		    (x509->subject &&
> -		     strcmp(x509->subject, x509->issuer) == 0)) {
> +		    strcmp(x509->subject, x509->issuer) == 0) {
>  			/* If there's no authority certificate specified, then
>  			 * the certificate must be self-signed and is the root
>  			 * of the chain.  Likewise if the cert is its own
