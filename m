Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab3JOVyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:54:14 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:57788 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3JOVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:54:13 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 17:54:13 EDT
Date: Tue, 15 Oct 2013 23:45:58 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <932951750.20131015234558@eikelenboom.it>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Kconfig help entry for CONFIG_PARAVIRT_SPINLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raghavendra,

Since the ticketlock series have landed in this mergewindow (thanks :-) ) the
help accompanying the Kconfig entry doesn't seem to reflect the current state well.

- Wasn't the whole purpose of the ticketlock series to mitigate this 5% performance hit to something
  far less, so distro kernels could enable this for their normal kernels ?
  I don't have the exact performance figures though.

- Perhaps the suggestion to enable this for supported hypervisors (Xen and KVM ?) could be added ?

--
Sander


CONFIG_PARAVIRT_SPINLOCKS:

Paravirtualized spinlocks allow a pvops backend to replace the
spinlock implementation with something virtualization-friendly
(for example, block the virtual CPU rather than spinning).

Unfortunately the downside is an up to 5% performance hit on
native kernels, with various workloads.

If you are unsure how to answer this question, answer N.

Symbol: PARAVIRT_SPINLOCKS [=y]
Type  : boolean
Prompt: Paravirtualization layer for spinlocks
  Location:
    -> Processor type and features
      -> Linux guest support (HYPERVISOR_GUEST [=y])
        -> Enable paravirtualization code (PARAVIRT [=y])
  Defined at arch/x86/Kconfig:632
  Depends on: HYPERVISOR_GUEST [=y] && PARAVIRT [=y] && SMP [=y]
  Selects: UNINLINE_SPIN_UNLOCK [=y]


