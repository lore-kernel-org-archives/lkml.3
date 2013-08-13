Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3HMTG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:06:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50252 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab3HMTGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:06:25 -0400
Message-ID: <520A83B0.40607@sgi.com>
Date: Tue, 13 Aug 2013 12:06:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nathan Zimmer <nzimmer@sgi.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com> <1376344480-156708-1-git-send-email-nzimmer@sgi.com> <CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com> <520A6DFC.1070201@sgi.com> <CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com> <520A7514.9020008@sgi.com>
In-Reply-To: <520A7514.9020008@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/13/2013 11:04 AM, Mike Travis wrote:
> 
> 
> On 8/13/2013 10:51 AM, Linus Torvalds wrote:
>> by the time you can log in. And if it then takes another ten minutes
>> until you have the full 16TB initialized, and some things might be a
>> tad slower early on, does anybody really care?  The machine will be up
>> and running with plenty of memory, even if it may not be *all* the
>> memory yet.
> 
> Before the patches adding memory took ~45 mins for 16TB and almost 2 hours
> for 32TB.  Adding it late sped up early boot but late insertion was still
> very slow, where the full 32TB was still not fully inserted after an hour.
> Doing it in parallel along with the memory hotplug lock per node, we got
> it down to the 10-15 minute range.
> 

FYI, the system at this time had 128 nodes each with 256GB of memory.
About 252GB was inserted into the absent list from nodes 1 .. 126.
Memory on nodes 0 and 128 was left fully present.
