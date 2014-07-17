Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaGQOZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:25:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50530 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaGQOZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <1405603586-12515-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405603586-12515-1-git-send-email-andrey.krieger.utkin@gmail.com>
Date: Thu, 17 Jul 2014 17:25:13 +0300
Message-ID: <CANZNk83O6jjQ1-zN2f7pFnv9tfMATLELEuf6=d8KVe6BYP_qyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] arch/metag/kernel/cachepart.c: fix failure check
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-metag@vger.kernel.org
Cc: james.hogan@imgtec.com, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-17 16:26 GMT+03:00 Andrey Utkin <andrey.krieger.utkin@gmail.com>:
> --- a/arch/metag/kernel/cachepart.c
> +++ b/arch/metag/kernel/cachepart.c
> @@ -99,7 +99,7 @@ void check_for_cache_aliasing(int thread_id)
>         for (cache_type = ICACHE; cache_type <= DCACHE; cache_type++) {
>                 thread_cache_size =
>                                 get_thread_cache_size(cache_type, thread_id);
> -               if (thread_cache_size < 0)
> +               if (thread_cache_size == (unsigned int)-1)

If it would be better, i can resubmit with addition of signed
variable, like there: https://patchwork.kernel.org/patch/4575881/

-- 
Andrey Utkin
