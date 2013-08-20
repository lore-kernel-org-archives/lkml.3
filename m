Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3HTFmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:42:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34328 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3HTFmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:42:47 -0400
X-Spam-Score: -101.1
Message-ID: <52130194.4030903@asianux.com>
Date: Tue, 20 Aug 2013 13:41:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: mempolicy: the failure processing about mpol_to_str()
References: <5212E8DF.5020209@asianux.com> <20130820053036.GB18673@moon>
In-Reply-To: <20130820053036.GB18673@moon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 01:30 PM, Cyrill Gorcunov wrote:
> On Tue, Aug 20, 2013 at 11:56:15AM +0800, Chen Gang wrote:
>> For the implementation (patch 1/3), need fill buffer as full as
>> possible when buffer space is not enough.
>>
>> For the caller (patch 2/3, 3/3), need check the return value of
>> mpol_to_str().
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Won't simple check for mpol_to_str() < 0 be enough? IOW fix all
> callers to check that mpol_to_str exit without errors. As far
> as I see here are only two users. Something like
> 
> show_numa_map
> 	ret = mpol_to_str();
> 	if (ret)
> 		return ret;
> 
> shmem_show_mpol
> 	ret = mpol_to_str();
> 	if (ret)
> 		return ret;
> 

need "if (ret < 0)" instead of.  ;-)

> sure you'll have to change shmem_show_mpol statement to return int code.
> Won't this be more short and convenient?
> 
> 

Hmm... if return -ENOSPC, in common processing, it still need continue
(but need let outside know about the string truncation).

So I still suggest to give more check for it.


Thanks.
-- 
Chen Gang
