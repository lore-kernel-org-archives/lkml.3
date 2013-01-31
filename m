Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AaAKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:10:03 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47148 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3AaAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:10:00 -0500
Message-ID: <5109B64D.9050904@oracle.com>
Date: Wed, 30 Jan 2013 19:09:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hlist: drop the node parameter from iterators
References: <1358998645-20452-1-git-send-email-sasha.levin@oracle.com> <5108728E.5020901@oracle.com> <20130130154725.f7b40daa.akpm@linux-foundation.org>
In-Reply-To: <20130130154725.f7b40daa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 06:47 PM, Andrew Morton wrote:
> On Tue, 29 Jan 2013 20:08:30 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Also, ping :)
>>
>> ...
>>
>>>  216 files changed, 1031 insertions(+), 1526 deletions(-)
> 
> Whimper.
> 
> I don't really see a sane way of avoiding a single huge atomic smash
> here.  Normally we'd use a multistep process:
> 
> 1: Create a new and differently named macro, say "sasha_is_a_pita()".
> 
> 2: Convert hlist_for_each_entry() to sasha_is_a_pita() in as many
>    sites as we can.
> 
> 3: Once we think all sites are converted, delete the now-unused
>    hlist_for_each_entry() definition.
> 
> Problem is, there just isn't any other identifier we can use here apart
> from hlist_for_each_entry().
> 
> I suppose we could add additional steps:
> 
> 4: Add hlist_for_each_entry(), which is identical to sasha_is_a_pita().
> 
> 5: Convert sasha_is_a_pita() to hlist_for_each_entry() in as many
>    sites as we can.
> 
> 6: Once we think all sites are converted, delete the now-unused
>    sasha_is_a_pita() definition.
> 
> But geeze.
> 
> 
> The alternative is to do the huge atomic smash immediately after the
> 3.9-rc1 release, when the amount of pending out-of-tree code is at a
> minimum.

I would accept a "it's not worth the effort" if you think it's not worth
the effort. I don't have a secret diabolic plan to make Linus and yourself
do a bunch of conflict merges because I like to see you suffer.

Regarding the multistep process, the downside there is that instead of
dealing with conflicts once you'll be dealing with them twice: once when
you move to the new macro, and once when you move back. If you think that's
preferable we can do that.

If not, should I send it over to you on -rc1?


Thanks,
Sasha

