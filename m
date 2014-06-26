Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaFZU3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaFZU3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:29:05 -0400
Message-ID: <53AC7D54.4010407@redhat.com>
Date: Thu, 26 Jun 2014 16:06:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
References: <198dc298821a20a476656dccc85a8d77f166c61a.1403812625.git.aquini@redhat.com>
In-Reply-To: <198dc298821a20a476656dccc85a8d77f166c61a.1403812625.git.aquini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 04:00 PM, Rafael Aquini wrote:
> Historically, we exported shared pages to userspace via sysinfo(2) sharedram
> and /proc/meminfo's "MemShared" fields. With the advent of tmpfs, from kernel
> v2.4 onward, that old way for accounting shared mem was deemed inaccurate and
> we started to export a hard-coded 0 for sysinfo.sharedram. Later on, during
> the 2.6 timeframe, "MemShared" got re-introduced to /proc/meminfo re-branded
> as "Shmem", but we're still reporting sysinfo.sharedmem as that old hard-coded
> zero, which makes the "shared memory" report inconsistent across interfaces.
> 
> This patch leverages the addition of explicit accounting for pages used by
> shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat" -- in order to
> make the users of sysinfo(2) and si_meminfo*() friends aware of that
> vmstat entry and make them report it consistently across the interfaces,
> as well to make sysinfo(2) returned data consistent with our current API
> documentation states.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>
