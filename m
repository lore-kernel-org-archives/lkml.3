Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3DSSHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:07:23 -0400
Received: from plane.gmane.org ([80.91.229.3]:53169 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3DSSHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:07:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: arm: ARM_VIRT_EXT is not supported by all v7 platforms, so it should
 not be enabled by default
Date: Fri, 19 Apr 2013 20:07:15 +0200
Message-ID: <kks14c$e4p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: svn.dd-wrt.com
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduced in kernel 3.9 CONFIG_ARM_VIRT_EXT is default for all V7 arm 
cpu's. this is wrong and breaks smp support on BCM4708 for example.
so keep it optional since no all v7 cpu's seem to support it. BCM4708 
for instance is a arm cortex-a9. please merge this into one of the next 
patches.


Index: arch/arm/mm/Kconfig
===================================================================
--- arch/arm/mm/Kconfig     (revision 21211)
+++ arch/arm/mm/Kconfig     (working copy)
@@ -640,8 +640,7 @@

  config ARM_VIRT_EXT
         bool
-       depends on MMU
-       default y if CPU_V7
+       depends on MMU && CPU_V7
         help
           Enable the kernel to make use of the ARM Virtualization
           Extensions to install hypervisors without run-time firmware


