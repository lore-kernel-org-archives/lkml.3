Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaKQTSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:18:34 -0500
Received: from gproxy7-pub.mail.unifiedlayer.com ([70.40.196.235]:39472 "HELO
	gproxy7-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbaKQTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:18:32 -0500
X-Authority-Analysis: v=2.1 cv=B+wqjodM c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=IkcTkHD0fZMA:10 a=wCmvBT1CAAAA:8 a=djd9j7hWnewA:10
 a=YP2Gd-mDGRwA:10 a=FP58Ms26AAAA:8 a=dIEXLcprIe_-_94N29oA:9 a=QEXdDO2ut3YA:10
Message-ID: <1416251896.2937.1.camel@ubuntu>
Subject: Re: [PATCH 1/1] hfs/hfs+: Deletion of unnecessary checks before the
 function call "hfs_bnode_put"
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Date: Mon, 17 Nov 2014 11:18:16 -0800
In-Reply-To: <546A3C2A.9050401@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546A3C2A.9050401@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 199.255.44.5 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 19:19 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 17 Nov 2014 19:13:56 +0100
> 
> The hfs_bnode_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 

Thank you. It's the reasonable correction. Looks good for me.

Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/hfs/bfind.c     | 3 +--
>  fs/hfs/brec.c      | 3 +--
>  fs/hfsplus/bfind.c | 3 +--
>  fs/hfsplus/brec.c  | 3 +--
>  4 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/hfs/bfind.c b/fs/hfs/bfind.c
> index de69d8a..0e26523 100644
> --- a/fs/hfs/bfind.c
> +++ b/fs/hfs/bfind.c
> @@ -100,8 +100,7 @@ int hfs_brec_find(struct hfs_find_data *fd)
>  	int height, res;
>  
>  	tree = fd->tree;
> -	if (fd->bnode)
> -		hfs_bnode_put(fd->bnode);
> +	hfs_bnode_put(fd->bnode);
>  	fd->bnode = NULL;
>  	nidx = tree->root;
>  	if (!nidx)
> diff --git a/fs/hfs/brec.c b/fs/hfs/brec.c
> index 9f4ee7f..3a52b2c 100644
> --- a/fs/hfs/brec.c
> +++ b/fs/hfs/brec.c
> @@ -272,8 +272,7 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
>  		/* panic? */
>  		hfs_bnode_put(node);
>  		hfs_bnode_put(new_node);
> -		if (next_node)
> -			hfs_bnode_put(next_node);
> +		hfs_bnode_put(next_node);
>  		return ERR_PTR(-ENOSPC);
>  	}
>  
> diff --git a/fs/hfsplus/bfind.c b/fs/hfsplus/bfind.c
> index c1422d9..7be88e3 100644
> --- a/fs/hfsplus/bfind.c
> +++ b/fs/hfsplus/bfind.c
> @@ -171,8 +171,7 @@ int hfs_brec_find(struct hfs_find_data *fd, search_strategy_t do_key_compare)
>  	int height, res;
>  
>  	tree = fd->tree;
> -	if (fd->bnode)
> -		hfs_bnode_put(fd->bnode);
> +	hfs_bnode_put(fd->bnode);
>  	fd->bnode = NULL;
>  	nidx = tree->root;
>  	if (!nidx)
> diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
> index 6e560d5..59bab47 100644
> --- a/fs/hfsplus/brec.c
> +++ b/fs/hfsplus/brec.c
> @@ -276,8 +276,7 @@ static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
>  		/* panic? */
>  		hfs_bnode_put(node);
>  		hfs_bnode_put(new_node);
> -		if (next_node)
> -			hfs_bnode_put(next_node);
> +		hfs_bnode_put(next_node);
>  		return ERR_PTR(-ENOSPC);
>  	}
>  


