Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab3LIAzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 19:55:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3LIAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 19:55:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Mon, 9 Dec 2013 01:54:59 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com> <201312080321.12001.arnd@arndb.de> <1386486335.7152.83.camel@host5.omatika.ru>
In-Reply-To: <1386486335.7152.83.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090154.59534.arnd@arndb.de>
X-Provags-ID: V02:K0:iliJ8H4TsXG2FdMEqiWabpr6GgtK7hApg2hWyiieSVy
 8F6xoQbYDqFetHMraz+ZbqDATnr0U5xGA40n4xMQd8pwL06g9h
 i+zLoE5r3J5PmcVEo+0Fm2z6zSiS3xRhP9WYml4GMJfqErgyw0
 0SGF+fGApzDTLjWNP7lHN6e/7cG84Jhv37PItMTxG2IHRdbdHB
 zGvaM8xTYR0H1MAC0urmEkE2oqTjGEVKuecQJzYg5ZGJ16OKZ1
 cL7jsbELYm0b/T33b3kvaliLjUgpfvjIdVThVo/XXxtBUQtjmR
 a0IPVmRSy7TcxwGlREfqNlLanK04uQnsm4jNsxgiTD8UrQrLv1
 8h5mI8HT67Pdy7ZuvImU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 December 2013, Sergei Ianovich wrote:
> On Sun, 2013-12-08 at 03:21 +0100, Arnd Bergmann wrote:
> > On Friday 06 December 2013, Sergei Ianovich wrote:
> > You have some rather unusual options in here. I'd suggest you go through
> > the reduced defconfig file and remove all options that look like they
> > are unnecessary for your system.
> > 
> > It's probably based on some distro config that enables lots of modules
> > you don't actually want.
> 
> I tried to future-proof the config, by enabling all partition tables and
> USB disks and modems that could be plugged into the device.
> 
> I'll remove those. However, I would like to retain config options
> related to low latency and small kernel size. Keeping them will
> hopefully allow being notified about changes affecting the system.
> 
> Will this fly?

Yes, of course, keep as many as you need. I was just trying to ensure
that you had put some thought in it, and e.g. the various USB serial
modules and some other things appeared to be fairly random, but I can
see them making sense now.

> > #define LP8X4X_EOI              0x0006
> > #define LP8X4X_INSINT           0x0008
> > ...
> > 
> > and change the users to do e.g.
> > 
> >         readl(LP8X4X_FPGA_VIRT + LP8X4X_INSINT);
> 
> I am trying to boot the system with device tree. If I manage, I'll move
> this code into drivers/irqchip/ as a platform device. Otherwise, I'll
> make this change.

Ok, cool. If you need help with the DT conversion, just ask here or on
IRC (#armlinux or #mvlinux on freenode.net, there might also be a
PXA specific channel I don't know).

	Arnd
