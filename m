Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3EFSyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:54:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36286
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab3EFSyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:54:12 -0400
Date: Mon, 6 May 2013 20:52:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130506185226.GA17723@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
 <20130502073720.GH7521@dyad.programming.kicks-ass.net>
 <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 07:44:19PM +0200, Stephane Eranian wrote:
> On Thu, May 2, 2013 at 9:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Apr 24, 2013 at 04:04:54PM -0700, Andi Kleen wrote:
> >> From: Andi Kleen <ak@linux.intel.com>
> >>
> >> The PEBS documentation in the Intel SDM 18.6.1.1 states:
> >>
> >> """
> >> PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
> >> zero: AnyThread, Edge, Invert, CMask.
> >> """
> >>
> >> Since we had problems with this earlier, don't allow cmask, any, edge, invert
> >> as raw events, except for the ones explicitly listed as pebs_aliases.
> >
> > If its a simple matter of crap in crap out without affecting anything else we
> > shouldn't do anything.
> >
> The problem here is that you are sampling an instruction which did not cause
> the event you are measuring. Remember that using cmask, changes the
> nature of what's being measured (from event to cycles).

Yeah.. I don't see the problem though. If you're using cmask and the like
you're supposed to know wth you're doing; which includes knowing your cpu and
what it thinks of such an event.

The only reason to disallow events is if they (badly) interact with other
counters.
