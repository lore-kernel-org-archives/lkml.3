Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3H0JFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:05:40 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36563 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3H0JFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:05:38 -0400
MIME-Version: 1.0
In-Reply-To: <521BCD7F.8010501@surriel.com>
References: <20130819160058.539049611@infradead.org> <20130819160425.672255367@infradead.org>
 <CAPM31RLOX9NSaHK9+ysC6yDXvAj2swaoXmg6hHHpMdOJjWBFrQ@mail.gmail.com>
 <20130826120919.GL31370@twins.programming.kicks-ass.net> <521BCD7F.8010501@surriel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 27 Aug 2013 02:05:06 -0700
Message-ID: <CAPM31RJmV1vhcpUJ8s1mmB-F9z__TRj+BuxjYkPFd75zkudwvg@mail.gmail.com>
Subject: Re: [PATCH 09/10] sched, fair: Fix the sd_parent_degenerate() code
To: Rik van Riel <riel@surriel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 2:49 PM, Rik van Riel <riel@surriel.com> wrote:
> On 08/26/2013 08:09 AM, Peter Zijlstra wrote:
>> On Sat, Aug 24, 2013 at 03:45:57AM -0700, Paul Turner wrote:
>>>> @@ -5157,6 +5158,13 @@ cpu_attach_domain(struct sched_domain *s
>>>>                         tmp->parent = parent->parent;
>>>>                         if (parent->parent)
>>>>                                 parent->parent->child = tmp;
>>>> +                       /*
>>>> +                        * Transfer SD_PREFER_SIBLING down in case of a
>>>> +                        * degenerate parent; the spans match for this
>>>> +                        * so the property transfers.
>>>> +                        */
>>>> +                       if (parent->flags & SD_PREFER_SIBLING)
>>>> +                               tmp->flags |= SD_PREFER_SIBLING;
>>>>                         destroy_sched_domain(parent, cpu);
>>>>                 } else
>>>>                         tmp = tmp->parent;
>>>>
>>>
>>> Reviewed-by: Paul Turner <pjt@google.com>
>>
>> BTW, did that comment make sense to you or would you suggest something
>> different? I had/am having a hard time with that comment. Somehow it
>> leaves me wanting. I know I understand the issue now, but I'll doubt the
>> comment will suffice in a years time :/
>
> The comment made sense to me :)

It makes sense once you read the code.  That we push down is somehow
counter intuitive in the reading.

>
> --
> All rights reversed.
