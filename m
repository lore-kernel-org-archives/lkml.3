Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaBHUE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:04:27 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:43290 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaBHUEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:04:25 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:04:12 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 01/13] net: Mark function as static in 9p/client.c
Message-ID: <20140208200412.GA20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:17:21AM +0530, Rashika Kheria wrote:
> Mark function as static in net/9p/client.c because it is not used
> outside this file.
> 
> This eliminates the following warning in net/9p/client.c:
> net/9p/client.c:207:18: warning: no previous prototype for ‘p9_fcall_alloc’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  net/9p/client.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index a5e4d2d..9186550 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -204,7 +204,7 @@ free_and_return:
>  	return ret;
>  }
>  
> -struct p9_fcall *p9_fcall_alloc(int alloc_msize)
> +static struct p9_fcall *p9_fcall_alloc(int alloc_msize)
>  {
>  	struct p9_fcall *fc;
>  	fc = kmalloc(sizeof(struct p9_fcall) + alloc_msize, GFP_NOFS);
> -- 
> 1.7.9.5
> 
