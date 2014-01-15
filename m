Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaAOVUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:20:34 -0500
Received: from arafel.iwakd.de ([78.46.72.57]:45279 "EHLO arafel.iwakd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaAOVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:20:30 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 16:20:29 EST
Message-ID: <52D6F976.4090405@iwakd.de>
Date: Wed, 15 Jan 2014 22:11:18 +0100
From: Christian Seiler <christian@iwakd.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com> <87vc05jgak.fsf@tw-ebiederman.twitter.com>
In-Reply-To: <87vc05jgak.fsf@tw-ebiederman.twitter.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman writes:
> So hmm.
>
> Because it can do no harm, and because it is a regression let's remove
> the CLONE_PARENT check and send it stable.
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 086fe73..c447fbc 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1174,7 +1174,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>           * do not allow it to share a thread group or signal handlers or
>           * parent with the forking task.
>           */
> -       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> +       if (clone_flags & (CLONE_SIGHAND)) {
>                  if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
>                      (task_active_pid_ns(current) !=
>                                  current->nsproxy->pid_ns_for_children))

Just a short question, what happened to this patch? As far as I can
tell, 3.13rc8 doesn't include it, neither does the current 3.12.7. This
means that lxc-attach currently still doesn't work on 3.12 and probably
won't work on 3.13 either... (3.11 is fine, see the previous mails in
this thread.)

-- Christian

