Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbaHHVQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:16:44 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:33147
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbaHHUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:41 -0400
Date: Fri, 8 Aug 2014 22:51:37 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/3] Smack: remove unneeded NULL-termination from
 securtity label
Message-ID: <20140808205137.GD25352@mail.hallyn.com>
References: <20140807165233.13463.55258.stgit@buzz>
 <20140807165249.13463.60191.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807165249.13463.60191.stgit@buzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Konstantin Khlebnikov (k.khlebnikov@samsung.com):
> Values of extended attributes are stored as binary blobs. NULL-termination
> of them isn't required. It just wastes disk space and confuses command-line
> tools like getfattr because they have to print that zero byte at the end.
> 
> This patch removes terminating zero byte from initial security label in
> smack_inode_init_security and cuts it out in function smack_inode_getsecurity
> which is used by syscall getxattr. This change seems completely safe, because
> function smk_parse_smack ignores everything after first zero byte.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

selinux doesn't seem to do it this way, and apparmor doesn't use these
at all, but your reasoning does seem correct.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  security/smack/smack_lsm.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index afa5ad0..16ae853 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -672,7 +672,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  	}
>  
>  	if (len)
> -		*len = strlen(isp) + 1;
> +		*len = strlen(isp);
>  
>  	return 0;
>  }
> @@ -1076,7 +1076,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
>  
>  	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
>  		isp = smk_of_inode(inode);
> -		ilen = strlen(isp) + 1;
> +		ilen = strlen(isp);
>  		*buffer = isp;
>  		return ilen;
>  	}
> @@ -1101,7 +1101,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
>  	else
>  		return -EOPNOTSUPP;
>  
> -	ilen = strlen(isp) + 1;
> +	ilen = strlen(isp);
>  	if (rc == 0) {
>  		*buffer = isp;
>  		rc = ilen;
