Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbaJaOkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:40:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871AbaJaOku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:40:50 -0400
Date: Fri, 31 Oct 2014 15:40:45 +0100
From: Jan Kara <jack@suse.cz>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: remove unused functions
Message-ID: <20141031144045.GA10437@quack.suse.cz>
References: <1414757628-16326-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414757628-16326-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31-10-14 17:43:48, Sudip Mukherjee wrote:
> commit "5b71ecfa78271d5c576f17156ed8a53981c1ecbb" removed the use
> two functions isofs_hash() and isofs_dentry_cmp() , but their
> definition was not removed.
> So, as these functions are not used anywhere so it is safe to
> remove them. It has been build tested after removing.
  Thanks for the patch. One note though - after your patch
isofs_hash_common() is called from a single place so there's no point to
have that function. You can just inline it in isofs_hash_ms(). Please do
that when we are messing with the code.

								Honza
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  fs/isofs/inode.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 859a309..fe839b9 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -29,13 +29,9 @@
>  #define BEQUIET
>  
>  static int isofs_hashi(const struct dentry *parent, struct qstr *qstr);
> -static int isofs_hash(const struct dentry *parent, struct qstr *qstr);
>  static int isofs_dentry_cmpi(const struct dentry *parent,
>  		const struct dentry *dentry,
>  		unsigned int len, const char *str, const struct qstr *name);
> -static int isofs_dentry_cmp(const struct dentry *parent,
> -		const struct dentry *dentry,
> -		unsigned int len, const char *str, const struct qstr *name);
>  
>  #ifdef CONFIG_JOLIET
>  static int isofs_hashi_ms(const struct dentry *parent, struct qstr *qstr);
> @@ -254,25 +250,12 @@ static int isofs_dentry_cmp_common(
>  }
>  
>  static int
> -isofs_hash(const struct dentry *dentry, struct qstr *qstr)
> -{
> -	return isofs_hash_common(qstr, 0);
> -}
> -
> -static int
>  isofs_hashi(const struct dentry *dentry, struct qstr *qstr)
>  {
>  	return isofs_hashi_common(qstr, 0);
>  }
>  
>  static int
> -isofs_dentry_cmp(const struct dentry *parent, const struct dentry *dentry,
> -		unsigned int len, const char *str, const struct qstr *name)
> -{
> -	return isofs_dentry_cmp_common(len, str, name, 0, 0);
> -}
> -
> -static int
>  isofs_dentry_cmpi(const struct dentry *parent, const struct dentry *dentry,
>  		unsigned int len, const char *str, const struct qstr *name)
>  {
> -- 
> 1.8.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
