Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbbANDtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:49:41 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47726 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANDtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:49:40 -0500
From: hejianet <jiakernel@gmail.com>
X-Google-Original-From: hejianet <hejianet@gmail.com>
Message-ID: <54B5E74E.3080101@gmail.com>
Date: Wed, 14 Jan 2015 11:49:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: lustre: libcfs: fix sparse warnings about static
 declaration
References: <1418740778-827-1-git-send-email-hejianet@gmail.com>
In-Reply-To: <1418740778-827-1-git-send-email-hejianet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all
Ping again, any comments are welcome

Justin

On Tue, 16 Dec 2014 22:39:38 +0800 from hejianet@gmail.com wrote:
> make sparse happy since these two fuchtion are only used in module.c.
> tested by successful compilation.
>
> Signed-off-by: Jia He <hejianet@gmail.com>
> Cc: Oleg Drokin <oleg.drokin@intel.com>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/lustre/lustre/libcfs/module.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
> index 2c4fc74..b9ee37c 100644
> --- a/drivers/staging/lustre/lustre/libcfs/module.c
> +++ b/drivers/staging/lustre/lustre/libcfs/module.c
> @@ -42,8 +42,7 @@
>  #include "../../include/linux/lnet/lnet.h"
>  #include "tracefile.h"
>  
> -void
> -kportal_memhog_free (struct libcfs_device_userstate *ldu)
> +static void kportal_memhog_free (struct libcfs_device_userstate *ldu)
>  {
>  	struct page **level0p = &ldu->ldu_memhog_root_page;
>  	struct page **level1p;
> @@ -86,8 +85,7 @@ kportal_memhog_free (struct libcfs_device_userstate *ldu)
>  	LASSERT (ldu->ldu_memhog_pages == 0);
>  }
>  
> -int
> -kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
> +static int kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
>  		     gfp_t flags)
>  {
>  	struct page **level0p;

