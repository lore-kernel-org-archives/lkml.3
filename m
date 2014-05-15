Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaEOTh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:37:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35470 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaEOThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:37:24 -0400
Date: Thu, 15 May 2014 15:37:21 -0400 (EDT)
Message-Id: <20140515.153721.2222505094570361361.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru
Subject: Re: [PATCH] net: tunnels - enable module autoloading
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399970908-9973-1-git-send-email-teg@jklm.no>
References: <1399970908-9973-1-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 12:37:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4FJbdfO017129

From: Tom Gundersen <teg@jklm.no>
Date: Tue, 13 May 2014 10:48:28 +0200

> Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.
> 
> This is in line with how most other netdev kinds work, and will allow userspace
> to create tunnels without having CAP_SYS_MODULE.
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Tested-by: Susant Sahani <susant@redhat.com>

This doesn't even compile:

  CC [M]  net/ipv4/ipip.o
In file included from include/linux/module.h:17:0,
                 from net/ipv4/ipip.c:95:
include/linux/moduleparam.h:21:1: error: expected ¡,¢ or ¡;¢ before ¡static¢
 static const char __UNIQUE_ID(name)[]       \
 ^
include/linux/module.h:86:32: note: in expansion of macro ¡__MODULE_INFO¢
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
                                ^
include/linux/module.h:89:30: note: in expansion of macro ¡MODULE_INFO¢
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
                              ^
include/linux/netdevice.h:3283:2: note: in expansion of macro ¡MODULE_ALIAS¢
  MODULE_ALIAS("netdev-" device)
  ^
net/ipv4/ipip.c:490:1: note: in expansion of macro ¡MODULE_ALIAS_NETDEV¢
 MODULE_ALIAS_NETDEV("tunl0");
 ^
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
