Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaEPRSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:18:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:11150 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbaEPRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="512875569"
From: "Luck, Tony" <tony.luck@intel.com>
To: Shy Shuky <rousya@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>,
        "xiexiuqi@huawei.com" <xiexiuqi@huawei.com>
Subject: RE: [PATCH] time: Provide full featured jiffies_to_nsecs() function
Thread-Topic: [PATCH] time: Provide full featured jiffies_to_nsecs() function
Thread-Index: AQHPcRKVIK4lOPm6x0SG99JQVqbgGJtDbdtA
Date: Fri, 16 May 2014 17:17:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3280B567@ORSMSX114.amr.corp.intel.com>
References: <20140408153412.0648fb96@gandalf.local.home>
	<0286550@agluck-desk.sc.intel.com>
 <CAAhUcTTDQPZAC+Xg3u-KQvBwGX=B9HU5dnCjC7AJcUTDY2QLpw@mail.gmail.com>
In-Reply-To: <CAAhUcTTDQPZAC+Xg3u-KQvBwGX=B9HU5dnCjC7AJcUTDY2QLpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4GHIIYp024304

> How about get uptime by get_monotonic_boottime() directly, which's
> the same as /proc/uptime.

I don't know.  get_monotonic_boottime() had existed for many releases
at the point the uptime trace clock was added - so it was an available
choice. Maybe not noticed by

Is this function safe to call in every context (including NMI & machine check)?
[it uses read_seqcount_begin/read_seqcount_retry ... which I *think* is
safe ... but this stuff is tricky, so I'd like some reassurance].

Mauro, Steven: Did we just do math on jiffies because we wanted less overhead
in a tracepoint?

Bigger question (mostly for Mauro) ... what was the motivation for the "uptime"
tracer to begin with?  The rasdaemon code that is using it converts the times
from traces into absolute times (by adding an offset it computes by comparing
uptime and gettimeofday() when it starts).  But this would seem to be fraught
with problems:
1) Do we get this right for events that happen in daylight saving time shift windows?
2) Is there a "drift" problem for systems that stay up for months and rely on ntp
to keep wall clock time in line with reality?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
