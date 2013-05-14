Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3ENLxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:53:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47560
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab3ENLxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:53:41 -0400
Date: Tue, 14 May 2013 13:52:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove redundant update_runtime notifier
Message-ID: <20130514115200.GF15942@dyad.programming.kicks-ass.net>
References: <1365685499-26515-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365685499-26515-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:04:59PM +0800, Neil Zhang wrote:
> migration_call() will do all the things that update_runtime() does.
> So let's remove it.
> 
> Furthermore, there is potential risk that the current code will catch
> BUG_ON at line 689 of rt.c when do cpu hotplug while there are realtime
> threads running because of enabling runtime twice while the rt_runtime
> may already changed.
> 

Indeed, it looks like the 'new' sched_class::rq_{on,off}line stuff handles all
that just fine.

Thanks for spotting that.


