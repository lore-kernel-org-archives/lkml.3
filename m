Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaE2Jx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:53:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:6725 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbaE2Jx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:53:26 -0400
X-IronPort-AV: E=Sophos;i="4.98,933,1392134400"; 
   d="scan'208";a="31186840"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Pavel Emelyanov <xemul@parallels.com>,
        Vasily Kulikov <segoon@openwall.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "David Howells" <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>
Subject: RE: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
Thread-Topic: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
Thread-Index: AQHPex2Ssq78RPNkjkmtNGv6ld2qyZtXSVLA
Date: Thu, 29 May 2014 09:53:02 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E52A481@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot>
	<53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot>
 <5386F8EA.8050501@parallels.com>
In-Reply-To: <5386F8EA.8050501@parallels.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.62]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4T9rVur007860



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
> > On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
> >> On 05/28/2014 10:28 PM, Vasily Kulikov wrote:
> >>> On Wed, May 28, 2014 at 16:44 +0400, Pavel Emelyanov wrote:
> >>> It will be simplier
> >>> to parse the file -- if 'ns_ids' file contains some ID then this ID for
> >>> every ns can be obtained regardless of the specific ID name (SID, PID,
> >>> PGID, etc.).
> >>
> >> True, but given a task PID how to determine which pid namespaces it lives in
> >> to get the idea of how PIDs map to each other? Maybe we need some explicit
> >> API for converting (ID, NS1, NS2) into (ID)?
> >
> > AFAIU the idea of the patch is to add a new debugging information which
> > can be trivially obtained via 'cat /proc/...':
> 
> I agree, but this ability will be very useful by checkpoint-restore project
> too and I'd really appreciate if the API we have for that would be scalable
> enough. Per-task proc file works for me, but how about sid-s and pgid-s?
> 

Yes, a new syscall is very useful, but it should be another task.
Just for Pids, I think proc file is good enough.

> > ] We need a direct method of getting the pid inside containers.
> > ] If some issues occurred inside container guest, host user
> > ] could not know which process is in trouble just by guest pid:
> > ] the users of container guest only knew the pid inside containers.
> > ] This will bring obstacle for trouble shooting.
> >
> > A new syscall might complicate trouble shooting by admin.
> 
> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
> info? I think that would help.
>

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
