Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3GDOvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:51:45 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:36159 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3GDOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:51:43 -0400
Message-ID: <51D58BF1.1050202@hp.com>
Date: Thu, 04 Jul 2013 10:51:29 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ian Kent <raven@themaw.net>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 04/12] auto-fs: rename d_count field of dentry to d_refcount
References: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com> <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com> <20130704045956.GO4165@ZenIV.linux.org.uk>
In-Reply-To: <20130704045956.GO4165@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 12:59 AM, Al Viro wrote:
> On Wed, Jul 03, 2013 at 08:50:07PM -0700, Linus Torvalds wrote:
>> On Wed, Jul 3, 2013 at 8:33 PM, Waiman Long<Waiman.Long@hp.com>  wrote:
>>> Because of the d_count name change made in dcache.h, all references
>>> to d_count have to be changed to d_refcount.  There is no change in
>>> logic and everything should just work.
>> These filesystem patches need to be just joined into the same patch
>> that does the d_count ->  d_refcount change.
>>
>> Otherwise the kernel won't build in lots of configurations for some
>> commits, which makes things like bisecting much more painful than it
>> should be.
>>
>> So we can't do piece-meal changes that break the build for parts of the tree.
> Frankly, my preference here would be to add static inline unsigned d_count(...)
> and convert the uses of ->d_count outside of fs/{dcache.c,namei.c} and
> include/linux/dcache.c to it as the first commit.  All users outside those
> are readers, so there's no point playing with macros in this case...

Yes, I could do that.

Regards,
Longman


