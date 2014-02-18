Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaBRUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:44:40 -0500
Received: from fieldses.org ([174.143.236.118]:55411 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaBRUoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:44:39 -0500
Date: Tue, 18 Feb 2014 15:44:38 -0500
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: "J. Bruce Fields" <bfields@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD, lost nfserrno() call in nfsd_setattr()
Message-ID: <20140218204438.GA12930@fieldses.org>
References: <20699.1392737273@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20699.1392737273@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 12:27:53AM +0900, J. R. Okajima wrote:
> 
> There is a regression in
> 	208d0ac 2014-01-07 nfsd4: break only delegations when appropriate
> which deletes an nfserrno() call in nfsd_setattr() (by accident,
> probably), and NFSD becomes ignoring an error from VFS.
> 
> Here is a patch to fix it.

Thanks for cathing that!  Queueing up for 3.14.

--b.

> 
> J. R. Okajima
> 
> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 017d3cb..6d7be3f 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -449,6 +449,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
>  	fh_lock(fhp);
>  	host_err = notify_change(dentry, iap, NULL);
>  	fh_unlock(fhp);
> +	err = nfserrno(host_err);
>  
>  out_put_write_access:
>  	if (size_change)
