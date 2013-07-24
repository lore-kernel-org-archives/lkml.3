Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3GXCTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3GXCTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:19:02 -0400
Message-ID: <51EF3990.4010901@redhat.com>
Date: Tue, 23 Jul 2013 21:18:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?IkrDs2hhbm4gQi4gR3XDsG11bmRzc29uIg==?= 
	<johannbg@gmail.com>
CC: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkrDsw==?= =?UTF-8?B?aGFubiBCLiBHdcOwbXVuZHNzb24i?= 
	<johannbg@fedoraproject.org>
Subject: Re: [PATCH 1/1] ext4: Fix Opts: (null)
References: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
In-Reply-To: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/13 5:24 PM, Jóhann B. Guðmundsson wrote:
> null null null no more Opts: (null) but something that actually makes sense to
> human beings...

It's not clear to me how this changes the (null) output...
Have you tested it?  What's the difference in output?

-Eric

> Signed-off-by: Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
> ---
>  fs/ext4/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 85b3dd6..ef141b7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4088,8 +4088,8 @@ no_journal:
>  				 "the device does not support discard");
>  	}
>  
> -	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> -		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> +	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s "
> +		 "%s%s%s mount option(s)", descr, sbi->s_es->s_mount_opts,
>  		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
>  
>  	if (es->s_error_count)
> @@ -4866,7 +4866,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	}
>  #endif
>  
> -	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
> +	ext4_msg(sb, KERN_INFO, "re-mounted %s mount option(s)", orig_data);

>  	kfree(orig_data);
>  	return 0;
>  
> 

