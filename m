Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaGMVoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:44:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33840 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGMVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:44:03 -0400
Message-ID: <53C2FD71.7090102@oracle.com>
Date: Sun, 13 Jul 2014 17:43:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com,
        stable@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
References: <alpine.LSU.2.11.1407092358090.18131@eggly.anvils> <53BE8B1B.3000808@oracle.com> <53BECBA4.3010508@oracle.com> <alpine.LSU.2.11.1407101033280.18934@eggly.anvils> <53BED7F6.4090502@oracle.com> <alpine.LSU.2.11.1407101131310.19154@eggly.anvils> <53BEE345.4090203@oracle.com> <20140711082500.GB20603@laptop.programming.kicks-ass.net> <53BFD708.1040305@oracle.com> <alpine.LSU.2.11.1407110745430.2054@eggly.anvils> <20140711155958.GR20603@laptop.programming.kicks-ass.net>
In-Reply-To: <20140711155958.GR20603@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 11:59 AM, Peter Zijlstra wrote:
>>> I agree with you that "The call trace is very clear on it that its not", but
>>> > > when you have 500 call traces you really want something better than going
>>> > > through it one call trace at a time.
>> > 
>> > Points well made, and I strongly agree with Vlastimil and Sasha.
>> > There is a world of difference between a lock wanted and a lock held,
>> > and for the display of locks "held" to conceal that difference is unhelpful.
>> > It just needs one greppable word to distinguish the cases.
> So for the actual locking scenario it doesn't make a difference one way
> or another. These threads all can/could/will acquire the lock
> (eventually), so all their locking chains should be considered.

I think that the difference here is that we're not actually debugging a locking
issue, we're merely using lockdep to help with figuring out a non-locking
related bug and finding it difficult because lockdep's list of "held locks"
is really a lie :)


Thanks,
Sasha
