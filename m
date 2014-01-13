Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaAMQxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:53:46 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:33688 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbaAMQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:52:57 -0500
Date: Mon, 13 Jan 2014 11:52:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 3/3] Send cgroup_path in SCM_CGROUP
Message-ID: <20140113165253.GC29053@htj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
 <1389600109-30739-4-git-send-email-jkaluza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389600109-30739-4-git-send-email-jkaluza@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 09:01:49AM +0100, Jan Kaluza wrote:
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
> This introduces a new SCM type called SCM_CGROUP to allow the direct
> attaching of "cgroup_path" to SCM, which is significantly more
> efficient and will reliably avoid the race with the round-trip over
> procfs.
> 
> Signed-off-by: Jan Kaluza <jkaluza@redhat.com>

For cgroup related part:

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
