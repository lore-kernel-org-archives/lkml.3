Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3EWOce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:32:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49920 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3EWOcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:32:33 -0400
Message-ID: <519E287E.4010307@gmail.com>
Date: Thu, 23 May 2013 09:32:30 -0500
From: Jason Hrycay <jhrycay@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: jaegeuk.kim@samsung.com, Amit Sahrawat <a.sahrawat@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        jason.hrycay@motorola.com
Subject: Re: [f2fs-dev] [PATCH 3/4] f2fs: return proper error from start_gc_thread
References: <1369317502-14380-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1369317502-14380-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2013 8:58 AM, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> when there is an error from kthread_run, then return proper error
> rather than returning -ENOMEM.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/gc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 25b083c..03d5ba1 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -105,7 +105,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>  	if (IS_ERR(gc_th->f2fs_gc_task)) {
>  		kfree(gc_th);

gc_th is free'd here, save off PTR_ERR result to avoid use-after-free?

>  		sbi->gc_thread = NULL;
> -		return -ENOMEM;
> +		return PTR_ERR(gc_th->f2fs_gc_task);
>  	}
>  	return 0;
>  }
> 

--
Jason Hrycay
