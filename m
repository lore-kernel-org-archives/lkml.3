Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaE0KBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:01:55 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:5030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbaE0KBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:01:52 -0400
X-IronPort-AV: E=Sophos;i="4.98,918,1392134400"; 
   d="scan'208";a="31061654"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Vasily Kulikov <segooon@gmail.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov" <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH] /proc/pid/status: show all sets of pid according to ns
Thread-Topic: [PATCH] /proc/pid/status: show all sets of pid according to ns
Thread-Index: AQHPeQ0jEgXGaeE1U0ynobUh11lkJZtULC/A
Date: Tue, 27 May 2014 10:01:53 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E51F963@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140526180443.GA11145@cachalot>
In-Reply-To: <20140526180443.GA11145@cachalot>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RA1xFS021781

Hi Vasily,

> -----Original Message-----
> From: Vasily Kulikov [mailto:segooon@gmail.com]
> Sent: Tuesday, May 27, 2014 2:05 AM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Serge
> Hallyn; Oleg Nesterov; David Howells; Eric W. Biederman; Andrew Morton; Al Viro
> Subject: Re: [PATCH] /proc/pid/status: show all sets of pid according to ns
> 
> Hi Chen,
> 
> On Mon, May 26, 2014 at 18:05 +0800, Chen Hanxiao wrote:
> > We need a direct method of getting the pid inside containers.
> > If some issues occurred inside a container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> >
> > This patch expands fields of Tgid and Pid:
> > a) In init_pid_ns, nothing changed;
> >
> > b) In one pidns, they will tell the pid inside containers:
> > Tgid:	1628 	9 	3
> > Pid:	1628 	9 	3
> > ** process id is 1628 in level 0, 9 in level 1, 3 in level 2.
> 
> 1. It breaks ABI.  Any application which does something like "grep pid: | cut -d:
> -f2"
> is now broken by the patch.  Maybe add a new field like 'Pid-ns', 'PidNS',
> or 'Pids' and leave the old one for compatibility?
> 

Thanks for your comments.
Adding a new field could solve backward compatibility issue.

> 2. Is it OK to show internal pids to unprivileged processes?  I cannot
> see anything obviously dangerous with it, though.
> 

I thinks just 'showing' them would not bring some troubles.

> > c) If pidns is nested, it depends on which pidns are you in.
> > Tgid:	9 	3
> > Pid:	9 	3
> > ** Views from level 1 for Pid 1628 in host.
> 
> --
> Vasily

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
