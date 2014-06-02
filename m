Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaFBRnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:43:04 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:18455 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFBRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:42:56 -0400
Message-ID: <538CB78A.8090500@hp.com>
Date: Mon, 02 Jun 2014 13:42:34 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>  <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>  <20140602162525.GH16155@laptop.programming.kicks-ass.net>  <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com> <1401729145.5185.5.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1401729145.5185.5.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 01:12 PM, Davidlohr Bueso wrote:
> On Mon, 2014-06-02 at 10:09 -0700, Linus Torvalds wrote:
>> On Mon, Jun 2, 2014 at 9:25 AM, Peter Zijlstra<peterz@infradead.org>  wrote:
>>> And I can't say I'm a particular fan of these ops either, as alternative
>>> I'm almost inclined to just exclude parisc from using opt spinning.
>> Please do.
> I agree, this is the best way out of this mess. Furthermore, it would
> also be nice to consolidate opt spinning in a common CONFIG option --
> right now mutexes and rwsems create their own dependencies.
>

I would suggest adding a RWSEM_SPIN_ON_OWNER to control opt spinning in 
rwsem. Currently MUTEX_SPIN_ON_OWNER is doing that for mutex, and it is 
disabled when mutex debugging is turned on. So I think it is better to 
allow them to be disabled separately.

-Longman
