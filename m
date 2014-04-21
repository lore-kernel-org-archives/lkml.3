Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaDUGLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:11:19 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:6460 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080AbaDUGLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:11:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,895,1389715200"; 
   d="scan'208";a="29508664"
Message-ID: <5354B627.2090201@cn.fujitsu.com>
Date: Mon, 21 Apr 2014 14:09:43 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        <shli@kernel.org>, <bob.liu@oracle.com>, <sjenning@linux.vnet.ibm.com>,
        <iamjoonsoo.kim@lge.com>, <aquini@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, <khalid.aziz@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/swap: cleanup *lru_cache_add* functions
References: <1397835565-6411-1-git-send-email-nasa4836@gmail.com> <53546DA3.2080709@cn.fujitsu.com> <CAHz2CGWVo9ZXDY7S5_OU-6C1syiMuXX4qCpMUM+YCMkDUcSSZg@mail.gmail.com>
In-Reply-To: <CAHz2CGWVo9ZXDY7S5_OU-6C1syiMuXX4qCpMUM+YCMkDUcSSZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 12:02 PM, Jianyu Zhan wrote:
> Hi,  Yanfei,
> 
> On Mon, Apr 21, 2014 at 9:00 AM, Zhang Yanfei
> <zhangyanfei@cn.fujitsu.com> wrote:
>> What should be exported?
>>
>> lru_cache_add()
>> lru_cache_add_anon()
>> lru_cache_add_file()
>>
>> It seems you only export lru_cache_add_file() in the patch.
> 
> Right, lru_cache_add_anon() is only used by VM code, so it should not
> be exported.
> 
> lru_cache_add_file() and lru_cache_add() are supposed to be used by
> vfs ans fs code.
> 
> But  now only lru_cache_add_file() is  used by CIFS and FUSE, which
> both could be
> built as module, so it must be exported;  and lru_cache_add() has now
> no module users,
> so as Rik suggests, it is unexported too.
> 

OK. So The sentence in the patch log confused me:

[ However, lru_cache_add() is supposed to
be used by vfs, or whatever others, but it is not exported.]

otherwise, 
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Thanks.

-- 
Thanks.
Zhang Yanfei
