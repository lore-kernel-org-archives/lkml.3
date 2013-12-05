Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3LEBVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:21:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab3LEBVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:21:42 -0500
X-IronPort-AV: E=Sophos;i="4.93,829,1378828800"; 
   d="scan'208";a="9193798"
Message-ID: <529FD388.7030907@cn.fujitsu.com>
Date: Thu, 05 Dec 2013 09:14:48 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Benjamin <bcrl@kvack.org>,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kent <kmo@daterainc.com>,
        Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: Re: [PATCH] aio: clean up aio ring in the fail path
References: <529F019A.2040401@cn.fujitsu.com> <20131204145416.GA22438@redhat.com>
In-Reply-To: <20131204145416.GA22438@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/05 09:21:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/05 09:21:32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 12/04/2013 10:54 PM, Dave Jones wrote:

> On Wed, Dec 04, 2013 at 06:19:06PM +0800, Gu Zheng wrote:
>  > Clean up the aio ring file in the fail path of aio_setup_ring
>  > and ioctx_alloc. And maybe it can fix the GPF issue reported by
>  > Dave Jones:
>  > https://lkml.org/lkml/2013/11/25/898
>  > 
>  > 
>  > Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>  > ---
>  >  fs/aio.c |    8 ++++++--
>  >  1 files changed, 6 insertions(+), 2 deletions(-)
>  > 
>  > diff --git a/fs/aio.c b/fs/aio.c
>  > index 08159ed..6efb7f6 100644
>  > --- a/fs/aio.c
>  > +++ b/fs/aio.c
>  > @@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx *ctx)
>  >  	if (nr_pages > AIO_RING_PAGES) {
>  >  		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
>  >  					  GFP_KERNEL);
>  > -		if (!ctx->ring_pages)
>  > +		if (!ctx->ring_pages) {
>  > +			put_aio_ring_file(ctx);
>  >  			return -ENOMEM;
>  > +		}
>  >  	}
>  >  
> 
>   CC      fs/aio.o
> fs/aio.c: In function ‘aio_setup_ring’:
> fs/aio.c:363:4: error: implicit declaration of function ‘put_aio_ring_file’ [-Werror=implicit-function-declaration]
>     put_aio_ring_file(ctx);
> 
> 
> Is this dependant on another patch ?

It's applied on 3.12-rc2. Please ignore the previous defective patch I sent
before, and try again.

Regards,
Gu

> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


