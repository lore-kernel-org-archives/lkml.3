Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbaLJToh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:44:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47105 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLJTog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:44:36 -0500
Date: Wed, 10 Dec 2014 14:44:30 -0500 (EST)
Message-Id: <20141210.144430.1749715282635917425.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141210.134804.1383875260695429574.davem@davemloft.net>
References: <5487DBD9.1010908@cn.fujitsu.com>
	<20141210.134804.1383875260695429574.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 11:44:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAJilt7008456

From: David Miller <davem@davemloft.net>
Date: Wed, 10 Dec 2014 13:48:04 -0500 (EST)

> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Wed, 10 Dec 2014 13:36:25 +0800
> 
>> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
>> cmsghdr from msghdr, just cleanup. 
>> 
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Applied, thanks.

This breaks the build, I'm reverting.

You cannot use your new macros in
Documentation/networking/timestamping/txtimestamp.c, that is a
userland program and the header you are adding your helper to is not
available to userspace.

This also means you didn't sufficiently test the build of your
changes.

Documentation/networking/timestamping/timestamping.c: In function ¡printpacket¢:
Documentation/networking/timestamping/timestamping.c:172:2: warning: implicit declaration of function ¡for_each_cmsghdr¢ [-Wimplicit-function-declaration]
Documentation/networking/timestamping/timestamping.c:172:30: error: expected ¡;¢ before ¡{¢ token
Documentation/networking/timestamping/timestamping.c:161:18: warning: unused variable ¡ts¢ [-Wunused-variable]
Documentation/networking/timestamping/timestamping.c:160:17: warning: unused variable ¡tv¢ [-Wunused-variable]
make[3]: *** [Documentation/networking/timestamping/timestamping] Error 1
make[3]: *** Waiting for unfinished jobs....
Documentation/networking/timestamping/txtimestamp.c: In function ¡__recv_errmsg_cmsg¢:
Documentation/networking/timestamping/txtimestamp.c:187:2: warning: implicit declaration of function ¡for_each_cmsghdr¢ [-Wimplicit-function-declaration]
Documentation/networking/timestamping/txtimestamp.c:187:19: error: ¡cmsg¢ undeclared (first use in this function)
Documentation/networking/timestamping/txtimestamp.c:187:19: note: each undeclared identifier is reported only once for each function it appears in
Documentation/networking/timestamping/txtimestamp.c:187:30: error: expected ¡;¢ before ¡{¢ token
Documentation/networking/timestamping/txtimestamp.c:185:18: warning: unused variable ¡cm¢ [-Wunused-variable]
Documentation/networking/timestamping/txtimestamp.c:184:27: warning: unused variable ¡tss¢ [-Wunused-variable]
Documentation/networking/timestamping/txtimestamp.c:183:28: warning: unused variable ¡serr¢ [-Wunused-variable]
Documentation/networking/timestamping/txtimestamp.c: At top level:
Documentation/networking/timestamping/txtimestamp.c:123:13: warning: ¡print_timestamp¢ defined but not used [-Wunused-function]
Documentation/networking/timestamping/txtimestamp.c:159:13: warning: ¡print_pktinfo¢ defined but not used [-Wunused-function]

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
