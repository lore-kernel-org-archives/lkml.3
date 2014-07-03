Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaGCMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:18:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43321 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbaGCMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:18:37 -0400
X-IronPort-AV: E=Sophos;i="5.00,826,1396972800"; 
   d="scan'208";a="32794633"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Serge Hallyn (serge.hallyn@ubuntu.com)" <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC]Pid conversion between pid namespace
Thread-Topic: [RFC]Pid conversion between pid namespace
Thread-Index: Ac+WpagelAqWSmeOTWy8zWQgFaQt9g==
Date: Thu, 3 Jul 2014 12:18:33 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s63CIlO1008356

Hi,

We had some discussions on how to carry out
pid conversion between pid namespace via:
syscall[1] and procfs[2].

Pavel suggested that a syscall like
(ID, NS1, NS2) into (ID).

Serge suggested that a syscall 
pid_t getnspid(pid_t query_pid, pid_t observer_pid).


Eric and Richard suggested a procfs solution is
more appropriate.

Oleg suggested that we should expand /proc/pid/status
to report this kind of information.

And Richard suggested adding a directory like
/proc/<pidX>/ns/proc/ which would contain everything
from /proc/<pidX inside the namespace>/.

As procfs provided a more user friendly interface,
how about expose all sets of tgid, pid, pgid, sid 
by expanding /proc/PID/status in procfs?
And we could also expose ns hierarchy under /proc,
which could be another reference.

Ex:
    init_pid_ns    ns1         ns2
t1  2
t2   `- 3          1 
t3       `- 4      `- 5        1

We could get in /proc/t3/status:
NSpid: 4 5 1
We knew that pid 1 in container is pid 4 in init ns.

And we could get ns hierarchy under /proc/ns_hierarchy like:
init_ns->ns1->ns2		(as the result of readlink)
         ->ns3
We knew that t3 in ns2, and its hierarchy.

How these ideas looks like?
Any comments would be appreciated.

Thanks,
- Chen


a) syscall
http://lwn.net/Articles/602987/

b) procfs
http://www.spinics.net/lists/kernel/msg1751688.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
