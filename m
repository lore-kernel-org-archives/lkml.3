Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbaKUOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:43:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbaKUOnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:43:00 -0500
Date: Fri, 21 Nov 2014 09:42:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] X.509: Extract both parts of the
 AuthorityKeyIdentifier
Message-ID: <20141121144245.GA22306@redhat.com>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
 <20141120165403.5264.18275.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120165403.5264.18275.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:54:03PM +0000, David Howells wrote:

[..]
> diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
> index 3dfe6b5d6f0b..223b72344060 100644
> --- a/crypto/asymmetric_keys/x509_parser.h
> +++ b/crypto/asymmetric_keys/x509_parser.h
> @@ -21,7 +21,8 @@ struct x509_certificate {
>  	char		*subject;		/* Name of certificate subject */
>  	struct asymmetric_key_id *id;		/* Serial number + issuer */
>  	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
> -	struct asymmetric_key_id *authority;	/* Authority key identifier (optional) */
> +	struct asymmetric_key_id *auth_id;	/* CA AuthKeyId matching ->id (optional) */
> +	struct asymmetric_key_id *auth_skid;	/* CA AuthKeyId matching ->skid (optional) */

A very minor nit. It might help if we put additional comment to explain what
auth_id and auth_skid are composed of (like other key ids).

auth_id /* akid issuer + akid serial */
auth_skid /* issuer + akid keyid */

Thanks
Vivek
