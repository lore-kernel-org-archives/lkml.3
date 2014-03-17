Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaCQSFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbaCQSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:05:02 -0400
Date: Mon, 17 Mar 2014 19:04:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] (Was: pppd service crash in linux-3.13.6)
Message-ID: <20140317180416.GA15708@redhat.com>
References: <531A37FF.4000509@totakura.in> <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com> <20140314192346.GA14823@redhat.com> <53236662.3020707@hurleysoftware.com> <20140314210456.GA19032@redhat.com> <53244C61.5090508@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53244C61.5090508@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Peter Hurley wrote:
>
> On 03/14/2014 05:04 PM, Oleg Nesterov wrote:
>>
>> But it can't even know who called call_usermodehelper(). Besides,
>> cgroup_release_agent() uses UMH_WAIT_EXEC, so the caller can continue
>> and disappear completely before the usermode process has any chance
>> to do something.
>
> I'm just hypothesizing potential breakage, since the order of teardown
> is sensitive to changes, and I didn't do a complete audit of all the
> possibilities.

Yes, I understand your concerns. Still I do not see how cgroup_exit()
can depend on tty/namespace.

> If you feel strongly about moving disassociate_tty(), I won't object.

It is not that I feel really strongly... just in looks better to me.
If nothing else:

	1. If we actually can not do disassociate_ctty() before, say,
	   cgroup_exit(), then we should understand and document the
	   reason.

	2. task_work_add() can have more users in drivers/tty which
	   can be triggered by disassociate_tty() paths. So I think
	   it would be nice to call it before task_work_exit().

2/2 is offtopic and hopefully trivial.

Oleg.

