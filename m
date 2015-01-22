Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbbAVApE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:45:04 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:41701 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbAVAos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:44:48 -0500
From: Paul Moore <paul@paul-moore.com>
To: Guenter Roeck <linux@roeck-us.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Jan 2015 19:44:44 -0500
Message-ID: <14b0f192c78.2806.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <1421880265-26647-1-git-send-email-linux@roeck-us.net>
References: <1421880265-26647-1-git-send-email-linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0 AquaMail/1.5.1.13 (build: 21020013)
Subject: Re: [PATCH RESEND] fs: namei: Use memcpy instead of strlcpy
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point.  Do you mind if I merge your patch into my existing patch 
instead of including it separately?

--
paul moore
www.paul-moore.com



On January 21, 2015 5:45:29 PM Guenter Roeck <linux@roeck-us.net> wrote:

> If the string length is known, there is no need to use strlcpy.
> Use memcpy instead.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Nitpick, but still a bit faster. Applies on top of -next.
>
> Resending with correct cc:. Sorry for the noise.
>
>  fs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 323957f..2e09219 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -233,7 +233,7 @@ getname_kernel(const char * filename)
>  		__putname(result);
>  		return ERR_PTR(-ENAMETOOLONG);
>  	}
> -	strlcpy((char *)result->name, filename, len);
> +	memcpy((char *)result->name, filename, len);
>  	result->uptr = NULL;
>  	result->aname = NULL;
>  	result->refcnt = 1;
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


