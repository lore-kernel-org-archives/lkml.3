Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3CSCdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:33:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:3184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3CSCd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,868,1355126400"; 
   d="scan'208";a="281334196"
Date: Tue, 19 Mar 2013 10:34:40 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Rajiv Andrade <mail@srajiv.net>, Peter <peterasplund@gentoo.se>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: tpm_tis driver failed to suspend, error -62
Message-ID: <20130319023440.GA12425@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajiv,

Not sure if I should send this to you, please kindly forward it to the
appropriate person if not, thanks.

Peter has encountered a problem during suspend, the tpm_tis driver's
suspend callback will fail, the relevant message is:

[  192.281757] PM: Syncing filesystems ... done.
[  192.692479] Freezing user space processes ... (elapsed 0.01 seconds)
done.
[  192.708159] Freezing remaining freezable tasks ... (elapsed 0.01
seconds)
done.
[  192.724151] Suspending console(s) (use no_console_suspend to debug)
[  192.724612] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  192.724785] sd 2:0:0:0: [sda] Stopping disk
[  197.512047] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  197.512055] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
[  197.512057] PM: Device 00:08 failed to suspend: error -62
[  197.512058] PM: Some devices failed to suspend

And the problem has been there since v2.6.32(shipped in ubuntu 10.04),
and the latest upstream tree(v3.9-rcx) also has this problem. The bug
link is here:
https://bugzilla.kernel.org/show_bug.cgi?id=45761

Please feel free to ask for more information, thanks.

-Aaron

