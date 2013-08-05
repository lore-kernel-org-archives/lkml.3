Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3HEO77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:59:59 -0400
Received: from mx12.netapp.com ([216.240.18.77]:7691 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3HEO75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:59:57 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367996400"; 
   d="scan'208";a="78640730"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steve Dickson <steved@redhat.com>,
        David Quigley <dpquigl@davequigley.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/nfs/inode.c: adjust code alignment
Thread-Topic: [PATCH] fs/nfs/inode.c: adjust code alignment
Thread-Index: AQHOkerHgeen3NIfwkumGqiOgVY35ZmHKmSA
Date: Mon, 5 Aug 2013 14:59:55 +0000
Message-ID: <1375714793.7337.12.camel@leira.trondhjem.org>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1375714059-29567-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1375714059-29567-2-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BEB8E4A1C38604A8409D63D95EB5994@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r75F02jp012167

On Mon, 2013-08-05 at 16:47 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> 
> This patch adjusts the code so that the alignment matches the current
> semantics.  I have no idea if it is the intended semantics, though.  Should
> the call to nfs_setsecurity also be under the else?
> 

>  fs/nfs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index af6e806..d8ad685 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -463,7 +463,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh
> *fh, struct nfs_fattr *fattr, st
>                 unlock_new_inode(inode);
>         } else
>                 nfs_refresh_inode(inode, fattr);
> -               nfs_setsecurity(inode, fattr, label);
> +       nfs_setsecurity(inode, fattr, label);
>         dprintk("NFS: nfs_fhget(%s/%Ld fh_crc=0x%08x ct=%d)\n",
>                 inode->i_sb->s_id,
>                 (long long)NFS_FILEID(inode),

Hi Julia,

Thanks for pointing this out! Given that the 'then' clause of the if
statement already calls nfs_setsecurity before unlocking the inode, I
suspect that the above _should_ really be part of the 'else' clause. 

That said, I can't see that calling nfs_setsecurity twice on the inode
can cause any unintended side-effects, so I suggest that we rather queue
the patch up for inclusion in 3.12.
Steve and Dave, any comments?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
