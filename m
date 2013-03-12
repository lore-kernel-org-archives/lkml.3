Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3CLJCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:02:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337Ab3CLJCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:02:30 -0400
Message-ID: <1363078947.1344.1.camel@tucsk.piliscsaba.szeredi.hu>
Subject: Re: [PATCH] fuse: Fix build after change to synchronize with library
From: Miklos Szeredi <mszeredi@suse.cz>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 10:02:27 +0100
In-Reply-To: <1363042456-8895-1-git-send-email-arve@android.com>
References: <1363042456-8895-1-git-send-email-arve@android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:54 -0700, Arve Hjønnevåg wrote:
> __linux__ is not always defined so check __KERNEL__ as well.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  include/uapi/linux/fuse.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 4c43b44..fc5d400 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -95,7 +95,7 @@
>  #ifndef _LINUX_FUSE_H
>  #define _LINUX_FUSE_H
>  
> -#ifdef __linux__
> +#if defined(__KERNEL__) || defined(__linux__)

Or how about just

#ifdef __KERNEL__

?

Thanks,
Miklos

