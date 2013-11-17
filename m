Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3KQCNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 21:13:54 -0500
Received: from plane.gmane.org ([80.91.229.3]:56189 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3KQCNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 21:13:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikolaus Meine <meine@tnt.uni-hannover.de>
Subject: Re: =?utf-8?b?eGhjaV9oY2Q=?= 3.12 regression
Date: Sun, 17 Nov 2013 02:13:22 +0000 (UTC)
Message-ID: <loom.20131117T030136-739@post.gmane.org>
References: <20131110175002.GA26281@invalid> <loom.20131117T022347-280@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.83.204.222 (Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Meine <meine <at> tnt.uni-hannover.de> writes:

> 
> After upgrading from kernel 3.11 to 3.12 my USB 3.0 card reader
> (Transcend RDF8) stopped working with the same error.
> 
> I managed to find the code line which triggered the erroneous behaviour:
> 
> It's the definition of the macro xhci_dbg(...) in xhci.h line 1590/1591.
> 
> In 3.11 it is
>   do { if (XHCI_DEBUG) dev_dbg(...); } while (0)
> 
> XHCI_DEBUG is defined as 0 because XHCI_HCD_DEBUGGING is not defined
> so this macro collapses to nothing.
> 
> In 3.12 xhci_dbg(...) is defined as
>   dev_dbg(...)
> which actually calls dev_printk(...) because DEBUG is defined.
> 
> If I define xhci_dbg() in 3.12 as
>   do { } while (0)
> my card reader starts working again.
> 
> That was the good news.
> The bad news is that I have no idea why calling dev_printk(...)
> does any  harm here. Maybe it's a timing problem.
> 
> Best Regards
> Nikolaus Meine
> 

Hello once again!

I have to correct me previous post:
The card reader does actually work with 3.12 so it's just
the dumping of debug messages which was enabled in 3.12,
no timing problem.

Best Regards
Nikolaus Meine


