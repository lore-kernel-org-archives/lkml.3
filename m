Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaFWKPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:15:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13870 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbaFWKPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:15:44 -0400
X-IronPort-AV: E=Sophos;i="5.00,760,1396972800"; 
   d="scan'208";a="32282776"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Richard Weinberger <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2] ns: introduce getnspid syscall
Thread-Topic: [PATCH v2] ns: introduce getnspid syscall
Thread-Index: AQHPjHcgU6WUVvoJG0i3h/UNsKvNGJt+dQSQ
Date: Mon, 23 Jun 2014 10:15:37 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <53A414B2.20108@nod.at>
In-Reply-To: <53A414B2.20108@nod.at>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5NAFtGW017604

Hi

> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Friday, June 20, 2014 7:02 PM
> To: Chen, Hanxiao/³Â êÏÏö; containers@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Cc: Eric W. Biederman; Serge Hallyn; Daniel P. Berrange; Oleg Nesterov; Al Viro;
> David Howells; Pavel Emelyanov; Vasiliy Kulikov; Gotou, Yasunori/Îåu ¿µÎÄ;
> linux-api@vger.kernel.org
> Subject: Re: [PATCH v2] ns: introduce getnspid syscall
> 
> Am 20.06.2014 12:18, schrieb Chen Hanxiao:
> > We need a direct method of getting the pid inside containers.
> > If some issues occurred inside container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> >
> > int getnspid(pid_t pid, int fd1, int fd2);
> >
> > pid: the pid number need to be translated.
> >
> > fd: a file descriptor referring to one of
> >     the namespace entries in a /proc/[pid]/ns/pid.
> >     fd1 for destination ns(ns1), where the pid came from.
> >     fd2 for reference ns(ns2), while fd2 = -2 means for current ns.
> >
> > return value:
> >     >0 : translated pid in ns1(fd1) seen from ns2(fd2).
> >     <=0: on failure.
> >
> 
> I don't think that adding a new system call for this is a good solution.
> We need a more generic way. I bet people are interested in more than just PID
> numbers.

Could you please give some hints on how to expand this interface?

> 
> I agree with Eric that a procfs solution is more appropriate.
> 

Procfs is a good solution, but syscall is not bad though.
Procfs works for me, but that seems could not fit
Pavel's requirement.
His opinion is that a syscall is a more generic interface
than proc files, and  also very helpful.
And syscall could tell whether a pid lives in a specific pid namespace,
much convenient than procfs.

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
