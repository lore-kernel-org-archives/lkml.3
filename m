Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab3ICVBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:01:23 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36552 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506Ab3ICVBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:01:22 -0400
Message-ID: <52264E10.9050105@hp.com>
Date: Tue, 03 Sep 2013 17:01:04 -0400
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
References: <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com> <5225FCEE.7030901@hp.com> <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com> <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
In-Reply-To: <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 03:09 PM, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 8:34 AM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> I suspect the tty_ldisc_lock() could be made to go away if we care.
> Heh. I just pulled the tty patches from Greg, and the locking has
> changed completely.
>
> It may actually fix your AIM7 test-case, because while the global
> spinlock remains (it got renamed to "tty_ldiscs_lock" - there's an
> added "s"), the common operations now take the per-tty lock to get the
> ldisc for that tty, rather than that global spinlock (which just
> protects the actual ldisk array now).
>
> That said, I don't know what AIM7 really ends up doing, but your
> profile seems to have every access through tty_ldisc_[de]ref() that
> now uses only the per-tty lock. Of course, how much that helps ends up
> depending on whether AIM7 uses lots of tty's or just one shared one.
>
> Anyway, it might be worth testing my current -git tree.
>
>                    Linus

Thank for the news. I will fetch your latest git tree and try it out.

-Longman
