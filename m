Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaDVT62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:58:28 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:58404 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaDVT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:25 -0400
Date: Tue, 22 Apr 2014 15:58:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 2/4] idr: reduce the number of MAX_IDR_FREE
Message-ID: <20140422195821.GB2314@mtj.dyndns.org>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
 <1398161781-12105-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398161781-12105-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:16:19PM +0800, Lai Jiangshan wrote:
> +/*
> + * Number of idr_layer structs to leave in free list.
> + * When idr is not empty, we need atmost (MAX_IDR_LEVEL - 1) idr_layers
> + * to build up and atmost (MAX_IDR_LEVEL - 1) idr_layers to allocate down.
> + * When idr is empty need atmost MAX_IDR_LEVEL layers.
> + */
> +#define MAX_IDR_FREE max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL)

I don't know.  Do we really wanna be this sophiscated about it when
the cost of mistake would be an unexpected id allocation failure which
would *EXTREMELY* difficult to track down or reproduce?  Let's please
keep it dumb and safe.  With preloading we aren't even caching it
per-idr.  I don't think this is something we want to do.

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
