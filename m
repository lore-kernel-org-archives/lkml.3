Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaELR4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:56:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59812 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaELR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:56:15 -0400
Date: Mon, 12 May 2014 19:56:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] sched,nohz: Change rq->nr_running always using wrappers
Message-ID: <20140512175609.GC6127@localhost.localdomain>
References: <20140508225830.2469.97461.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508225830.2469.97461.stgit@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:00:14AM +0400, Kirill Tkhai wrote:
> Sometimes nr_running may cross 2 but interrupt is not being
> sent to rq's cpu. In this case we don't reenable timer.
> Looks like, this may be a reason of rare unexpected effects,
> if nohz is enabled.
> 
> Patch replaces all places of direct changing of nr_running
> and makes add_nr_running() caring about crossing border.
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>

Right I had that issue with throttling in my TODO list.

Thanks for fixing that:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
