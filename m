Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab3DGRwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:52:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154Ab3DGRwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:52:15 -0400
MIME-Version: 1.0
Message-ID: <62e1fe34-e5be-42f5-83af-f8f428fce57b@default>
Date: Sun, 7 Apr 2013 10:51:27 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Bob Liu <bob.liu@oracle.com>,
        Ric Mason <ric.masonn@gmail.com>
Subject: RE: [PATCH part2 v6 0/3] staging: zcache: Support zero-filled pages
 more efficiently
References: <1364984183-9711-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130407090341.GA22589@hacker.(null)>
In-Reply-To: <20130407090341.GA22589@hacker.(null)>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Subject: Re: [PATCH part2 v6 0/3] staging: zcache: Support zero-filled pages more efficiently
> 
> Hi Dan,
> 
> Some issues against Ramster:
> 
> - Ramster who takes advantage of zcache also should support zero-filled
>   pages more efficiently, correct? It doesn't handle zero-filled pages well
>   currently.

When you first posted your patchset I took a quick look at ramster
and it looked like your patchset should work for ramster also.
However I didn't actually run ramster to try it so there may
be a bug.  If it doesn't work, I would very much appreciate a patch.

> - Ramster DebugFS counters are exported in /sys/kernel/mm/, but zcache/frontswap/cleancache
>   all are exported in /sys/kernel/debug/, should we unify them?

That would be great.

> - If ramster also should move DebugFS counters to a single file like
>   zcache do?

Sure!  I am concerned about Konrad's patches adding debug.c as they
add many global variables.  They are only required when ZCACHE_DEBUG
is enabled so they may be ok.  If not, adding ramster variables
to debug.c may make the problem worse.

> If you confirm these issues are make sense to fix, I will start coding. ;-)

That would be great.  Note that I have a how-to for ramster here:

https://oss.oracle.com/projects/tmem/dist/files/RAMster/HOWTO-120817 

If when you are testing you find that this how-to has mistakes,
please let me know.  Or feel free to add the (corrected) how-to file
as a patch in your patchset.

Thanks very much, Wanpeng, for your great contributions!

(Ric, since you have expressed interest in ramster, if you try it and
find corrections to the how-to file above, your input would be
very much appreciated also!)

Dan
