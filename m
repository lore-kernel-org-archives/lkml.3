Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3LMBiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:38:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3LMBiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:38:19 -0500
Date: Thu, 12 Dec 2013 17:40:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: vegard.nossum@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] hfsplus: Known exploit detection for CVE-2012-2319
Message-ID: <20131213014007.GA11068@kroah.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <1386867152-24072-5-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386867152-24072-5-git-send-email-vegard.nossum@oracle.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:52:28PM +0100, vegard.nossum@oracle.com wrote:
> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> See 6f24f892871acc47b40dd594c63606a17c714f77.

Please put the "name" of the git commit after it, to make it easier to
determine what this is referring to.

> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  fs/hfsplus/catalog.c |    2 ++
>  fs/hfsplus/dir.c     |    3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
> index 968ce41..5f47a1a 100644
> --- a/fs/hfsplus/catalog.c
> +++ b/fs/hfsplus/catalog.c
> @@ -8,6 +8,7 @@
>   * Handling of catalog records
>   */
>  
> +#include <linux/exploit.h>
>  
>  #include "hfsplus_fs.h"
>  #include "hfsplus_raw.h"
> @@ -374,6 +375,7 @@ int hfsplus_rename_cat(u32 cnid,
>  	if (err)
>  		goto out;
>  	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
> +		exploit("CVE-2012-2319");

So, any invalid data here means this was an expoit attempt?  No, not
true, corrupted filesystems could also cause this, right?

Same for the other instances here.

greg k-h
