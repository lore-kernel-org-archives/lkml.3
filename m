Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaKXUOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:14:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbaKXUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:14:48 -0500
Date: Mon, 24 Nov 2014 21:14:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] exit: reparent: fix/update the comments in
	zap_pid_ns_processes()
Message-ID: <20141124201441.GA21311@redhat.com>
References: <20141124200602.GA20575@redhat.com> <20141124200626.GA21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124200626.GA21006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Oleg Nesterov wrote:
>
> +	 * sys_wait4() above can't reap the TASK_DEAD children but we do not
> +	 * really care, we could reparent them to the global init. We could
> +	 * exit and reap ->child_reaper even if it is not the last thread in
> +	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
> +	 * pid_ns can not go away until proc_kill_sb() drops the reference.
> +	 *
> +	 * But this namespace can also have other tasks injected by setns().
                                                                    ^^^^^
I meant setns() + fork(), but I hope this is clear.

Oleg.

