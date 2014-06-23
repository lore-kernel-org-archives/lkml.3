Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFWBqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:46:34 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:36349 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750823AbaFWBqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:46:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3355:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:6117:6119:7514:7652:7903:9010:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12296:12517:12519:12555:12740:13019:13181:13229:13891:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: face44_9031e96044b29
X-Filterd-Recvd-Size: 4286
Message-ID: <1403487989.18747.30.camel@joe-AO725>
Subject: Re: [PATCH] fs/ntfs: Use '%tx' instead of '%zx'
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>
Cc: anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>,
        "lennox.wu@gmail.com >> Lennox Wu" <lennox.wu@gmail.com>
Date: Sun, 22 Jun 2014 18:46:29 -0700
In-Reply-To: <53A7845F.40404@gmail.com>
References: <53A7845F.40404@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please make sure to cc the specific maintainer

$ ./scripts/get_maintainer.pl -f fs/ntfs/
Anton Altaparmakov <anton@tuxera.com> (supporter:NTFS FILESYSTEM)
linux-ntfs-dev@lists.sourceforge.net (open list:NTFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)

(cc'ing Anton)

btw Anton, it seems ntfs_debug does not terminate
messages with a "\n".  That means that messages
could be interleaved with other output.

Maybe this patch as well as Chen Gang's below should be applied
---
 fs/ntfs/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
index dd6103c..1e824f0 100644
--- a/fs/ntfs/debug.c
+++ b/fs/ntfs/debug.c
@@ -126,7 +126,8 @@ void __ntfs_debug (const char *file, int line, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_debug("(%s, %d): %s(): %pV", file, line, flen ? function : "", &vaf);
+	pr_debug("(%s, %d): %s(): %pV\n",
+		 file, line, flen ? function : "", &vaf);
 	va_end(args);
 }
 

On Mon, 2014-06-23 at 09:35 +0800, Chen Gang wrote:
> For subtraction between 2 pointers, the result's type is 'ptrdiff_t', so
> need use '%tx' instead of '%zx'.
> 
> The related warning (allmodconfig under unicore32):
> 
>     CC [M]  fs/ntfs/compress.o
>   fs/ntfs/compress.c: In function 'ntfs_decompress':
>   fs/ntfs/compress.c:207:2: warning: format '%zx' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat=]
>     ntfs_debug("Beginning sub-block at offset = 0x%zx in the cb.",
>     ^
>     CC [M]  fs/ntfs/dir.o
>   fs/ntfs/dir.c: In function 'ntfs_readdir':
>   fs/ntfs/dir.c:1197:3: warning: format '%zx' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat=]
>      ntfs_debug("In index root, offset 0x%zx.", (u8*)ie - (u8*)ir);
>      ^
> 
> Also let the related code match linux kernel styles which is found by
> 'scripts/checkpatch.pl'.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  fs/ntfs/compress.c | 2 +-
>  fs/ntfs/dir.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index f82498c..2ba8280 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -204,7 +204,7 @@ static int ntfs_decompress(struct page *dest_pages[], int *dest_index,
>  
>  	ntfs_debug("Entering, cb_size = 0x%x.", cb_size);
>  do_next_sb:
> -	ntfs_debug("Beginning sub-block at offset = 0x%zx in the cb.",
> +	ntfs_debug("Beginning sub-block at offset = 0x%tx in the cb.",
>  			cb - cb_start);
>  	/*
>  	 * Have we reached the end of the compression block or the end of the
> diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
> index 9e38daf..2d3c32d 100644
> --- a/fs/ntfs/dir.c
> +++ b/fs/ntfs/dir.c
> @@ -1194,7 +1194,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *actor)
>  	 * or signals an error (both covered by the rc test).
>  	 */
>  	for (;; ie = (INDEX_ENTRY*)((u8*)ie + le16_to_cpu(ie->length))) {
> -		ntfs_debug("In index root, offset 0x%zx.", (u8*)ie - (u8*)ir);
> +		ntfs_debug("In index root, offset 0x%tx.", (u8 *)ie - (u8 *)ir);
>  		/* Bounds checks. */
>  		if (unlikely((u8*)ie < (u8*)ir || (u8*)ie +
>  				sizeof(INDEX_ENTRY_HEADER) > index_end ||



