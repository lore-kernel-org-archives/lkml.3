Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaIZKU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:20:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756072AbaIZKUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:20:24 -0400
X-IronPort-AV: E=Sophos;i="5.04,603,1406563200"; 
   d="scan'208";a="36518164"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Thread-Topic: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according
 to ns
Thread-Index: AQHP195u16fgq2K+Ek2axoqmdIkT2JwTNPWA
Date: Fri, 26 Sep 2014 10:20:02 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5C7377@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1411552827-31056-3-git-send-email-chenhanxiao@cn.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8QAKbAm030827

Hi,

> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
> Hanxiao
> Sent: Wednesday, September 24, 2014 6:00 PM
> To: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Cc: Richard Weinberger; Serge Hallyn; Oleg Nesterov; Mateusz Guzik; David Howells;
> Eric W. Biederman
> Subject: [PATCHv3 2/2] /proc/PID/status: show all sets of pid according to ns
> 
> If some issues occurred inside a container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
> 
> This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
> a) In init_pid_ns, nothing changed;
> 
> b) In one pidns, will tell the pid inside containers:
> NStgid:	21776   5       1
> NSpid:  21776   5       1
> NSpgid:	21776   5       1
> NSsid:  21729   1       0
> ** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.
> 
> c) If pidns is nested, it depends on which pidns are you in.
> NStgid: 5       1
> NSpid:  5       1
> NSpgid: 5       1
> NSsid:  1       0
> ** Views from level 1
> 

This patch is simple, useful and safe.
But currently there is not any feedbacks.

Any comments or ideas? 

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
