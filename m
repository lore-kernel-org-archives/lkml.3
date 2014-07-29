Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaG2MDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:03:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47156 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaG2MDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:03:39 -0400
Message-ID: <1406635365.25105.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/2] X.509: x509_request_asymmetric_keys() doesn't need
 string length arguments
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2014 08:02:45 -0400
In-Reply-To: <20140728135449.18307.38548.stgit@warthog.procyon.org.uk>
References: <20140728135449.18307.38548.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072912-1542-0000-0000-0000039DA22A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 14:54 +0100, David Howells wrote: 
> x509_request_asymmetric_keys() doesn't need the lengths of the NUL-terminated
> strings passing in as it can work that out for itself.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  crypto/asymmetric_keys/x509_public_key.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index a0f7cd196c9b..4ae982234d78 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -48,11 +48,10 @@ __setup("ca_keys=", ca_keys_setup);
>   */
>  static struct key *x509_request_asymmetric_key(struct key *keyring,
>  					       const char *signer,
> -					       size_t signer_len,
> -					       const char *authority,
> -					       size_t auth_len)
> +					       const char *authority)
>  {
>  	key_ref_t key;
> +	size_t signer_len = strlen(signer), auth_len = strlen(authority);
>  	char *id;
> 
>  	/* Construct an identifier. */
> @@ -193,9 +192,7 @@ static int x509_validate_trust(struct x509_certificate *cert,
>  		return -EPERM;
> 
>  	key = x509_request_asymmetric_key(trust_keyring,
> -					  cert->issuer, strlen(cert->issuer),
> -					  cert->authority,
> -					  strlen(cert->authority));
> +					  cert->issuer, cert->authority);
>  	if (!IS_ERR(key))  {
>  		if (!use_builtin_keys
>  		    || test_bit(KEY_FLAG_BUILTIN, &key->flags))
> 


