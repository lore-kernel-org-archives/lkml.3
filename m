Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAaAI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:08:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaAaAIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:08:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8761p1m98f.fsf@xmission.com>
References: <8761p1m98f.fsf@xmission.com> <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Fri, 31 Jan 2014 00:07:57 +0000
Message-ID: <3099.1391126877@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> These files have been read-only since this code was merged in 2002.
> Over a decade of not being used seems like a strong indication that no
> one cares about the write path.

Actually, things aren't as simple as they seem.  Without the patch applied:

	[root@andromeda ~]# ls -l /proc/fs/afs/cells
	-r--r--r--. 1 root root 0 Jan 31 00:04 /proc/fs/afs/cells
	[root@andromeda ~]# echo add your-file-system.com 204.29.154.37 >/proc/fs/afs/cells
	[root@andromeda ~]# 

You'll observe there is no error reported on the echo command.

Further, looking in dmesg, I see:

	kAFS: Added new cell 'your-file-system.com'

So the file *is* writable, *despite* i_mode.

David
