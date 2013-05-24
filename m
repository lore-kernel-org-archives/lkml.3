Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3EXJeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:34:00 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36976 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EXJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:33:58 -0400
From: Stephen Mell <sub.atomic.fusion@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
Date: Fri, 24 May 2013 09:35:40 +0000
Message-ID: <1642748.MrLhTUgxmu@pegasus>
User-Agent: KMail/4.9.5 (Linux/3.9.3; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519F2F65.4000400@cn.fujitsu.com>
References: <3342521.NtikuogILA@pegasus> <24900395.sMN6olMGRM@pegasus> <519F2F65.4000400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 24, 2013 17:14:13 Gu Zheng wrote:

> One fuzzy way in my mind, I'm not sure whether it's OK, but we can discuss it.
> Split hide_pid, pid_gid, and proc_self from pid_namespace, and create struct proc_sb_info(maybe the name "proc_mount_info" is better). 
> And create a new list domain in the pid_namespace to contain the proc_sb_info instances. Each time we mount proc in a new directory only
> create a new proc_sb_info instance, and added it to the list in pid_namespace. 
> But this leads to another problem, how to get the right proc_sb_info instance in proc permission checking routine, do you have any idea?
> what do you think of this way?

I understand now what you're getting at.
However, I'd like to make the argument that it is desirable to have each proc mount, even those that reference the same namespace, have a different superblock. One option that I intend to add is the ability to specify which pid namespace proc is mounted for, rather than forcing the current one. If this were to be added, it wouldn't work to share superblocks, as that would prevent remounts of proc from switching which namespace that the refer to (or that is my understanding, which may be incorrect).
Considering the small number of proc mounts that tend to be around anyway, perhaps this outweighs the drawbacks.
Let me know what you think.

> Thanks,
> Gu

Thanks,
Stephen
