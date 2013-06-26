Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3FZPY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:24:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3FZPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:24:55 -0400
Date: Wed, 26 Jun 2013 13:47:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH 4/7] perf, x86: Save/resotre LBR stack during context
 switch
Message-ID: <20130626114704.GF28407@twins.programming.kicks-ass.net>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
 <1372150039-15151-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372150039-15151-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:47:16PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> When the LBR call stack is enabled, it is necessary to save/restore
> the stack on context switch. The solution is saving/restoring the
> stack to/from task's perf event context. If task has no perf event
> context, just flush the stack on context switch.

So I have some problems with this; suppose the LBR is shared between a
cpu and a task event, when the task switches back in, it will over-write
the LBR content with old stuff.

In that case the CPU event's LBR stack can be actively wrong, as opposed
to being empty.
