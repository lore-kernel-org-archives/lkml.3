Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbaCUIhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:37:54 -0400
Received: from sam.nabble.com ([216.139.236.26]:51405 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaCUIhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:37:52 -0400
Date: Fri, 21 Mar 2014 01:37:51 -0700 (PDT)
From: ivory <ich7@gmx-topmail.de>
To: linux-kernel@vger.kernel.org
Message-ID: <1395391071859-827938.post@n7.nabble.com>
In-Reply-To: <tip-0y9dqmmsousf69wutxwl3kkf@git.kernel.org>
References: <tip-0y9dqmmsousf69wutxwl3kkf@git.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Move reserving low memory later in
 initialization
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seems to make the bios_corruption_check not to cover the lowest
64kB of memory anymore but only the lowest 4kB. Was this deliberate?
When I use kernel 3.9 or higher I always get low mem corruption message from
the bios corruption checker when I resume from suspend.

Below kernel 3.9 I see this boot message:
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
(reserved)
... which is the 64kB.

But on newer kernels the message changed to:
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
... which is only 4kB.

The corrupted low mem areas I get the message for after resuming from
suspend is this:
 Corrupted low memory at c0002d00 (2d00 phys) = 11060000
 Corrupted low memory at c0002d04 (2d04 phys) = 80805122
 Corrupted low memory at c0002d08 (2d08 phys) = 00860003

How to fix this in kernel 3.9 and higher?

Thanks for your help and best regards.



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/tip-x86-mm-x86-mm-Move-reserving-low-memory-later-in-initialization-tp601280p827938.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
