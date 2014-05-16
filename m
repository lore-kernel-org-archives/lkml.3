Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaEPUBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:01:19 -0400
Received: from mout.gmx.net ([212.227.15.18]:61038 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaEPUBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:01:17 -0400
Date: Fri, 16 May 2014 22:01:12 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.15
Message-ID: <20140516200112.GA1315@p100.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:OpxKHdNJNLPRiztuoXg57jIBCjwMKRaJcyUd0UlDi/oJqI/Hj0X
 X7xLZcFzQf5ohQHFgXaYnK3ei69p3h3b444JJX0PpLMhnQ8e7uJeMErWEn9/MaYTdz/lml9
 gZI5ZwTFQG+5xNpwAyOwor74RFP9Qew/r1QyTsrF5CSoQv7WGIQaHst6PTG2klrcHEzYAei
 87XRSN+f6/XTfUKigVjzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes for kernel 3.15 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.15-4

There are two patches in here:

The first patch greatly improves latency and corrects the memory ordering in
our light-weight atomic locking syscall.

The second patch ratelimits printing of userspace segfaults in the same way as
it's done on other platforms. This fixes a possible DOS on parisc since it
prevents the syslog to grow too fast. For example, when the debian acl2 package
was built on our debian buildd servers, this package produced lots of gigabytes
in syslog in very short time and thus filled our harddisks, which then turned
the server nearly completely unaccessible and unresponsive.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (1):
      parisc: ratelimit userspace segfault printing

John David Anglin (1):
      parisc: Improve LWS-CAS performance

 arch/parisc/Kconfig          |  1 +
 arch/parisc/kernel/syscall.S | 12 +++++++---
 arch/parisc/kernel/traps.c   | 54 ++++++++++++++++++++------------------------
 arch/parisc/mm/fault.c       | 44 ++++++++++++++++++++++++------------
 4 files changed, 65 insertions(+), 46 deletions(-)
