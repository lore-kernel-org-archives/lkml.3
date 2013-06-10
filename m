Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3FJShE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab3FJShC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:37:02 -0400
Date: Mon, 10 Jun 2013 20:33:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        John Stultz <johnstul@us.ibm.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] de_thread() should update ->real_start_time
Message-ID: <20130610183300.GA14379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1/3 is the obvious bugfix, 2 and 3 are minor cleanups

I am wondering, can't we kill task->real_start_time? What if we
simply change copy_process

	-	do_posix_clock_monotonic_gettime(&p->start_time);
	+	get_monotonic_boottime(&p->start_time);

?

Afaics, this will only affect do_acct_process() and bacct_add_tsk(),
but do we really want to exclude the suspended time in this case?


Another user of ->start_time is cgroup.c and it looks wrong... But
the change above should not make any difference.

Oleg.

