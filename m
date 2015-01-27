Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbbA0Is4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:48:56 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbA0Isx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:48:53 -0500
Date: Tue, 27 Jan 2015 09:48:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20150127084842.GO2896@worktop.programming.kicks-ass.net>
References: <1414405105.19914.169.camel@tkhai>
 <54C6D1C4.4070802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C6D1C4.4070802@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:46:12PM -0500, Sasha Levin wrote:
> This seems to cause the following lockdep warning:

unlikely, the fork -> sched_move_task() was only used to establish that
rq->lock nests inside p->pi_lock, and there's a gazillion other ways to
establish that.

That said, its a right mess indeed. Let me stare a wee bit more at this
rats nets.

