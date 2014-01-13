Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaAMQ5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:57:15 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:55647 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbaAMQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:55:09 -0500
Date: Mon, 13 Jan 2014 11:55:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
Message-ID: <20140113165505.GD29053@htj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 13, 2014 at 09:01:46AM +0100, Jan Kaluza wrote:
> this patchset against net-next (applies also to linux-next) adds 3 new types
> of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
> 
> Server-like processes in many cases need credentials and other
> metadata of the peer, to decide if the calling process is allowed to
> request a specific action, or the server just wants to log away this
> type of information for auditing tasks.
> 
> The current practice to retrieve such process metadata is to look that
> information up in procfs with the $PID received over SCM_CREDENTIALS.
> This is sufficient for long-running tasks, but introduces a race which
> cannot be worked around for short-living processes; the calling
> process and all the information in /proc/$PID/ is gone before the
> receiver of the socket message can look it up.
> 
> Changes introduced in this patchset can also increase performance
> of such server-like processes, because current way of opening and
> parsing /proc/$PID/* files is much more expensive than receiving these
> metadata using SCM.

Closing the race sounds like a good idea to me.  What do net people
think?

Thanks.

-- 
tejun
