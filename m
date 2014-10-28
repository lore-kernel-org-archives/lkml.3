Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaJ1JKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:10:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42255 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491AbaJ1JJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:09:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,801,1406563200"; 
   d="scan'208";a="42464763"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [RESEND][PATCH 0/2v5] ns,	procfs: pid conversion between ns and
 showing pidns hierarchy
Thread-Topic: [RESEND][PATCH 0/2v5] ns,	procfs: pid conversion between ns
 and showing pidns hierarchy
Thread-Index: AQHP73OQgpl3rs/bFU6R2pG4xmbLX5xFNz1Q
Date: Tue, 28 Oct 2014 09:10:00 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E606120@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1414145745-30293-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1414145745-30293-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9S9A8AN023380



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
> Hanxiao
> Sent: Friday, October 24, 2014 6:16 PM
> To: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Cc: Richard Weinberger; Serge Hallyn; Oleg Nesterov; Mateusz Guzik; David Howells;
> Eric W. Biederman
> Subject: [RESEND][PATCH 0/2v5] ns, procfs: pid conversion between ns and showing
> pidns hierarchy
> 
> This series will expose pid inside containers
> via procfs.
> Also show the hierarchy of pid namespcae.
> Then we could know how pid looks inside a container
> and their ns relationships.
> 
> 1. helpful for nested container check/restore
> From /proc/PID/ns/pid, we could know whether two pid lived
> in the same ns.
> From this patch, we could know whether two pid had relationship
> between each other.
> 
> 2. used for pid translation from container
> Ex:
>      init_pid_ns    ns1         ns2
>  t1  2
>  t2   `- 3          1
>  t3   `- 4          3
>  t4       `- 5      `- 5        1
>  t5       `- 6      `- 8        3
> 
> It could solve problems like: we see a pid 3 goes wrong
> in container's log, what is its pid on hosts:
> a) inside container:
> # readlink /proc/3/ns/pid
> pid:[4026532388]
> 
> b) on host:
> # cat /proc/pidns_hierarchy
> 14918 16263
> 16581
> Then we could easily find /proc/16263/ns/pid->4026532388.
> On host, we knew that reported pid 3 is in level 2,
>    and its parental pid ns is from pid 14918.
> 
> c) on host, check child of 16263, grep it from status:
> NSpid:  16268   8       3
> 
> We knew that pid 16268 is pid 3 reported by container.
> 

Hi,

Any comments?

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
