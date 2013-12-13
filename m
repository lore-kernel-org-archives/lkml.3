Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3LMLOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:14:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39969 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3LMLOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:14:02 -0500
Date: Fri, 13 Dec 2013 11:14:03 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: vegard.nossum@oracle.com
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/9] hfsplus: Known exploit detection for CVE-2012-2319
Message-ID: <20131213111403.77a8122c@alan.etchedpixels.co.uk>
In-Reply-To: <1386867152-24072-5-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<1386867152-24072-5-git-send-email-vegard.nossum@oracle.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 17:52:28 +0100
vegard.nossum@oracle.com wrote:

> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> See 6f24f892871acc47b40dd594c63606a17c714f77.
> 
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

Whooppee but if I drive the box totally out of memory with several of
these file systems I can cause all sorts of problems due to missing null
checks, and I can feed some others such as reiserfs (why do we still ship
that ?) corrupt disk images and patch the kernel that way.

So surely we ought to be fixing the actual bugs first ?

Alan
