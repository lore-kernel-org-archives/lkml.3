Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaFKLYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:24:23 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52157 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKLYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:24:21 -0400
Date: Wed, 11 Jun 2014 16:54:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
Message-ID: <20140611112411.GA21191@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140611093417.27807.2288.stgit@tkhai>
 <1402480330.32126.14.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1402480330.32126.14.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061111-4790-0000-0000-000001F86667
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:

> 
> Currently migrate_tasks() skips throttled tasks,
> because they are not pickable by pick_next_task().
> 

Before migrate_tasks() is called, we do call set_rq_offline(), in
migration_call().

Shouldnt this take care of unthrottling the tasks and making sure that
they can be picked by pick_next_task().

> These tasks stay on dead cpu even after they
> becomes unthrottled. They are not schedulable
> till user manually changes their affinity or till
> cpu becomes alive again.
> 

If we are still seeing tasks not being picked by pick_next_task(), then
can it probably mean that rq->rd was NULL?

-- 
Thanks and Regards
Srikar Dronamraju

