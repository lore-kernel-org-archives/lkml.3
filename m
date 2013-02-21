Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3BUOnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:43:55 -0500
Received: from ms.dension.com ([195.56.193.33]:39294 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab3BUOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:43:54 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 09:43:53 EST
Date: Thu, 21 Feb 2013 15:37:17 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: bug: keep_bootcon and early printk together can lead to (invisible)
 kernel panic
Message-ID: <20130221153717.31400a88.pkluba@dension.com>
Organization: Dension Audio Systems Ltd.
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I had a silent lockup on one of our embedded system under development.
It was not easy to track it down, so here's what I discovered, in case
somebody runs into similar trouble.
Using 'keep_bootcon' command line parameter, and enabling early printk
can lead to a kernel panic. At least on MIPS, it does. The problem is
that in arch/mips/kernel/early_printk.c everything is declared as
__init and __initdata, so they are being freed, when the kernel
frees .init.* sections. If 'keep_bootcon' is given, the early console
does not get unregistered, and the entry in the console_drivers list
can point (will, believe me) to garbage data. It's up to you to imagine
the effects...

Regards,
Patrik

--
Patrik KLUBA
Software Developer at

DENSION Audio Systems Ltd.
H-1116 Budapest, Sztregova u. 1
Phone: +36 1 463 0470
Fax:   +36 1 463 0479
Web:   www.dension.com
