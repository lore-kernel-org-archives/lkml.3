Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaJNFPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 01:15:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42490 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaJNFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 01:15:33 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 14 Oct 2014 14:15:55 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan.kim@lge.com>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, juno.choi@lge.com,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luigi Semenzato <semenzato@google.com>,
        "seungho1.park" <seungho1.park@lge.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v4] zsmalloc: merge size_class to reduce fragmentation
Message-ID: <20141014051554.GA3692@js1304-P5Q-DELUXE>
References: <1411976727-29421-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140929231022.GC18318@bbox>
 <20141002053949.GC7433@js1304-P5Q-DELUXE>
 <20141002054426.GA4515@bbox>
 <CALZtONAX0sXvynpWvg+MNayhNnoh=F2vc=MCQLEovfiU6x-HuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZtONAX0sXvynpWvg+MNayhNnoh=F2vc=MCQLEovfiU6x-HuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:47:51AM -0400, Dan Streetman wrote:
> >> I think that using ref would makes intuitive code. Although there is
> >> some memory overhead, it is really small. So I prefer to this way.
> >>
> >> But, if you think that removing ref is better, I will do it.
> >> Please let me know your final decision.
> >
> > Yeb, please remove the ref. I want to keep size_class small for
> > cache footprint.
> 
> i think a foreach_size_class() would be useful for zs_destroy_pool(),
> and in case any other size class iterations are added in the future,
> and it wouldn't require the extra ref field.  You can use the fact
> that all merged size classes contain a class->index of the
> highest/largest size_class (because they all point to the same size
> class).  So something like:

Hello,

Using class->index looks good idea, but, I'd like not to add new
macro here, because, it isn't needed in other place now.

Thanks.

