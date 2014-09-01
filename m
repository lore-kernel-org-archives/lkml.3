Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaIAIIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:08:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:33445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaIAIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="566467948"
Message-ID: <1409558924.8085.46.camel@rzhang1-toshiba>
Subject: Regression:  Wake up from Suspend to RAM crashes Toshiba Satellite
 laptop to black screen
From: Zhang Rui <rui.zhang@intel.com>
To: hayeswang@realtek.com
Cc: fireandfuel@hotmail.de, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Sep 2014 16:08:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hayes,

We got a regression report complaining that wakeup from Suspend to RAM
crashes, please refer to
https://bugzilla.kernel.org/show_bug.cgi?id=82741

and it seems that it is introduced by commit
b51ecea852b712618796d9eab8428a7d5f1f106f.

Date:   Wed Jul 9 14:52:51 2014 +0800

    r8169: disable L23
    
    For RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106, disable the
feature
    of entering the L2/L3 link state of the PCIe. When the nic starts
the process
    of entering the L2/L3 link state and the PCI reset occurs before the
work
    is finished, the work would be queued and continue after the next
the PCI
    reset occurs. This causes the device stays in L2/L3 link state, and
the system
    couldn't find the device.
    
    Signed-off-by: Hayes Wang <hayeswang@realtek.com>
    Acked-by: Francois Romieu <romieu@fr.zoreil.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Can you please take a look at it?

thanks,
rui



