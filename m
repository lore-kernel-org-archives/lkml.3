Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaEZSEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:04:49 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55952 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaEZSEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:04:48 -0400
Date: Mon, 26 May 2014 22:04:43 +0400
From: Vasily Kulikov <segooon@gmail.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] /proc/pid/status: show all sets of pid according to ns
Message-ID: <20140526180443.GA11145@cachalot>
References: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Mon, May 26, 2014 at 18:05 +0800, Chen Hanxiao wrote:
> We need a direct method of getting the pid inside containers.
> If some issues occurred inside a container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
> 
> This patch expands fields of Tgid and Pid:
> a) In init_pid_ns, nothing changed;
> 
> b) In one pidns, they will tell the pid inside containers:
> Tgid:	1628 	9 	3
> Pid:	1628 	9 	3
> ** process id is 1628 in level 0, 9 in level 1, 3 in level 2.

1. It breaks ABI.  Any application which does something like "grep pid: | cut -d: -f2"
is now broken by the patch.  Maybe add a new field like 'Pid-ns', 'PidNS',
or 'Pids' and leave the old one for compatibility?

2. Is it OK to show internal pids to unprivileged processes?  I cannot
see anything obviously dangerous with it, though.

> c) If pidns is nested, it depends on which pidns are you in.
> Tgid:	9 	3
> Pid:	9 	3
> ** Views from level 1 for Pid 1628 in host.

-- 
Vasily
