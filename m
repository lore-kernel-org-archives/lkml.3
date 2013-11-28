Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab3K1OjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:39:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51249 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3K1OjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:39:04 -0500
Date: Thu, 28 Nov 2013 15:38:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128143857.GU10022@twins.programming.kicks-ass.net>
References: <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128141329.GB3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:13:29AM -0500, Tejun Heo wrote:
> > A single parent process for all usermode helpers makes so much sense;
> > not doing it is just weird.
> 
> If we're gonna allow userland to play with the parent attributes,
> yeah, that'd make sense.  I'm not sure whether that's an interface
> that we'd want to commit to tho?  Do we really want to tell userland
> "there will always be a kernel task khelper and if you change that
> one's attributes all processes forked from it will inherit those
> attributes no matter what they are."  I think we'd want something more
> specific cause that's a lot of commitment to things that we haven't
> carefully thought about.

It seems like a perfectly fine interface to me. And much preferable to
creating yet another weird interface to manage tasks.
