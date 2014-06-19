Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbaFSFVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:21:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbaFSFV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:21:28 -0400
Date: Thu, 19 Jun 2014 08:21:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check for Null return of function of affs_bread  in
 function affs_truncate
Message-ID: <20140619052128.GV5015@mwanda>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:08:05PM -0400, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/affs/file.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/affs/file.c b/fs/affs/file.c
> index a7fe57d..f26482d 100644
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
> @@ -923,6 +923,8 @@ affs_truncate(struct inode *inode)
>  
>  	while (ext_key) {
>  		ext_bh = affs_bread(sb, ext_key);
> +		if (!ext_bh)
> +			return;

The problem is that we don't know if we should return here or break
here.  If you don't understand the code, then it's best to just leave it
alone.

regards,
dan carpenter

>  		size = AFFS_SB(sb)->s_hashsize;
>  		if (size > blkcnt - blk)
>  			size = blkcnt - blk;
> -- 
> 1.9.1
