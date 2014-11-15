Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaKOTy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:54:26 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:46883 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbaKOTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:54:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,392,1413237600"; 
   d="scan'208";a="107192293"
Date: Sat, 15 Nov 2014 20:54:22 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] ntfs: Deletion of unnecessary checks before
 the function call "iput"
In-Reply-To: <54679E97.5000801@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1411152053430.2225@localhost6.localdomain6>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54679E97.5000801@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 15 Nov 2014 19:35:05 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/ntfs/super.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 6c3296e..8f22a47 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -2204,17 +2204,12 @@ get_ctx_vol_failed:
>  	return true;
>  #ifdef NTFS_RW
>  iput_usnjrnl_err_out:

I don't have time to look at the code now, but since there is an exit 
label here, have you checked whether you could improve the gotos in these 
cases?

julia

> -	if (vol->usnjrnl_j_ino)
> -		iput(vol->usnjrnl_j_ino);
> -	if (vol->usnjrnl_max_ino)
> -		iput(vol->usnjrnl_max_ino);
> -	if (vol->usnjrnl_ino)
> -		iput(vol->usnjrnl_ino);
> +	iput(vol->usnjrnl_j_ino);
> +	iput(vol->usnjrnl_max_ino);
> +	iput(vol->usnjrnl_ino);
>  iput_quota_err_out:
> -	if (vol->quota_q_ino)
> -		iput(vol->quota_q_ino);
> -	if (vol->quota_ino)
> -		iput(vol->quota_ino);
> +	iput(vol->quota_q_ino);
> +	iput(vol->quota_ino);
>  	iput(vol->extend_ino);
>  #endif /* NTFS_RW */
>  iput_sec_err_out:
> @@ -2223,8 +2218,7 @@ iput_root_err_out:
>  	iput(vol->root_ino);
>  iput_logfile_err_out:
>  #ifdef NTFS_RW
> -	if (vol->logfile_ino)
> -		iput(vol->logfile_ino);
> +	iput(vol->logfile_ino);
>  iput_vol_err_out:
>  #endif /* NTFS_RW */
>  	iput(vol->vol_ino);
> @@ -2254,8 +2248,7 @@ iput_mftbmp_err_out:
>  	iput(vol->mftbmp_ino);
>  iput_mirr_err_out:
>  #ifdef NTFS_RW
> -	if (vol->mftmirr_ino)
> -		iput(vol->mftmirr_ino);
> +	iput(vol->mftmirr_ino);
>  #endif /* NTFS_RW */
>  	return false;
>  }
> -- 
> 2.1.3
> 
> 
> _______________________________________________
> Cocci mailing list
> Cocci@systeme.lip6.fr
> https://systeme.lip6.fr/mailman/listinfo/cocci
> 
