Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaKZXy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:54:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbaKZXy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:54:27 -0500
Date: Thu, 27 Nov 2014 00:54:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] exit/pid_ns: comments + simple fix
Message-ID: <20141126235416.GA32688@redhat.com>
References: <20141107201424.GA22209@redhat.com> <20141124200602.GA20575@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124200602.GA20575@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remind, this doesn't depend on other changes in -mm.

It is not clear to me if I addressed Eric's objections or not, but let
me send V2 (I reordered these patches).

I updated the changelog/comments in 2/2, hopefully now it is more clear
that this patch only tries to explain how the current code works, and why
do we need to wait for nr_hashed==init_pids from the kernel perspective.
Otherwise it is basically the same patch, except I added another note
about sys_wait4().

And, Eric, let me repeat. In any case we do not need for EXIT_DEAD tasks.
They are stealth. In fact this state should die, it only complicates
do_wait/reparenting/etc but we can't avoid it right now (mostly because
of the locking in wait paths).

IOW. If we could somehow detect that this pid_ns has only EXIT_DEAD tasks
we could return and user-space won't notice this change. No, it is not
that I think we should do this, but this should be documented.

Please review.

Oleg.

