Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3AYDCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:02:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3AYDBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:37 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zw2l0ZevoSEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=oaCqhC68t3oA:10 a=drOt6m5kAAAA:8 a=2KMo9-giAAAA:8 a=sozttTNsAAAA:8 a=jYM2z41T7odf_uYgOQoA:9 a=PUjeQqilurYA:10 a=-ydLB92TkmgA:10 a=x2szoZtqnggA:10 a=iIRS6aQmarT3udo7:21 a=HAIWI4eglJCgl9NT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359082886.21576.199.camel@gandalf.local.home>
Subject: [BUG] panda board locks up on boot
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>, Tony Lindgren <tony@atomide.com>
Date: Thu, 24 Jan 2013 22:01:26 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently started testing my work on arm boards and have found that
they both don't boot under the latest kernel anymore. I already posted
about my snowball board, but my panda board also locks up.

I've bisected it down to this commit:

commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Fri Apr 13 12:27:37 2012 +0100

    mmc: omap_hsmmc: remove private DMA API implementation
    
    Remove the private DMA API implementation from omap_hsmmc, making it
    use entirely the DMA engine API.
    
    Tested-by: Tony Lindgren <tony@atomide.com>
    Tested-by: Venkatraman S <svenkatr@ti.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>


The commit before boots fine, when adding this commit, it locks up.

I reverted the commit (with tweaks) against 3.8-rc4 and was able to get
my board booting again. Not sure what to do, but I wanted to let people
know.

Thanks,

-- Steve


