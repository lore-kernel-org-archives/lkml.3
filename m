Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaDYS46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaDYS44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:56:56 -0400
Date: Fri, 25 Apr 2014 20:56:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: Re: [Resend][PATCH] ns,proc: introduce pid_in_ns
Message-ID: <20140425185645.GA10637@redhat.com>
References: <1398415405-19872-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398415405-19872-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Chen Hanxiao wrote:
>
> We lacked of convenient method of getting the pid inside containers.
>
> If some issues occurred inside container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
>
> This patch introduces pid_in_ns:
> If one process is in init_pid_ns, /proc/PID/pid_in_ns
> equals to /proc/PID;
> if one process is in pidns, /proc/PID/pid_in_ns
> will tell the pid inside containers;
> if pidns is nested, it depends on which pidns are you in.

Yes another /proc/pid/ file...

Perhaps it would be better to change /proc/pid/status["Pid:"] to report the
list of pid_nr's, from its namespace up to the observer's namespace. The same
for "Tgid:".

(Hmm. And why "Ngid:" was inserted between tid and tgid ?)

> +int proc_pid_in_ns(struct seq_file *m, struct pid_namespace *ns,
> +			struct pid *pid, struct task_struct *task)
> +{
> +	pid_t pid_in_ns;
> +	unsigned int level;
> +
> +	level = pid->level;
> +	pid_in_ns = task_pid_nr_ns(task, pid->numbers[level].ns);

This looks overcomplicated or I missed something?

Oleg.

