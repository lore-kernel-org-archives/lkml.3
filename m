Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3HVTB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:01:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3HVTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:01:57 -0400
Date: Thu, 22 Aug 2013 20:56:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, security@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] Rename nsproxy.pid_ns to
	nsproxy.pid_ns_for_children
Message-ID: <20130822185605.GA24890@redhat.com>
References: <cover.1377196394.git.luto@amacapital.net> <a5db0606160dbd1412828be0d91a4a115a84abf6.1377196394.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5db0606160dbd1412828be0d91a4a115a84abf6.1377196394.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Andy Lutomirski wrote:
>
> nsproxy.pid_ns is *not* the task's pid namespace.  The name should clarify
> that.
>
> This makes it more obvious that setns on a pid namespace is weird --
> it won't change the pid namespace shown in procfs.
>
> ...
>
> + * The pid namespace is an exception -- it's accessed using
> + * task_active_pid_ns.  The pid namespace here is the
> + * namespace that children will use.
> + *
>   * 'count' is the number of tasks holding a reference.
>   * The count for each namespace, then, will be the number
>   * of nsproxies pointing to it, not the number of tasks.
> @@ -27,7 +31,7 @@ struct nsproxy {
>  	struct uts_namespace *uts_ns;
>  	struct ipc_namespace *ipc_ns;
>  	struct mnt_namespace *mnt_ns;
> -	struct pid_namespace *pid_ns;
> +	struct pid_namespace *pid_ns_for_children;
>  	struct net 	     *net_ns;

Personally I agree. ->pid_ns is "strange" and it makes sense to
document and make clear the fact that it became the implicit
argument for clone().

Oleg.

