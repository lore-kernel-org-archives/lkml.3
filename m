Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3ITQJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3ITQI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:08:58 -0400
Message-ID: <523C69F7.4030903@redhat.com>
Date: Fri, 20 Sep 2013 10:29:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, tytso@mit.edu,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ext4: fix memory leak in xattr code.
References: <20130920142918.GA21988@redhat.com>
In-Reply-To: <20130920142918.GA21988@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/13 9:29 AM, Dave Jones wrote:
> If we take the 2nd retry path in ext4_expand_extra_isize_ea, we potentionally
> return from the function without having freed these allocations.
> If we don't do the return, we over-write the previous allocation pointers, 
> so we leak either way.
> 
> Spotted with Coverity.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Looks right to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!

-Eric

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c081e34..f3a6220 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1350,6 +1350,8 @@ retry:
>  				    s_min_extra_isize) {
>  					tried_min_extra_isize++;
>  					new_extra_isize = s_min_extra_isize;
> +					kfree(is);
> +					kfree(bs);
>  					goto retry;
>  				}
>  				error = -1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

