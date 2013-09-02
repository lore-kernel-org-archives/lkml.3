Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3IBRRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:17:23 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55410 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3IBRRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1377785602-10766-4-git-send-email-jkaluza@redhat.com>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1377785602-10766-1-git-send-email-jkaluza@redhat.com> <1377785602-10766-4-git-send-email-jkaluza@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 2 Sep 2013 19:17:00 +0200
Message-ID: <CAPXgP120-PZHvEkAOgvUNkYYXnNfPt=SbxjRWY1hDXY9RWTJWQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] Send cgroup_path in SCM_CGROUP
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 4:13 PM, Jan Kaluza <jkaluza@redhat.com> wrote:
> Add new SCM type called SCM_CGROUP to send "cgroup_path" in SCM.
> This is useful for journald (systemd logging daemon) to get additional context
> with each log line received using UNIX socket.
>
> Signed-off-by: Jan Kaluza <jkaluza@redhat.com>

In many cases it's generally more useful to explain *why* something is
done, not *where* it is used. It makes it easier for people to match
the described problem to their own use-cases, where it possibly occurs
too. The problem this patch solves is very generic and not so much
specific to logging or the journal. Maybe something like this:

"Server-like processes in many cases need credentials and other
metadata of the peer, to decide if the calling process is allowed to
request a specific action, or the server just wants to log away this
type of information for auditing tasks.

The current practice to retrieve such process metadata is to look that
information up in procfs with the $PID received over SCM_CREDENTIALS.
This is sufficient for long-running tasks, but introduces a race which
cannot be worked around for short-living processes; the calling
process and all the information in /proc/$PID/ is gone before the
receiver of the socket message can look it up.

This introduces a new SCM type called SCM_CGROUP to allow the direct
attaching of "cgroup_path" to SCM, which is significantly more
efficient and will reliably avoid the race with the round-trip over
procfs."

Thanks,
Kay
