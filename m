Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaJVK3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:29:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVK3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:29:03 -0400
Date: Wed, 22 Oct 2014 12:28:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, morten.rasmussen@arm.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141022102857.GH12706@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I would really like to hear from others on this, as it stands I tend
to rather like this code -- and it removes a fair amount of icky lines
of code.

That said, it does change semantics slightly in that it removes the
blocked/runnable split and last time we added the blocked component to
the load balancer we had regressions -- now Yuyand and Wu ran this
through some testing (AIM7 iirc) and didn't see horrid, but I can't
quite remember where we saw the biggest fail back when.

Also, Morten is a little worried about changing all this code seeing how
the existing stuff has proven itself over the past few years and feels
its somewhat understood. Then again, going by that we'd never change
anything.

Ben, Paul, can you guys give this a go?
