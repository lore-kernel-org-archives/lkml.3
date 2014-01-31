Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaAaAUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:20:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaAaAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:20:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3099.1391126877@warthog.procyon.org.uk>
References: <3099.1391126877@warthog.procyon.org.uk> <8761p1m98f.fsf@xmission.com> <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Fri, 31 Jan 2014 00:20:02 +0000
Message-ID: <3224.1391127602@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Further:

	[root@andromeda ~]# touch /tmp/foo
	[root@andromeda ~]# chmod 0444 /tmp/foo
	[root@andromeda ~]# ls -l /tmp/foo
	-r--r--r--. 1 root root 0 Jan 31 00:17 /tmp/foo
	[root@andromeda ~]# echo hello >/tmp/foo
	[root@andromeda ~]# ls -l /tmp/foo
	-r--r--r--. 1 root root 6 Jan 31 00:17 /tmp/foo
	[root@andromeda ~]# 

But:

	[root@andromeda ~]# su - dhowells
	[dhowells@andromeda ~]$ touch /tmp/bar
	[dhowells@andromeda ~]$ chmod 0444 /tmp/bar
	[dhowells@andromeda ~]$ ls -l /tmp/bar
	-r--r--r--. 1 dhowells dhowells 0 Jan 31 00:19 /tmp/bar
	[dhowells@andromeda ~]$ echo hello >/tmp/bar
	-bash: /tmp/bar: Permission denied

David
