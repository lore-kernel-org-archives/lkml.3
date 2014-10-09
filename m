Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaJIJBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:01:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:57519 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754719AbaJIJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:01:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,683,1406563200"; 
   d="scan'208";a="37005236"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Richard Weinberger <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: RE: [PATCHv4] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCHv4] procfs: show hierarchy of pid namespace
Thread-Index: AQHP4uOJLRNNrORQX06m7Z2hZe7Ft5wncYSg
Date: Thu, 9 Oct 2014 09:01:21 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5E1460@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5435134E.1080802@nod.at>
In-Reply-To: <5435134E.1080802@nod.at>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9991Yu5029323



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Wednesday, October 08, 2014 6:35 PM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„; containers@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Cc: Serge Hallyn; Eric W. Biederman; Oleg Nesterov; David Howells; Richard
> Weinberger; Pavel Emelyanov; Vasiliy Kulikov; Mateusz Guzik
> Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
> 
> Am 08.10.2014 11:56, schrieb Chen Hanxiao:
> > This patch will show the hierarchy of pid namespace
> > by /proc/pidns_hierarchy like:
> >
> > [root@localhost ~]#cat /proc/pidns_hierarchy
> > /proc/18060/ns/pid /proc/18102/ns/pid /proc/1534/ns/pid
> > /proc/18060/ns/pid /proc/18102/ns/pid /proc/1600/ns/pid
> > /proc/1550/ns/pid
> 
> A proc file that prints paths of other proc files, srsly? ;)

Yes, sounds weird  though.

> I didn't follow the whole discussion but why is this not
> a directory containing symbolic links to other pid files in /proc/<PID>/ns/pid?

In the v1 version itâ€™s a directory, and contained symlinks to /proc/<PID>/ns/pid
But we found that is not so easy to use:
a) dirs looks like a snapshot
refreshing it needs a lot of unnecessary codes.

b) dirs did not provide more info than proc file
	What we really need is the <PID>, and we could get it from
	proc file.
	When we read the file, we refresh it at that time.

Thanks,
- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
