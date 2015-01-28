Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020AbbA1UuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:17 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:56534 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981AbbA1UuL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 28 Jan 2015 15:50:11 -0500
Message-Id: <54C9044B020000780005A5E6@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 28 Jan 2015 14:46:19 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@kernel.org>
Cc: <peterz@infradead.org>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <riel@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:sched/urgent] sched/fair:  Avoid using uninitialized
 variable in preferred_group_nid()
References: <54C2139202000078000588F7@mail.emea.novell.com>
 <tip-81907478c4311a679849216abf723999184ab984@git.kernel.org>
In-Reply-To: <tip-81907478c4311a679849216abf723999184ab984@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.01.15 at 15:29, <tipbot@zytor.com> wrote:
> Commit-ID:  81907478c4311a679849216abf723999184ab984
> Gitweb:     
> http://git.kernel.org/tip/81907478c4311a679849216abf723999184ab984 
> Author:     Jan Beulich <JBeulich@suse.com>
> AuthorDate: Fri, 23 Jan 2015 08:25:38 +0000
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 28 Jan 2015 13:14:12 +0100
> 
> sched/fair: Avoid using uninitialized variable in preferred_group_nid()
> 
> At least some gcc versions - validly afaict - warn about potentially
> using max_group uninitialized: There's no way the compiler can prove
> that the body of the conditional where it and max_faults get set/
> updated gets executed; in fact, without knowing all the details of
> other scheduler code, I can't prove this either.
> 
> Generally the necessary change would appear to be to clear max_group
> prior to entering the inner loop, and break out of the outer loop when
> it ends up being all clear after the inner one. This, however, seems
> inefficient, and afaict the same effect can be achieved by exiting the
> outer loop when max_faults is still zero after the inner loop.
> 
> [ mingo: changed the solution to zero initialization: uninitialized_var()
>   needs to die, as it's an actively dangerous construct: if in the future
>   a known-proven-good piece of code is changed to have a true, buggy
>   uninitialized variable, the compiler warning is then supressed...

But you went farther than that: You also dropped the breaking
out of the outer loop. Yet that has - beyond the fixing of the bug
here - the desirable effect of not continuing for perhaps many
iterations when nothing new can ever be found anymore.

Jan

