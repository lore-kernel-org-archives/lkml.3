Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaIKJs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:48:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21600 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699AbaIKJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:48:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35807506"
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
Subject: RE: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Thread-Topic: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Thread-Index: AQHPzXW52D39IzxcskeTy6zc+7EDiZv7qnVA
Date: Thu, 11 Sep 2014 09:48:51 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5A0375@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140910162315.GB7748@mail.hallyn.com>
In-Reply-To: <20140910162315.GB7748@mail.hallyn.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B9n3PO022826



> -----Original Message-----
> From: Serge E. Hallyn [mailto:serge@hallyn.com]
> Sent: Thursday, September 11, 2014 12:23 AM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Richard Weinberger; Serge Hallyn; Oleg Nesterov; David Howells; Eric W. Biederman;
> Al Viro
> Subject: Re: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
> 
> Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> > This patch will show the hierarchy of pid namespace
> > under /proc/pidns like:
> > /proc/pidns
> > â”œâ”€â”€ hierarchy
> > â”‚   â”œâ”€â”€ pidns4026532399
> > â”‚   â”‚   â”œâ”€â”€ pidns -> /proc/2863/ns/pid
> > â”‚   â”‚   â””â”€â”€ pidns4026532515
> > â”‚   â”‚       â””â”€â”€ pidns -> /proc/10611/ns/pid
> > â”‚   â””â”€â”€ pidns4026532504
> > â”‚       â””â”€â”€ pidns -> /proc/4450/ns/pid
> > â””â”€â”€ refresh
> >
> > a) hierarchy dir:
> >   use to show hierarchy infomation using dir and symlinks.
> >   dirs are named as pidns($inum)
> >   a symlink is created under pidns($inum), and linked to
> >   that pid namespace.
> >
> > b) refresh
> >   trigger key.
> >   We need to write sth to /proc/nspid/refresh,
> >   then we could get hierarchy info
> >   under /proc/pidns/hierarchy.
> 
> Ouch.  There may not be a better way, but it sure would be nice if
> we could simply have the list update in real-time.
> 
> If we have to 'echo 1 > /proc/pidns/refresh' to update the fs tree under
> /proc/pidns/ to reflect new pidns activity, then why not just make this
> a text file?  I suppose if it were a textfile you'd be encouraging ppl
> to 'cat pidlist | while read line; do grep line /proc/pidns; done',
> which would cause a refresh of that file for every grep?

Let's expose it in a text file
and refresh it when user open it.
style like:

level1                    level2
/proc/2863/ns/pid /proc/10611/ns/pid 
/proc/4450/ns/pid

It provided fairly the same information as dir trees.
And easy to use too.

> 
> My concern with this approach is that it is unlike any other pseudo-fs
> that I know of, and people may simply expect the fs contents to be
> uptodate rather than a snapshot.
> 
You're right, snapshot is not a good idea.
v2 will use a file /proc/pidns_hierarchy to show.

Thanks,
- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
