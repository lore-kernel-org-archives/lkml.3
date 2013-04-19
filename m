Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3DSSFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab3DSSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:05:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130419173434.GA15612@Krystal>
References: <20130419173434.GA15612@Krystal>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: dhowells@redhat.com, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Issue with upgrade path from include/linux/version.h to uapi
Date: Fri, 19 Apr 2013 19:05:31 +0100
Message-ID: <29752.1366394731@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> This leads to very unfortunate consequences for any user relying on
> version.h to expose the kernel version accurately, since the old "stale"
> kernel version will be seen by the build.
> 
> Sadly, make clean does not even take care of removing this stale file.

I wonder if a simple approach would work - just add:

	$(shell rm include/linux/version.h)

to an appropriate header, perhaps the top-level Makefile.

Failing that, it might be worth adding it to the make-clean list.

David
