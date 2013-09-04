Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3IDTZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:25:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6919 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3IDTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:25:52 -0400
Message-ID: <5227892B.7030906@hp.com>
Date: Wed, 04 Sep 2013 15:25:31 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com> <5225FCEE.7030901@hp.com> <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com> <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com> <52274943.1040005@hp.com> <CA+55aFyY-KEvqYze56Vw4wiznEBaxjRqHFT6aVxbu_U3k66BdQ@mail.gmail.com>
In-Reply-To: <CA+55aFyY-KEvqYze56Vw4wiznEBaxjRqHFT6aVxbu_U3k66BdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 11:14 AM, Linus Torvalds wrote:
> On Wed, Sep 4, 2013 at 7:52 AM, Waiman Long<waiman.long@hp.com>  wrote:
>> The latest tty patches did work. The tty related spinlock contention is now
>> completely gone. The short workload can now reach over 8M JPM which is the
>> highest I have ever seen.
> Good. And this was with the 80-core machine, so there aren't any
> scalability issues hiding?
>
>               Linus

Yes, the perf profile was taking from an 80-core machine. There isn't 
any scalability issue hiding for the short workload on an 80-core machine.

However, I am certain that more may pop up when running in an even 
larger machine like the prototype 240-core machine that our team has 
been testing on.

-Longman
