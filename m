Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaJBJgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:36:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:36:05 -0400
Date: Thu, 2 Oct 2014 11:36:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/3] sched/dl: Cleanup prio_changed_dl()
Message-ID: <20141002093600.GC2849@worktop.programming.kicks-ass.net>
References: <20140930210412.5258.35299.stgit@localhost>
 <20140930210428.5258.32223.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930210428.5258.32223.stgit@localhost>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:04:35AM +0400, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> rq->curr task can't be in "dequeued" state in prio_changed_dl().
> (The only place we can have that is __schedule()). So, we delete
> rq->curr check.

the CBS timer can throttle it right?
