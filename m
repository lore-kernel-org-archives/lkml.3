Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaFRR7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaFRR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:59:19 -0400
Date: Wed, 18 Jun 2014 19:58:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Gotou Yasunori <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] ns: introduce getnspid syscall
Message-ID: <20140618175807.GA21565@redhat.com>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Chen Hanxiao wrote:
>
> +SYSCALL_DEFINE4(getnspid, pid_t, pid, int, fd1, int, fd2, int, pidtype)
> +{
> +	struct file *file1 = NULL, *file2 = NULL;
> +	struct task_struct *task;
> +	struct pid_namespace *ns1, *ns2;
> +	struct proc_ns *ei;
> +	int ret = -1;
> +
> +	if (pidtype >= PIDTYPE_MAX)
> +		return -EINVAL;
> +
> +	file1 = proc_ns_fget(fd1);
> +	if (IS_ERR(file1))
> +		return PTR_ERR(file1);
> +	ei = get_proc_ns(file_inode(file1));
> +	ns1 = (struct pid_namespace *)ei->ns;

and I am not sure this part is correct... shouldn't we also verify that
ns_ops == pidns_operations ?

Perhaps it makes sense to generalize get_net_ns_by_fd() into
"void *get_ns_by_fd(fd, type)"... this probably needs another "check-and-get"
method in proc_ns_operations(). I dunno.

Oleg.

