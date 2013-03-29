Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3C2NZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:25:10 -0400
Received: from shelob.surriel.com ([74.92.59.67]:39862 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3C2NZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:25:09 -0400
Message-ID: <5155962A.9070705@surriel.com>
Date: Fri, 29 Mar 2013 09:24:58 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5150B1C2.8090607@oracle.com> <20130325163844.042a45ba@annuminas.surriel.com> <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com> <1364303965.5053.29.camel@laptop> <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com> <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com> <1364373750.5053.54.camel@laptop> <20130328162337.3003ccd4@cuia.bos.redhat.com> <CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com> <51558407.5040005@surriel.com> <CANN689FGoTF=5sbYSE7JyyS9CyyYTLrjHq5B0O23tFuCh550qg@mail.gmail.com>
In-Reply-To: <CANN689FGoTF=5sbYSE7JyyS9CyyYTLrjHq5B0O23tFuCh550qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 09:08 AM, Michel Lespinasse wrote:

>> That is where I had it initially. I may have gotten too clever
>> and worked on keeping more accesses read-only. If you want, I
>> can move it back here and re-submit the patch :)
>
> I think I would prefer that - I feel having it upper serves little
> purpose, as you still need to check it here, so we might as well be
> optimistic and check it only here. Or maybe I've missed the benefit of
> having it earlier - I just don't see it.

OK, will do.

> It still makes it possible (though less likely) that each simple semop
> taking this path might make the next one take it too, though. So, I'm
> not sure how to balance that against the starvation possibility. I'll
> leave it up to you then :)

Lets optimistically assume that userland is using the semaphores
for synchronization. That rather limits the potential for starvation.

-- 
All rights reversed.
