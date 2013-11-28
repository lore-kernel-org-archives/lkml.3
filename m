Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab3K1OpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:45:09 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:55766 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3K1OpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:45:06 -0500
Date: Thu, 28 Nov 2013 09:45:02 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128144502.GE3925@htj.dyndns.org>
References: <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143857.GU10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143857.GU10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 28, 2013 at 03:38:57PM +0100, Peter Zijlstra wrote:
> It seems like a perfectly fine interface to me. And much preferable to
> creating yet another weird interface to manage tasks.

The problem with that is it isn't an interface where the user
specifies what's desired but more of just an exposed facet of
implementation details and locks us into either keeping that single
parent model for the eternity or doing a shitty hack like extracing
attributes from that task if we ever need to change the implementation
for whatever reason.  In general, it's a much better idea to have an
interface where the feature supported is represented explicitly and
finitely.  If this is something which is actually necessary, I'd vote
for having an explicit interface for the desired feature, whatever
that may be.

Thanks.

-- 
tejun
