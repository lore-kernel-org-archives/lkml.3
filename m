Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaG1NWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaG1NWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:22:02 -0400
Date: Mon, 28 Jul 2014 15:19:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        peterz@infradead.org, pjt@google.com, rostedt@goodmis.org,
        umgwanakikbuti@gmail.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 0/5] sched: Add on_rq states and remove several
	double rq locks
Message-ID: <20140728131944.GA2800@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost> <20140726193910.GA8420@redhat.com> <1406496385.1856.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406496385.1856.34.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Kirill Tkhai wrote:
>
> You're right. We have to check for "task_migrating" in switched_from_fair().
> One more place is switched_from_dl().

Or we can simply check task_migrating() in __sched_setscheduler(), like
set_cpus_allowed() does.

This probably means that you should add this check into task_rq_lock() as
Peter suggests. Or at least add another task_rq_lock_xxx() helper.

Oleg.

