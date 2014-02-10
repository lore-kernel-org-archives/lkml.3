Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaBJC7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:59:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27070 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaBJC7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:59:48 -0500
Date: Sun, 9 Feb 2014 18:59:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Message-ID: <20140210025938.GD9176@birch.djwong.org>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 06:41:21PM +0530, Rashika Kheria wrote:
> Mark functions as static in jbd2/journal.c because they are not used
> outside this file.
> 
> This eliminates the following warning in jbd2/journal.c:
> fs/jbd2/journal.c:125:5: warning: no previous prototype for ‘jbd2_verify_csum_type’ [-Wmissing-prototypes]
> fs/jbd2/journal.c:146:5: warning: no previous prototype for ‘jbd2_superblock_csum_verify’ [-Wmissing-prototypes]
> fs/jbd2/journal.c:154:6: warning: no previous prototype for ‘jbd2_superblock_csum_set’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Looks fine to me, so you can add
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/jbd2/journal.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 5fa344a..244b6f6 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -122,7 +122,7 @@ EXPORT_SYMBOL(__jbd2_debug);
>  #endif
>  
>  /* Checksumming functions */
> -int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
> +static int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -143,7 +143,7 @@ static __be32 jbd2_superblock_csum(journal_t *j, journal_superblock_t *sb)
>  	return cpu_to_be32(csum);
>  }
>  
> -int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
> +static int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -151,7 +151,7 @@ int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
>  	return sb->s_checksum == jbd2_superblock_csum(j, sb);
>  }
>  
> -void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
> +static void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
