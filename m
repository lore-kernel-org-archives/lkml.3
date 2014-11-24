Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaKXUGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbaKXUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:06:11 -0500
Date: Mon, 24 Nov 2014 21:06:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] exit/pid_ns: comments + simple fix
Message-ID: <20141124200602.GA20575@redhat.com>
References: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, Pavel, could you review 1/2 ? (documentation only). It is based on the
code inspection, I didn't bother to verify that my understanding matches the
reality ;)

On 11/20, Oleg Nesterov wrote:
>
>
> Probably this is not the last series... in particular it seems that we
> have some problems with sys_setns() in this area, but I need to recheck.

So far only the documentation fix. I'll write another email (hopefully with the
patch), afaics at least setns() doesn't play well with PR_SET_CHILD_SUBREAPER.

Contrary to what I thought zap_pid_ns_processes() looks fine, but it seems only
by accident. Unless I am totally confused, wait for "nr_hashed == init_pids"
could be removed after 0a01f2cc390e10633a "pidns: Make the pidns proc mount/
umount logic obvious". However, now that setns() + fork() can inject a task
into a child namespace, we need this code again for another reason.

I _think_ we can actually remove it and simplify free_pid() as well, but lets
discuss this later and fix the wrong/confusing documentation first.

2/2 looks "obviously correct", but I'll appreciate your review anyway.

Oleg.

 kernel/pid.c           |    7 +++----
 kernel/pid_namespace.c |   23 +++++++++++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

