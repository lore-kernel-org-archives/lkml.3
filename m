Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab3DKJH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:07:29 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64918 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab3DKJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:07:22 -0400
Date: Thu, 11 Apr 2013 11:07:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
Message-ID: <20130411090717.GA14491@gmail.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
 <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
 <20130408124223.GA10093@gmail.com>
 <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
 <5163042F.9000404@hp.com>
 <20130410103144.GC28505@gmail.com>
 <51658ADB.4050204@hp.com>
 <20130410171654.GD21951@gmail.com>
 <5165D8F4.7010701@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5165D8F4.7010701@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> BTW, I have also been thinking about extracting the spinlock out from the mutex 
> structure for some busy mutex by adding a pointer to an external auxiliary 
> structure (separately allocated at init time). The idea is to use the external 
> spinlock if available. Otherwise, the internal one will be used. That should 
> reduce cacheline contention for some of the busiest mutex. The spinner queuing 
> tickets can be in the external structure too. However, it requires a one line 
> change in each of the mutex initialization code. I haven't actually made the 
> code change and try it yet, but that is something that I am thinking of doing 
> when I have time.

I'm not sure per mutex allocations are a really good idea - we like our locking 
primitives to be simple, embeddable into data structures and allocatable together 
with the data structure with no other separate memory footprint.

Thanks,

	Ingo
