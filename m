Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3HOMh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:37:28 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52705 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3HOMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:37:24 -0400
Message-ID: <520CCB80.6090508@gmail.com>
Date: Thu, 15 Aug 2013 14:37:20 +0200
From: Ben Tebulin <tebulin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert
 53a59fc67!
References: <52050382.9060802@gmail.com> <520BB225.8030807@gmail.com> <20130814174039.GA24033@dhcp22.suse.cz> <CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com> <20130814182756.GD24033@dhcp22.suse.cz> <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com> <520C9E78.2020401@gmail.com> <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
In-Reply-To: <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.08.2013 14:02, schrieb Linus Torvalds:
>> I just cherry-picked e6c495a96ce0 into 3.9.11 and 3.7.10.
>> Unfortunately this does _not resolve_ my issue (too good to be true) :-(
> Ho humm. I've found at least one other bug, but that one only affects
> hugepages. Do you perhaps have transparent hugepages enabled? 

I was using the Ubuntu mainline Kernel config:

   ben@n179 ~/p/linux.git> cat .config | grep TRANSPARENT_HUG
   CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
   CONFIG_TRANSPARENT_HUGEPAGE=y
   # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
   CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y

> I'll think about this some more. I'm not happy with how that
> particular whole TLB flushing hack was done, but I need to sleep on
> this.

Thanks!

Being an end user having only a very limited understanding of the
internals behind this issue, I really appreciate any support I receive
from people who do. :-)
