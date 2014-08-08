Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbaHHWFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:05:55 -0400
Received: from smtp104.biz.mail.bf1.yahoo.com ([98.139.221.63]:24141 "EHLO
	smtp104.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932713AbaHHWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:05:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IYqRRDcVM1kOGDqeBjHLvqmdLb5OYQWEpfqffOPxZJU_Wk6
 YyHjn7vLVbKGWJjslPLu56QFC3h3Ci_gFZpOfwZaFOwc_I_PfNUWtO2E_JKd
 fkSbCeZDxnwx8FIy9Gnpe9GSjOIfRDOTNgfO9lMDl7.iK1Xvsil0SifrX7Ir
 pBYvDoWQx6NmDKse1pEDueRNn_1hwJ4ZRCqjQyfMdCyYcuEEqiOCISEZdVen
 LL6_27mnx85h0vx4pppXWCb8YVIs4wOhtq_v_.R7ml.69cvz4s5zbTTcn.P0
 qDpjnwr.j8phBaob9YdaJD6EhhLuPr9cOup2MHvxN9_.tbdJrbpUFypqf3Rf
 sz5yoPz_qYQCjY2cJUe4tvghqmojzGwDirqNSbljPl4S44HlgNYHxphXXTg5
 6AjifTKw7TO7ooVLqiLwVf2ATUk2c9xnAV8zpciHQBmehlj.wqrifPPQ0z96
 ApMiuY9_oFWpg6A_CFukENd.yJ4VE.5T6vMG7Iepe5orRStc9espLcT.cnZo
 n4ttElNaEog9s8aAKSUMC9IuhSwrvnW9R5y.vaeUSyUjk4MAxxXgFQ9_T1qA
 CFxMs7QZUg2t0i16FXUeSt_x45sIGy2A4kct3BcRg.tw_zafDfgVBpyKgueK
 qRd.NQLU0jK_.
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <53E549BF.10401@schaufler-ca.com>
Date: Fri, 08 Aug 2014 15:05:51 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/3] Smack: remove unneeded NULL-termination from securtity
 label
References: <20140807165233.13463.55258.stgit@buzz> <20140807165249.13463.60191.stgit@buzz>
In-Reply-To: <20140807165249.13463.60191.stgit@buzz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2014 9:52 AM, Konstantin Khlebnikov wrote:
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

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.18


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
>
>

