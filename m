Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbbALVY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:24:57 -0500
Received: from fieldses.org ([174.143.236.118]:38480 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbbALVYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:24:55 -0500
Date: Mon, 12 Jan 2015 16:24:53 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockd: xdr: Remove unused function
Message-ID: <20150112212453.GA1940@fieldses.org>
References: <1420909362-31705-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420909362-31705-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 06:02:42PM +0100, Rickard Strandqvist wrote:
> Remove the function nlm_encode_fh() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.

Huh.  OK, thanks--applying.

--b.

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  fs/lockd/xdr.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
> index 9340e7e..5b651da 100644
> --- a/fs/lockd/xdr.c
> +++ b/fs/lockd/xdr.c
> @@ -95,14 +95,6 @@ nlm_decode_fh(__be32 *p, struct nfs_fh *f)
>  	return p + XDR_QUADLEN(NFS2_FHSIZE);
>  }
>  
> -static inline __be32 *
> -nlm_encode_fh(__be32 *p, struct nfs_fh *f)
> -{
> -	*p++ = htonl(NFS2_FHSIZE);
> -	memcpy(p, f->data, NFS2_FHSIZE);
> -	return p + XDR_QUADLEN(NFS2_FHSIZE);
> -}
> -
>  /*
>   * Encode and decode owner handle
>   */
> -- 
> 1.7.10.4
> 
