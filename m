Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3GEP3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:29:25 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35159 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3GEP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:29:24 -0400
Message-ID: <51D6E646.6020703@hp.com>
Date: Fri, 05 Jul 2013 11:29:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 00/12] Lockless update of reference count protected
 by spinlock
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <20130705150224.GS4165@ZenIV.linux.org.uk>
In-Reply-To: <20130705150224.GS4165@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 11:02 AM, Al Viro wrote:
> On Fri, Jul 05, 2013 at 10:47:33AM -0400, Waiman Long wrote:
>> v4->v5:
>>   - Add a d_count() helper for readonly access of reference count and
>>     change all references to d_count outside of dcache.c, dcache.h
>>     and namei.c to use d_count().
> Sigh...  You are breaking bisectability again.  This helper should
> be introduced *first*, along with conversion to it.  Then you can
> do the rest on top of that.
>
> I've just pushed such commit into vfs.git#for-linus; please, do the rest
> on top of it.  And keep it bisectable, i.e. so that at any intermediate
> point the tree would build and work.

I am sorry. I didn't change anything in the dentry structure in patch 3. 
So putting patches 4-11 on top of it won't break the build.

Regards,
Longman
