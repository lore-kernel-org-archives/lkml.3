Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3LSFam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:30:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LSFal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:30:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Thu, 19 Dec 2013 06:30:10 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312182210.30544.arnd@arndb.de> <1387401646.31516.14.camel@host5.omatika.ru>
In-Reply-To: <1387401646.31516.14.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312190630.11087.arnd@arndb.de>
X-Provags-ID: V02:K0:Xn4UyGWlp8T58DISHoMj9FdHNLW6NE1b1gqxlnwX+70
 ZGI0CYrvQywcfOT7I8a3sjQlrAIoZg2+eLmhbCuzWeYDvFR4Sf
 SOq6so6FLnH5MzwU7AZIApOX/Go+YDHnwtM12uN67L6j82lMNK
 RBpo7GD9AU/8iyRK+X+pqWoemTXbo4gHZ1fw4HPX974I/bt0HY
 emp0OriM5W/s6ZCNVcIOSQVOsCY6hVLi97hp8/J3GmVoO0edzi
 L8VjWvXCl6CYaf0ohVwZpTx19mSRx6y8ei+PSgbP29sUCc3SCO
 rV3DhfcJE7Vg1X7gD/7gPDBoNJdq4svgeCBu/hwD7G+rlHCWD7
 r8NQ4/dfyKKkPlfr4eiU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013, Sergei Ianovich wrote:
> > You would still be able to boot a kernel with an old dts file on a new
> > kernel if it just contains a "simple-bus" node here, as long as it doesn't
> > need any boot-time setup at the bus controller. We can change the dts
> > file later if we need to add this functionality, which would break booting
> > old kernels with the new dts files, which isn't much of a problem in
> > general.
> 
> It should actually only break old kernels which require new
> functionally. Otherwise, dts can have
> 
> compatible = "marvell,pxa-extbus", "simple-bus";
> 
> and an older kernel will be happy with "simple-bus". Please correct me
> if I'm wrong.

This would work only if we can probe the devices behind the external
bus controller before the controller itsef has been set up, since
the initialization order can depend on a number of things but not
the bus hierarchy. It will also work if the code setting up the
bus controller can be guaranteed to run before we call
of_platform_populate for the regular devices, which is probably
the best solution here.

	Arnd
