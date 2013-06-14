Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3FNQw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:52:56 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:53693 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab3FNQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:52:43 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51BB4A53.4000505@yandex-team.ru>
Date: Fri, 14 Jun 2013 20:52:35 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Pekka Enberg <penberg@kernel.org>, mpm@selenic.com,
        akpm@linux-foundation.org, mgorman@suse.de,
        David Rientjes <rientjes@google.com>, glommer@gmail.com,
        hannes@cmpxchg.org, minchan@kernel.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com> <51BB33FE.1020403@yandex-team.ru> <0000013f43718d4d-7bb260e7-8115-4891-bb26-6febacb7169d-000000@email.amazonses.com>
In-Reply-To: <0000013f43718d4d-7bb260e7-8115-4891-bb26-6febacb7169d-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.2013 20:08, Christoph Lameter wrote:
> On Fri, 14 Jun 2013, Roman Gushchin wrote:
>
>> But there is an actual problem, that this patch solves.
>> Sometimes I saw the following issue on some machines:
>> all CPUs are performing compaction, system time is about 80%,
>> system is completely unreliable. It occurs only on machines
>> with specific workload (distributed data storage system, so,
>> intensive disk i/o is performed). A system can fall into
>> this state fast and unexpectedly or by progressive degradation.
>
> Well that is not a slab allocator specific issue but related to compaction
> concurrency. Likely cache line contention is causing a severe slowday. But
> that issue could be triggered by any subsystem that does lots of memory
> allocations. I would suggest that we try to address the problem in the
> compaction logic rather than modifying allocators.

I agree, that it's good to address the original issue. But I'm not sure,
that it's a compaction issue. If someone wants to participate here,
I can provide more information. The main problem here is that it's
__very__ hard to reproduce the issue.

But, I think, all that shouldn't stop us from modifying the allocator.
Falling back to minimal order is in any case better than running
direct compaction. Just because it's faster. Am I wrong?

Regards,
Roman
