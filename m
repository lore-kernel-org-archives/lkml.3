Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaCKNXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:23:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34880 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbaCKNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:23:39 -0400
Message-ID: <531F0E39.9020100@oracle.com>
Date: Tue, 11 Mar 2014 09:23:05 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, Dave Jones <davej@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
References: <20140305174503.GA16335@redhat.com> <20140305175725.GB16335@redhat.com> <20140307002210.GA26603@redhat.com> <20140311024906.GA9191@redhat.com> <20140310201340.81994295.akpm@linux-foundation.org> <20140310214612.3b4de36a.akpm@linux-foundation.org> <20140311045109.GB12551@redhat.com> <20140310220158.7e8b7f2a.akpm@linux-foundation.org> <20140311053017.GB14329@redhat.com> <20140311132024.GC32390@moon>
In-Reply-To: <20140311132024.GC32390@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 09:20 AM, Cyrill Gorcunov wrote:
> On Tue, Mar 11, 2014 at 01:30:17AM -0400, Dave Jones wrote:
>>   > >  >
>>   > >  > I don't see any holes in regular migration.  Do you know if this is
>>   > >  > reproducible with CONFIG_NUMA_BALANCING=n or CONFIG_NUMA=n?
>>   > >
>>   > > CONFIG_NUMA_BALANCING was n already btw, so I'll do a NUMA=n run.
>>   >
>>   > There probably isn't much point unless trinity is using
>>   > sys_move_pages().  Is it?  If so it would be interesting to disable
>>   > trinity's move_pages calls and see if it still fails.
>>
>> Ok, with move_pages excluded it still oopses.
>
> Dave, is it possible to somehow figure out was someone reading pagemap file
> at moment of the bug triggering?

We can sprinkle printk()s wherever might be useful, might not be 100% accurate but
should be close enough to confirm/deny the theory.


Thanks,
Sasha

