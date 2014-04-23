Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaDWBwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:52:03 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:24904 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755239AbaDWBwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:52:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,907,1389715200"; 
   d="scan'208";a="29601427"
Message-ID: <53571DA5.1010603@cn.fujitsu.com>
Date: Wed, 23 Apr 2014 09:55:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 2/4] idr: reduce the number of MAX_IDR_FREE
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com> <1398161781-12105-3-git-send-email-laijs@cn.fujitsu.com> <20140422195821.GB2314@mtj.dyndns.org>
In-Reply-To: <20140422195821.GB2314@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 03:58 AM, Tejun Heo wrote:
> On Tue, Apr 22, 2014 at 06:16:19PM +0800, Lai Jiangshan wrote:
>> +/*
>> + * Number of idr_layer structs to leave in free list.
>> + * When idr is not empty, we need atmost (MAX_IDR_LEVEL - 1) idr_layers
>> + * to build up and atmost (MAX_IDR_LEVEL - 1) idr_layers to allocate down.
>> + * When idr is empty need atmost MAX_IDR_LEVEL layers.
>> + */
>> +#define MAX_IDR_FREE max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL)
> 
> I don't know.  Do we really wanna be this sophiscated about it when
> the cost of mistake would be an unexpected id allocation failure which
> would *EXTREMELY* difficult to track down or reproduce?  Let's please
> keep it dumb and safe.

Do you mean "I need additional free layers to
hide any possible bugs"? let me nervous.

> With preloading we aren't even caching it
> per-idr.  I don't think this is something we want to do.

Understood.

> 
>  Nacked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 

