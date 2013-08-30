Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3H3UgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:36:07 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:6946 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H3UgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:36:05 -0400
Message-ID: <52210225.60805@hp.com>
Date: Fri, 30 Aug 2013 16:35:49 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
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
References: <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com> <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk>
In-Reply-To: <20130830202608.GD13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 04:26 PM, Al Viro wrote:
> On Fri, Aug 30, 2013 at 03:52:49PM -0400, Waiman Long wrote:
>
>> So it is the mnput_no_expire() function that is doing all the
>> lg_global_lock() calls.
> Interesting...  So you are getting a lot of mntput() with ->mnt_ns being
> NULL?  I wonder which type it is...  Note that anything mounted will
> have non-NULL ->mnt_ns until umount and anything obtained via
> kern_mount/kern_mount_data will also have a non-NULL ->mnt_ns - until
> kern_unmount().
>
> Could you try to gather stats of that sort?  Normally that path should
> be only hit by fput() when we have a lazy-unmounted fs and close an opened
> file on it...
>
> I see one potential stupidity in that area (simple_pin_fs() ought to set
> ->mnt_ns, with simple_release_fs() clearing it), but there's not a lot
> of fs types that would use the damn thing...

The AIM7 test was run on a set of 16 ramdisk formated with ext3 
filesystem with the following mount options: 
barrier=0,async,noatime,nodiratime. Maybe that is a factor.

Regards,
Longman
