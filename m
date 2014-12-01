Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaLAVeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:34:05 -0500
Received: from smtp101.biz.mail.bf1.yahoo.com ([98.139.221.60]:28761 "EHLO
	smtp101.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbaLAVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:34:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eOm19ocVM1n5kOG4sqfpnGe_IGWdmS_RmiD3cTBIA.rtuXf
 WL2DIcji2b7d0OVh2Mtlswy1f.kCG97Xu5esV7zs3YVLyoCd..okMHJXREKm
 HR.JTinlStw.G7jr7t69LzbwTLdYKpxXwQD9RBKDj.KKFUNNTeCcJaOMqUwZ
 RGNZIVPudZmn01rvxZ9Nv7VfNotnJSm9LozbmQi0nxaiTRD8LDaEe1BdyXwN
 S.rsZCnOef8Z6XMhhgFuFpdczPVt80qNHFQs6yY.DJn1_OZOWnKARzCZnjOW
 DGAlYme7Wbk7ld0RRBsdEAD_jKd9k27YHri5AOvEdFApBO1KtNjTjl0hgMbU
 8X.oyzKACXqJjcv5FtI1mOqtIHqxAJOOQYaGrOA.Gw1pnVMo5oY91BqrOtM5
 i.1zHDZ18q.ygbK7UkwRx2TQfYIHW5vwdY9NOttp.RY0Xc7tocANyaZJmyvq
 JAcRsq9IZOrRsn_VRn091zoleVculGBtxGlxa2rhmXFGa3Xyme26dL6Eqepa
 nIx9zxNRQkiFvCAdY6ZOhWsZYjlNfjGYuh9ORoeVI15Gyt8OqGkw4K1W3yOy
 trWfJLVfvB_aXfy7HIWTQL0Eng5o7JS7NIO2u2jPcRviWalYhQZD33uqa.lO
 07o8p120bAg.A
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <547CDEC9.5030009@schaufler-ca.com>
Date: Mon, 01 Dec 2014 13:34:01 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH 2/2] smack: fix logic in smack_inode_init_security function
References: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com> <1417012267-21298-2-git-send-email-l.pawelczyk@samsung.com>
In-Reply-To: <1417012267-21298-2-git-send-email-l.pawelczyk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 6:31 AM, Lukasz Pawelczyk wrote:
> In principle if this function was called with "value" == NULL and "len"
> not NULL it could return different results for the "len" compared to a
> case where "name" was not NULL. This is a hypothetical case that does
> not exist in the kernel, but it's a logic bug nonetheless.
>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20

> ---
>  security/smack/smack_lsm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d1b14d5..e8bed86 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -800,7 +800,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  	if (name)
>  		*name = XATTR_SMACK_SUFFIX;
>  
> -	if (value) {
> +	if (value && len) {
>  		rcu_read_lock();
>  		may = smk_access_entry(skp->smk_known, dsp->smk_known,
>  				       &skp->smk_rules);
> @@ -821,10 +821,9 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  		*value = kstrdup(isp->smk_known, GFP_NOFS);
>  		if (*value == NULL)
>  			return -ENOMEM;
> -	}
>  
> -	if (len)
>  		*len = strlen(isp->smk_known);
> +	}
>  
>  	return 0;
>  }

