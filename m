Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaKMJop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:44:45 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:37044 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932136AbaKMJon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:44:43 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43329996"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Richard Weinberger <richard@nod.at>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov" <oleg@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "Richard Weinberger" <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: RE: [PATCH v7 1/2] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCH v7 1/2] procfs: show hierarchy of pid namespace
Thread-Index: AQHP/mn1Cs5YgZRQ9k+SS5toqqvYLJxeSLwg
Date: Thu, 13 Nov 2014 09:44:41 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E63280E@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1415786899-13392-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1415786899-13392-2-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5463413E.6000800@nod.at>
In-Reply-To: <5463413E.6000800@nod.at>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD9iqxd022824



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Wednesday, November 12, 2014 7:15 PM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„; Eric W. Biederman; Serge Hallyn; Oleg Nesterov
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; David
> Howells; Richard Weinberger; Pavel Emelyanov; Vasiliy Kulikov; Mateusz Guzik
> Subject: Re: [PATCH v7 1/2] procfs: show hierarchy of pid namespace
> 
> Am 12.11.2014 um 11:08 schrieb Chen Hanxiao:
> > We lack of pid hierarchy information, and this will lead to:
> > a) we don't know pids' relationship, who is whose child:
> >    /proc/PID/ns/pid only tell us whether two pids live in different ns
> > b) bring trouble to nested lxc container check/restore/migration
> > c) bring trouble to pid translation between containers;
> >
> > This patch will show the hierarchy of pid namespace
> > by pidns_hierarchy like:
> >
> > <init_PID> <parent_of_init_PID> <relative PID level>
> >
> > Ex:
> > [root@localhost ~]#cat /proc/pidns_hierarchy
> > 18060 1 1
> > 18102 18060 2
> > 1534  18102 3
> > 1600  18102 3
> > 1550  1 1
> > *Note: numbers represent the pid 1 in different ns
> >
[snip]
> > +
> > +#define NS_HIERARCHY	"pidns_hierarchy"
> > +#define MAX(a, b) ((a) > (b) ? (a) : (b))
> 
> Please use max() from kernel.h, there is no need to reinvent the wheel.
> 

Thanks for your reminding.

> > +
> > +/* list for host pid collection */
> > +struct pidns_list {
> > +	struct list_head list;
> > +	struct pid *pid;
> > +	int show_level;
> 
> s/show_level/level, to keep it easy. :-)

Sure, also change the type to unsigned int 
for making max() happy.

[snip]
> > +}
> > +
> > +/*
> > + * collect pids and stored in pidns_pid_list,
> 
> s/stored/store
Oops...

> 
> > + * then remove duplicated ones,
> > + * add the rest to pidns_pid_tree
> > + */
> 
> This comment is a bit confusing.
> 
> What about "proc_pidns_list_refresh - Finds all init pids, places them into
> pidns_pid_list
> and then stores the hirarchy into pidns_pid_tree."?
> 
That's much more clear.

> Beside of my minor comments I like the patch. :-)
> Thanks a lot for doing this work!
> 

Thanks for your kindly help. :)

- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
