Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3JEHev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 03:34:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4295 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3JEHeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 03:34:50 -0400
X-Spam-Score: -100.9
Message-ID: <524FC0D4.9070407@asianux.com>
Date: Sat, 05 Oct 2013 15:33:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/exit.c: call read_unlock() when failure occurs
 after already called read_lock() in do_wait().
References: <524FA956.9080100@asianux.com> <20131005063431.GU13318@ZenIV.linux.org.uk>
In-Reply-To: <20131005063431.GU13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 02:34 PM, Al Viro wrote:
> On Sat, Oct 05, 2013 at 01:53:26PM +0800, Chen Gang wrote:
>> If failure occurs after called read_lock(), need call read_unlock() too.
>>
>> It can fail in multiple position, so add new tag 'fail_lock' for it
>> (also can let 'if' only content one jump statement).
> 
> You know, this is getting too frequent...  You really need to do
> something about it.  OK, you've formed a hypothesis (in this case,
> that ptrace_do_wait() returns non-zero with tasklist_lock still held).
> If that hypothesis was correct, you would've found a bug and yes,
> this patch would probably be more or less a fix for that bug.
> 
> Do you see what's missing?  That's right, verifying that hypothesis.
> Which isn't hard to do, either by slapping a printk into these
> exits, or by trying to build a proof.  As it is, hypothesis is
> incorrect and your patch introduces breakage.  The same would have
> happened if _some_ exits from that function returned non-zero
> values with tasklist_lock held and some returned non-zero values
> with tasklist_lock released.
> 
> You really need to realize that pattern-matching is not enough - you
> need to prove that your fix is correct and that requires an analysis
> of what's there.
> 
> "I see something odd" is a good reason to ask or to try and figure out
> what's going on.  It's not a good reason for blindly making changes
> like that - not until you've done the analysis and can at least show
> that it won't _break_ things.
> 
> 

Oh, it is my fault, this is incorrect patch. Hmm... I realize a mistake
of me: I have said "when finding issues, I need consider about LTP in q4
2013, need let it can be tested by LTP".

And you feel "this is getting too frequent...", can you provide my
failure/succeed ratio?

Or for a short proof: next, I will try to find 2 patches by reading code
within "./kernel" sub-directory, if all of them are incorrect, I will
*never* send patches again by reading code. Is it OK?


Hmm... but all together, I still will use compiler and test tools to
find/solve issues (I have found 3-4 issues by LTP test tools, now just
analyzing them, although I am not sure they must be kernel's issue).


Thanks.
-- 
Chen Gang
