Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3HOMCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:02:34 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50439 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3HOMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <520C9E78.2020401@gmail.com>
References: <52050382.9060802@gmail.com>
	<520BB225.8030807@gmail.com>
	<20130814174039.GA24033@dhcp22.suse.cz>
	<CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com>
	<20130814182756.GD24033@dhcp22.suse.cz>
	<CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
	<520C9E78.2020401@gmail.com>
Date: Thu, 15 Aug 2013 05:02:31 -0700
X-Google-Sender-Auth: yJIgt62XR_1HYWjodHy1FU8q8RM
Message-ID: <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert 53a59fc67!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Tebulin <tebulin@googlemail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 2:25 AM, Ben Tebulin <tebulin@googlemail.com> wrote:
>
> I just cherry-picked e6c495a96ce0 into 3.9.11 and 3.7.10.
> Unfortunately this does _not resolve_ my issue (too good to be true) :-(

Ho humm. I've found at least one other bug, but that one only affects
hugepages. Do you perhaps have transparent hugepages enabled? But even
then it looks quite unlikely.

I'll think about this some more. I'm not happy with how that
particular whole TLB flushing hack was done, but I need to sleep on
this.

              Linus
