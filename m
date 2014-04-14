Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaDNRzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:55:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaDNRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:55:45 -0400
Message-ID: <534C2114.8030502@oracle.com>
Date: Mon, 14 Apr 2014 12:55:32 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Tytso <tytso@mit.edu>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>
Subject: Re: [PATCH V2] fs/jfs/jfs_inode.c: atomically set inode->i_flags
References: <20140414093901.ea2d873d712ca4c8155d7827@skynet.be>
In-Reply-To: <20140414093901.ea2d873d712ca4c8155d7827@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. I'll push it upstream.

Thanks,
Dave

On 04/14/2014 02:39 AM, Fabian Frederick wrote:
> According to commit 5f16f3225b0624
> 
> ext4: atomically set inode->i_flags in ext4_set_inode_flags()
> 
> Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Dave Kleikamp <shaggy@kernel.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/jfs/jfs_inode.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
> index 7f464c5..6b0f816 100644
> --- a/fs/jfs/jfs_inode.c
> +++ b/fs/jfs/jfs_inode.c
> @@ -29,20 +29,20 @@
>  void jfs_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = JFS_IP(inode)->mode2;
> -
> -	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND |
> -		S_NOATIME | S_DIRSYNC | S_SYNC);
> +	unsigned int new_fl = 0;
>  
>  	if (flags & JFS_IMMUTABLE_FL)
> -		inode->i_flags |= S_IMMUTABLE;
> +		new_fl |= S_IMMUTABLE;
>  	if (flags & JFS_APPEND_FL)
> -		inode->i_flags |= S_APPEND;
> +		new_fl |= S_APPEND;
>  	if (flags & JFS_NOATIME_FL)
> -		inode->i_flags |= S_NOATIME;
> +		new_fl |= S_NOATIME;
>  	if (flags & JFS_DIRSYNC_FL)
> -		inode->i_flags |= S_DIRSYNC;
> +		new_fl |= S_DIRSYNC;
>  	if (flags & JFS_SYNC_FL)
> -		inode->i_flags |= S_SYNC;
> +		new_fl |= S_SYNC;
> +	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND | S_NOATIME |
> +			S_DIRSYNC | S_SYNC);
>  }
>  
>  void jfs_get_inode_flags(struct jfs_inode_info *jfs_ip)
> 
