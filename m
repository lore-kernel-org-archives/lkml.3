Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaIPJHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:07:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:53715 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbaIPJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:06:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,533,1406563200"; 
   d="scan'208";a="36018273"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov" <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [RFC PATCH 0/3] ns, procfs: pid conversion between ns and
 showing pidns hierarchy
Thread-Topic: [RFC PATCH 0/3] ns, procfs: pid conversion between ns and
 showing pidns hierarchy
Thread-Index: AQHPzteQw9YV0Crmf0W+igvUJvikSpwDcRrA
Date: Tue, 16 Sep 2014 09:06:58 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5ACF79@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140912221852.GA18234@mail.hallyn.com>
In-Reply-To: <20140912221852.GA18234@mail.hallyn.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G977p3026208

Hi,

> -----Original Message-----
> From: Serge E. Hallyn [mailto:serge@hallyn.com]
> 
> Hi,
> 
> so the below is just 30 mins worth of playing around, will hang if you give
> it bad pids, and requires privilege, but shows how to get pid conversion
> in some cases.  Basically it gives you what I had previously suggested
> for the query_pid syscall before.
> 
Thanks for teaching me of how ucred could be used for this case.

> In general, usage is
> 
> translatepid reporter_pid dest_pid query_pid
> 
> where reporter_pid and dest_pid are pids in your pidns.  It will assume
> query_pid is a valid pid in reporter_pid's pidns, and return the pid of
> the same process in dest_pid's namespace.
> 
> In particular,
> 
> if a process in a container (say pid 1, pid 24444 in the host pidns)
> reports something about another process (say pid 262) in the container,
> and you have a shell (pid 1092) on the host, you can figure out the pid
> for 262 in your host pidns using
> 
> translatepid $$ 24444 262
> 
> or to figure out what pid 25152 on the host is knows as in the
> container,
> 
> translatepid 24444 $$ 25152
> 
It's very easy to use:)

> I wonder whether this is enough to give you all you need.  While it
> won't be super-fast, you could use and ppid info to figure out who
> is pid 1, etc.

Yes, functionally it's very good.
But for the cases of utilizes like sosreport, ps,
it's a bit of slow.

So the procfs still has its advantages.
And also, I think the pidns hierarchy is needed.
I'll send the v2 ns hierarchy patch soon.

Thanks,
- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
