Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589AbaDJL7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:59:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52043 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935532AbaDJL7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:59:49 -0400
Date: Thu, 10 Apr 2014 13:59:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: e1000e 0000:00:19.0 eth0: Hardware Error
Message-ID: <20140410115941.GI29093@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I started getting those sporadic

[133178.640890] e1000e 0000:00:19.0 eth0: Hardware Error
[133179.293148] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[133179.394226] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[133179.397200] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[133181.338258] e1000e 0000:00:19.0 eth0: Hardware Error
[133182.077209] pci_pm_runtime_suspend(): e1000_runtime_suspend+0x0/0x40 [e1000e] returns -2

messages with 3.14 and I haven't had them before. After this, I do

rmmod e1000e && modprobe e1000e

and I get:

[133221.891555] e1000e 0000:00:19.0 eth0: removed PHC
[133228.181552] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[133228.181562] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[133228.182241] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[133228.182332] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[133229.009837] e1000e: probe of 0000:00:19.0 failed with error -2
			^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[133307.107217] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[133307.107228] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[133307.107814] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[133307.107959] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[133307.935921] e1000e: probe of 0000:00:19.0 failed with error -2

...

[133841.361905] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[133841.361914] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[133841.362451] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[133841.362520] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[133842.192710] e1000e: probe of 0000:00:19.0 failed with error -2

each time I try and eth0 is dead. Only a reboot helps, I've come to find
out so far.

Any ideas?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
