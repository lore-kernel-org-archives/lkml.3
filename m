Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaHRPLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:11:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaHRPLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:11:50 -0400
Date: Mon, 18 Aug 2014 17:09:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sched: tasklist_lock cleanups (Was: don't use
	while_each_thread())
Message-ID: <20140818150916.GA19364@redhat.com>
References: <20140813191938.GA19301@redhat.com> <20140817152549.GA17984@redhat.com> <53F11B45.8070105@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F11B45.8070105@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Kirill Tkhai wrote:
>
> On 17.08.2014 19:25, Oleg Nesterov wrote:
> >
> > And I can't understand tg_has_rt_tasks(). Don't we need something
> > like the patch below? If not, please do not ask me why I think so,
> > I don't understand this black magic ;) But the usage of the global
> > "runqueues" array looks suspicious.
>
> This function searches RT task which is related to this tg. It's
> opaquely because it looks that there is an error.
>
> task_rq(p)->rt.tg is a task group of a top rt_rq, while the task may
> be queued on a child rt_rq instead of this. So, your patch is a BUGFIX,
> not a cleanup.

Yes, thanks, this was my (vague) understanding. But since I don't know
even the terminology I wasn't able to explain my concerns.

OK, I am going to shamelessly steal your words and turn them into the
changelog.

Thanks.

Oleg.

