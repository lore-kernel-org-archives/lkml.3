Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3DSRel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:34:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57266 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752727Ab3DSRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:34:40 -0400
Date: Fri, 19 Apr 2013 13:34:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Issue with upgrade path from include/linux/version.h to uapi
Message-ID: <20130419173434.GA15612@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With a kernel tree that contains a generated include/linux/version.h, if
someone just does a git pull to update to a newer kernel version that
includes

commit 10b63956fce7f369cc37fd4d994f09bd5203efe4

"UAPI: Plumb the UAPI Kbuilds into the user header installation and
checking"

and
commit d183e6f570f3c0c23d253fd262c90244e72d7ffd

"UAPI: Move linux/version.h"

Any newer build will fail to overwrite or remove the stale version.h
file. The new include/generated/uapi/linux/version.h is indeed
generated, but the stale file in include/linux has precedence.

This leads to very unfortunate consequences for any user relying on
version.h to expose the kernel version accurately, since the old "stale"
kernel version will be seen by the build.

Sadly, make clean does not even take care of removing this stale file.

I've had a couple of LTTng users, myself included, running into this
issue. In our case, it typically just causes a build failure, but I
suspect it may break build of other projects relying on version.h in
much more subtle ways.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
