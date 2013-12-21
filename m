Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3LUQDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:03:48 -0500
Received: from bitsync.net ([80.83.126.10]:52365 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3LUQDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:03:46 -0500
Message-ID: <52B5BBDF.9010200@bitsync.net>
Date: Sat, 21 Dec 2013 17:03:43 +0100
From: Zlatko Calusic <zcalusic@bitsync.net>
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] Configurable fair allocation zone policy v2r6
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <52B068B7.4070304@bitsync.net> <20131217212327.GL11295@suse.de>
In-Reply-To: <20131217212327.GL11295@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2013 22:23, Mel Gorman wrote:
> On Tue, Dec 17, 2013 at 04:07:35PM +0100, Zlatko Calusic wrote:
>> On 13.12.2013 15:10, Mel Gorman wrote:
>>> Kicked this another bit today. It's still a bit half-baked but it restores
>>> the historical performance and leaves the door open at the end for playing
>>> nice with distributing file pages between nodes. Finishing this series
>>> depends on whether we are going to make the remote node behaviour of the
>>> fair zone allocation policy configurable or redefine MPOL_LOCAL. I'm in
>>> favour of the configurable option because the default can be redefined and
>>> tested while giving users a "compat" mode if we discover the new default
>>> behaviour sucks for some workload.
>>>
>>
>> I'll start a 5-day test of this patchset in a few hours, unless you
>> can send an updated one in the meantime. I intend to test it on a
>> rather boring 4GB x86_64 machine that before Johannes' work had lots
>> of trouble balancing zones. Would you recommend to use the default
>> settings, i.e. don't mess with tunables at this point?
>>
>
> For me at least I would prefer you tested v3 of the series with the
> default settings of not interleaving file-backed pages on remote nodes
> by default. Johannes might request testing with that knob enabled if the
> machine is NUMA although I doubt it is with 4G of RAM.
>

Tested v3 on UMA machine, with default setting. I see no regression, no 
issues whatsoever. From what I understand, this whole series is about 
fixing issues noticed on NUMA, so I wish you good luck with that (no 
such hardware here). Just be extra careful not to disturb finally very 
well balanced MM on more common machines (and especially those equipped 
with 4GB RAM). And once again thank you Johannes for your work, you did 
a great job.

Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
-- 
Zlatko

