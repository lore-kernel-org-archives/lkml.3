Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3BVGxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:53:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38633 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3BVGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:53:48 -0500
Date: Thu, 21 Feb 2013 22:53:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Dangerous devm_request_irq() conversions
Message-ID: <20130222065345.GA30816@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like a whole slew of devm_request_irq() conversions just got
applied to mainline and many of them are quite broken.

Consider fd5231ce336e038037b4f0190a6838bdd6e17c6d or
c1879fe80c61f3be6f2ddb82509c2e7f92a484fe: the drivers udsed first to
free IRQ and then unregister the corresponding device ensuring that IRQ
handler, while it runs, has the device available. The mechanic
conversion to devm_request_irq() reverses the order of these operations
opening the race window where IRQ can reference device (or other
resource) that is already gone.

It would be nice if these could be reverted and revioewed again for
correctness.

In general any conversion to devm_request_irq() needs double and triple
checking.

Thanks.

-- 
Dmitry
