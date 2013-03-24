Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab3CXNW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:22:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3CXNW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:22:57 -0400
Date: Sun, 24 Mar 2013 14:20:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Caj Larsson <caj@omnicloud.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Zombie stuck in zap_pid_ns_processes()
Message-ID: <20130324132047.GA13419@redhat.com>
References: <CAMoAvfEsvah6VELu9D7k1prB2GLhvyubd35tKgBaJdB=P08+pQ@mail.gmail.com> <87txo1kqj5.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txo1kqj5.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Eric W. Biederman wrote:
>
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -181,6 +181,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	int nr;
>  	int rc;
>  	struct task_struct *task, *me = current;
> +	int init_pids = task_pid_vnr(me) == 1 ? 1 : 2;
                        ^^^^^^^^^^^^^^^^^^^^^

Ah, mt-init.

perhaps thread_group_leader(me) would be more clean/simple,
but I won't insist of course.

Oleg.

