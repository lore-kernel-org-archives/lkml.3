Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3G2TwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:52:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:46165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3G2TwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,772,1367996400"; 
   d="scan'208";a="353782435"
Date: Mon, 29 Jul 2013 12:52:01 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Checkpatch error on trace events macros
Message-ID: <20130729195201.GC14883@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy and Joe,

Checkpatch is complaining when code adds new trace events macros:

sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
Applying: xhci: add traces for debug messages in xhci_address_device()
ERROR: Macros with complex values should be enclosed in parenthesis
#86: FILE: drivers/usb/host/xhci-trace.h:15:
+#define TRACE_SYSTEM xhci-hcd

ERROR: Macros with complex values should be enclosed in parenthesis
#115: FILE: drivers/usb/host/xhci-trace.h:44:
+#define TRACE_INCLUDE_PATH .

ERROR: Macros with complex values should be enclosed in parenthesis
#118: FILE: drivers/usb/host/xhci-trace.h:47:
+#define TRACE_INCLUDE_FILE xhci-trace

total: 3 errors, 0 warnings, 169 lines checked


The macros have to be defined that way for trace events to work.
Can you fix checkpatch not to complain about trace event macros?

Thanks,
Sarah Sharp
