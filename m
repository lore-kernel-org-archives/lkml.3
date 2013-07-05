Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3GES4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:56:22 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13345 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3GES4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:56:20 -0400
Message-ID: <51D716C7.1070706@hp.com>
Date: Fri, 05 Jul 2013 14:56:07 -0400
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
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <20130705150224.GS4165@ZenIV.linux.org.uk> <51D6E646.6020703@hp.com> <20130705175456.GT4165@ZenIV.linux.org.uk>
In-Reply-To: <20130705175456.GT4165@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:54 PM, Al Viro wrote:
> On Fri, Jul 05, 2013 at 11:29:10AM -0400, Waiman Long wrote:
>>> I've just pushed such commit into vfs.git#for-linus; please, do the rest
>>> on top of it.  And keep it bisectable, i.e. so that at any intermediate
>>> point the tree would build and work.
>> I am sorry. I didn't change anything in the dentry structure in
>> patch 3. So putting patches 4-11 on top of it won't break the build.
> *gyah*...  I'd missed the !@#!# macro you've added there.  Could you
> explain the reasons for using it at all?  Not to mention anything
> else, you've missed
> #  define d_refcount(d)                 ((d)->d_count)
> in Lustre.  What's the point of your macro (d_refcount ->  d_count), anyway?
> All references outside of fs/namei.c, fs/dcache.c, include/linux/dcache.h
> should be via d_count(dentry) anyway...

I am sorry that I am still using the latest 3.10 bits that I pull in 
last week as the basis for my patchset. I want to get my changes 
stabilized before looking at the latest bits. So I did missed the latest 
3.11 bits that are merged this week including the Lustre change that you 
mentioned. I will pull in the latest bit and rebase my patch on top of 
it. I guess I also need to make changes to that d_refcount() macro as 
well as codes that reference it. Are you aware of other upcoming patches 
that may conflict with my patch?

The d_refcount macro in patch 3 is to make the name change first so that 
I don't need to change them in the last patch. This is to make the last 
patch easier to review by moving those irrelevant name changes away from it.

Regards,
Longman
