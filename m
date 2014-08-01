Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaHABtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:49:23 -0400
Received: from plane.gmane.org ([80.91.229.3]:58079 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaHABtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:49:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE  and
 FALLOC_FL_ZERO_RANGE crap modes
Date: Fri, 1 Aug 2014 01:49:08 +0000 (UTC)
Message-ID: <pan$5cc93$d335db32$6c6335c1$bc0930b9@cox.net>
References: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-231-22-224.ph.ph.cox.net
User-Agent: Pan/0.140 (Chocolate Salty Balls; GIT d447f7c
 /m/p/portage/src/egit-src/pan2)
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause posted on Thu, 31 Jul 2014 13:53:33 -0400 as excerpted:

> This adds checks for the stated modes as if they are crap we will return
> error not supported.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/btrfs/file.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c index 1f2b99c..599495a
> 100644 --- a/fs/btrfs/file.c +++ b/fs/btrfs/file.c @@ -2490,7 +2490,8 @@
> static long btrfs_fallocate(struct file *file, int mode,
>  	alloc_end = round_up(offset + len, blocksize);
>  
>  	/* Make sure we aren't being give some crap mode */
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE| +
> FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE)

Is the supporting code already there?

You're removing the EOPNOTSUPP errors, but the code doesn't add the 
support, just removes the errors in the check for it, yet your comment 
doesn't point out that the support is actually already there with a 
pointer to either the commit adding it or the functions supporting it, as 
it should if that's true and the implementing patch simply forgot to 
remove those checks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

