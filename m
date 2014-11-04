Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaKDIbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:31:32 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:10662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752409AbaKDIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:31:27 -0500
X-IronPort-AV: E=Sophos;i="5.04,845,1406563200"; 
   d="scan'208";a="42814357"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "serge@hallyn.com" <serge@hallyn.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCHv5] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCHv5] procfs: show hierarchy of pid namespace
Thread-Index: AQHP9Tjd+ELnxFHceEOKh+ztGUpbhpxOpQXA
Date: Tue, 4 Nov 2014 08:31:27 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E619A56@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1413460916-2852-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <g2lzcx.nebnfr.1hgfdih-qmf@mail.hallyn.com>
In-Reply-To: <g2lzcx.nebnfr.1hgfdih-qmf@mail.hallyn.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA48VdB6014485



> -----Original Message-----
> From: serge@hallyn.com [mailto:serge@hallyn.com]
> Sent: Saturday, November 01, 2014 2:31 AM
> To: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Chen,
> Hanxiao/é™ˆ æ™—éœ„
> Cc: Richard Weinberger; Serge Hallyn; Oleg Nesterov; Mateusz Guzik; David Howells;
> Eric W. Biederman
> Subject: Re: [PATCHv5] procfs: show hierarchy of pid namespace
> 
> If pidns_list_add fails, the get_pid taken in the caller leaks.
> 
Will fix in the next patch.

> It's not clear to me that the loop in 'if curns' will always end in a list_add_tail,
> and if not the get_pid leaks.  It does look like it should, but something to catch
> the unexpected failure (especially after someone modifies that code) would be
> nice

The previous version collect all namespace's pids on host,
in one scenario we had to add them into list according to curr_ns;
another scenario we add them into list directly.
But now using find_ge_pid, we only collect pids of current ns,
so these codes are redundant.
Sorry for that mistake.

Thanks,
- Chen

> On 10/16/14 7:01 Chen Hanxiao wrote:
> We lack of pid hierarchy information, and this will lead to:
> a) we don't know pids' relationship, who is whose child:
>    /proc/PID/ns/pid only tell us whether two pids live in same ns;
> b) bring trouble to nested lxc container check/restore/migration
> c) bring trouble to pid translation between containers;
> 
> This patch will show the hierarchy of pid namespace
> by pidns_hierarchy like:
> 
> [root@localhost ~]#cat /proc/pidns_hierarchy
> 18060 18102 1534
> 18060 18102 1600
> 1550
> *Note: numbers represent the pid 1 in different ns
> 
> It shows the pid hierarchy below:
> 
>       init_pid_ns (not showed in /proc/pidns_hierarchy)
>               â”‚
> â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
> ns1                      ns2
> â”‚                        â”‚
> 1550                    18060
>                           â”‚
>                           â”‚
>                          ns3
>                           â”‚
>                         18102
>                           â”‚
>                  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
>                  ns4                   ns5
>                  â”‚                    â”‚
>                 1534                  1600
> 
> Every pid printed in pidns_hierarchy
> is the init pid of that pid ns level.
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---

[snip]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
