Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDYUNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:13:30 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:33401 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaDYUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:13:27 -0400
Date: Fri, 25 Apr 2014 23:09:08 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20140425200908.GG575@drone.musicnaut.iki.fi>
References: <20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
 <20131022.135442.1072093301788210177.davem@davemloft.net>
 <20140414184353.GA5630@drone.musicnaut.iki.fi>
 <20140416.145822.1317931249717152474.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416.145822.1317931249717152474.davem@davemloft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 16, 2014 at 02:58:22PM -0400, David Miller wrote:
> One thing you two can do to help me further confirm this is to run
> with THP disabled for a while and see if you still get the log
> messages.
> 
> Simply, as root:
> 
> bash# echo "never" >/sys/kernel/mm/transparent_hugepage/enabled
> 
> And then do your gcc bootstraps or whatever else seems to usually
> run when you trigger this problem.

I'm running my Ultras with "# CONFIG_TRANSPARENT_HUGEPAGE is not set"
and I still see the issue.

I tried reproducing the bug with function tracer running. It works
but reproducing the bug takes several days... This time it was "expect"
segfault during GCC testsuite that triggered the bug.

For the test I added tracing_off() after the "Bad rss-counter
state" printout. Now I see it should be done maybe earlier as warning/bug
printouts are polluting the trace.

Anyway, the results are here:

	http://www.iki.fi/aaro/junk/linux-3.14-sparc-mm-bug-trace.txt
	http://www.iki.fi/aaro/junk/linux-3.14-sparc-mm-bug-trace-dmesg.txt

A.
