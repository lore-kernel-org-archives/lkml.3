Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbbAWKBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:01:16 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:46486 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbAWKBN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 05:01:13 -0500
Message-Id: <54C229F902000078000589FD@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 10:01:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <mingo@redhat.com>, "Rik van Riel" <riel@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: sched/fair: avoid using uninitialized variable in
 preferred_group_nid()
References: <54C2139202000078000588F7@mail.emea.novell.com>
 <20150123095449.GL2896@worktop.programming.kicks-ass.net>
In-Reply-To: <20150123095449.GL2896@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.01.15 at 10:54, <peterz@infradead.org> wrote:
> On Fri, Jan 23, 2015 at 08:25:38AM +0000, Jan Beulich wrote:
>> At least some gcc versions - validly afaict - warn about potentially
>> using max_group uninitialized: There's no way the compiler can prove
>> that the body of the conditional where it and max_faults get set/
>> updated gets executed; in fact, without knowing all the details of
>> other scheduler code, I can't prove this either.
>> 
>> Generally the necessary change would appear to be to clear max_group
>> prior to entering the inner loop, and break out of the outer loop when
>> it ends up being all clear after the inner one. This, however, seems
>> inefficient, and afaict the same effect can be achieved by exiting the
>> outer loop when max_faults is still zero after the inner loop. For the
>> compiler's sake, mark max_group uninitialized, as we're now able to
>> prove it's not actually being used uninitalized anymore.
> 
> 
> Yes this is somewhat challenging. What compiler version in specific did
> you get this warning wiht? I cannot remember seeing it with whatever it
> is I use (4.7-4.9 it seems).

SLE11 SP3's gcc (4.3.4 based).

Jan

