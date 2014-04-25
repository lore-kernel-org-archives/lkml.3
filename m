Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaDYUR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:17:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46322 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbaDYURy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:17:54 -0400
Date: Fri, 25 Apr 2014 16:17:53 -0400 (EDT)
Message-Id: <20140425.161753.153968588224593753.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140425200908.GG575@drone.musicnaut.iki.fi>
References: <20140414184353.GA5630@drone.musicnaut.iki.fi>
	<20140416.145822.1317931249717152474.davem@davemloft.net>
	<20140425200908.GG575@drone.musicnaut.iki.fi>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Apr 2014 13:17:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Fri, 25 Apr 2014 23:09:08 +0300

> On Wed, Apr 16, 2014 at 02:58:22PM -0400, David Miller wrote:
>> One thing you two can do to help me further confirm this is to run
>> with THP disabled for a while and see if you still get the log
>> messages.
>> 
>> Simply, as root:
>> 
>> bash# echo "never" >/sys/kernel/mm/transparent_hugepage/enabled
>> 
>> And then do your gcc bootstraps or whatever else seems to usually
>> run when you trigger this problem.
> 
> I'm running my Ultras with "# CONFIG_TRANSPARENT_HUGEPAGE is not set"
> and I still see the issue.

Thanks, that's an important datapoint.

> I tried reproducing the bug with function tracer running. It works
> but reproducing the bug takes several days... This time it was "expect"
> segfault during GCC testsuite that triggered the bug.
> 
> For the test I added tracing_off() after the "Bad rss-counter
> state" printout. Now I see it should be done maybe earlier as warning/bug
> printouts are polluting the trace.
> 
> Anyway, the results are here:
> 
> 	http://www.iki.fi/aaro/junk/linux-3.14-sparc-mm-bug-trace.txt
> 	http://www.iki.fi/aaro/junk/linux-3.14-sparc-mm-bug-trace-dmesg.txt

Thanks a lot for doing this, I'll take a look.
