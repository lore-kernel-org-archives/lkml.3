Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab3DJPxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:53:04 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4609 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab3DJPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:53:03 -0400
Message-ID: <51658ADB.4050204@hp.com>
Date: Wed, 10 Apr 2013 11:52:59 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com> <1365087258-7169-2-git-send-email-Waiman.Long@hp.com> <20130408124223.GA10093@gmail.com> <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com> <5163042F.9000404@hp.com> <20130410103144.GC28505@gmail.com>
In-Reply-To: <20130410103144.GC28505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 06:31 AM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>>> That said, the MUTEX_SHOULD_XCHG_COUNT macro should die. Why shouldn't all
>>> architectures just consider negative counts to be locked? It doesn't matter
>>> that some might only ever see -1.
>> I think so too. However, I don't have the machines to test out other
>> architectures. The MUTEX_SHOULD_XCHG_COUNT is just a safety measure to make sure
>> that my code won't screw up the kernel in other architectures. Once it is
>> confirmed that a negative count other than -1 is fine for all the other
>> architectures, the macro can certainly go.
> I'd suggest to just remove it in an additional patch, Cc:-ing
> linux-arch@vger.kernel.org. The change is very likely to be fine, if not then it's
> easy to revert it.
>
> Thanks,
>
> 	Ingo
Yes, I can do that. So can I put your name down as reviewer or ack'er 
for the 1st patch?

BTW, I am planning to change the code to mimic the 
__mutex_slowpath_needs_to_unlock()  macro so that I only need to update 
the asm/mutex.h only instead of modifying the kernel/mutex.h as well. 
Hope that will make the change more acceptable to others in case we have 
to keep it.

Regards,
Longman
