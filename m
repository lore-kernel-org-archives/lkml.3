Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaFWDAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:00:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48335 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaFWDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:00:17 -0400
Message-ID: <53A7983A.9000105@gmail.com>
Date: Mon, 23 Jun 2014 11:00:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Anton Altaparmakov <anton@tuxera.com>
CC: linux-ntfs-dev@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>,
        "lennox.wu@gmail.com >> Lennox Wu" <lennox.wu@gmail.com>
Subject: Re: [PATCH] fs/ntfs: Use '%tx' instead of '%zx'
References: <53A7845F.40404@gmail.com> <1403487989.18747.30.camel@joe-AO725>
In-Reply-To: <1403487989.18747.30.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/23/2014 09:46 AM, Joe Perches wrote:
> Please make sure to cc the specific maintainer
> 
> $ ./scripts/get_maintainer.pl -f fs/ntfs/
> Anton Altaparmakov <anton@tuxera.com> (supporter:NTFS FILESYSTEM)
> linux-ntfs-dev@lists.sourceforge.net (open list:NTFS FILESYSTEM)
> linux-kernel@vger.kernel.org (open list)
> 
> (cc'ing Anton)
> 

Yes, I have sent to specific maintainer.


> btw Anton, it seems ntfs_debug does not terminate
> messages with a "\n".  That means that messages
> could be interleaved with other output.
> 
> Maybe this patch as well as Chen Gang's below should be applied
> ---
>  fs/ntfs/debug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
> index dd6103c..1e824f0 100644
> --- a/fs/ntfs/debug.c
> +++ b/fs/ntfs/debug.c
> @@ -126,7 +126,8 @@ void __ntfs_debug (const char *file, int line, const char *function,
>  	va_start(args, fmt);
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
> -	pr_debug("(%s, %d): %s(): %pV", file, line, flen ? function : "", &vaf);
> +	pr_debug("(%s, %d): %s(): %pV\n",
> +		 file, line, flen ? function : "", &vaf);
>  	va_end(args);
>  }
>  

Hmm... at least, the patch above is fine to me.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
