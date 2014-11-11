Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaKKLU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:20:27 -0500
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:14239 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbaKKLUW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:20:22 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=1oN0sfwJalOpr2aHay7Qy/p3C2/DrgK1QE5UNNaX0S8= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=rOUgymgbAAAA:8 a=xM62jmtblYMnR76zc78A:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4LAPzvYVTD7hTT/2dsb2JhbABcgw6BLYMGtS8CAwabIQKBGBYBAQEBAX2EAgEBAQMBI1YFCwUEAhgCAhgOAgJXBgESEYgnDZl8nF+HAo8vAQEBBwEBAQEegS2FDYonMweCd4FUBbUFg3s8L4JLAQEB
Date: Tue, 11 Nov 2014 12:20:19 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Message-ID: <318149421.176770.1415704819915.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141111131216.3742d156@canb.auug.org.au>
References: <20141111131216.3742d156@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the block tree
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 11 November 2014 at 03:12 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>
> Hi Jens,
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/built-in.o: In function `cdrom_sysctl_handler':
> cdrom_sysctl.c:(.text+0x156d92): undefined reference to `cdrom_mutex'
> cdrom_sysctl.c:(.text+0x156da0): undefined reference to `cdrom_autoclose'
> cdrom_sysctl.c:(.text+0x156dae): undefined reference to `cdrom_autoeject'
> cdrom_sysctl.c:(.text+0x156dbc): undefined reference to `cdrom_debug'
> cdrom_sysctl.c:(.text+0x156dca): undefined reference to `cdrom_lockdoor'
> cdrom_sysctl.c:(.text+0x156dd8): undefined reference to
> `cdrom_check_media_type'
> cdrom_sysctl.c:(.text+0x156e0b): undefined reference to `cdrom_list'
> cdrom_sysctl.c:(.text+0x156e37): undefined reference to `cdrom_autoclose'
> cdrom_sysctl.c:(.text+0x156e57): undefined reference to `cdrom_autoeject'
> cdrom_sysctl.c:(.text+0x156e77): undefined reference to
> `cdrom_check_media_type'
> cdrom_sysctl.c:(.text+0x156ea4): undefined reference to `cdrom_lockdoor'
> cdrom_sysctl.c:(.text+0x156eb5): undefined reference to `cdrom_list'
> cdrom_sysctl.c:(.text+0x15702e): undefined reference to `cdrom_mutex'
> drivers/built-in.o: In function `cdrom_print_info.constprop.0':
> cdrom_sysctl.c:(.text+0x1570f3): undefined reference to `cdrom_list'
> cdrom_sysctl.c:(.text+0x157189): undefined reference to `cdrom_list'
> drivers/built-in.o: In function `cdrom_sysctl_info':
> cdrom_sysctl.c:(.text+0x1572c3): undefined reference to `cdrom_mutex'
> cdrom_sysctl.c:(.text+0x1576dc): undefined reference to `cdrom_mutex'
> drivers/built-in.o: In function `cdrom_sysctl_register':
> (.text+0x157765): undefined reference to `cdrom_autoclose'
> drivers/built-in.o: In function `cdrom_sysctl_register':
> (.text+0x157781): undefined reference to `cdrom_autoeject'
> drivers/built-in.o: In function `cdrom_sysctl_register':
> (.text+0x15778e): undefined reference to `cdrom_debug'
> drivers/built-in.o: In function `cdrom_sysctl_register':
> (.text+0x15779b): undefined reference to `cdrom_lockdoor'
> drivers/built-in.o: In function `cdrom_sysctl_register':
> (.text+0x1577a8): undefined reference to `cdrom_check_media_type'
>
> Probably caused by commit d01681d1457c ("cdrom: export sysctl code").
> This build has CONFIG_SYSCTL=y, CONFIG_BLK_DEV_IDECD=m,
> CONFIG_BLK_DEV_SR=m, CONFIG_PARIDE_PCD=m, CONFIG_CDROM_PKTCDVD=m,
> CONFIG_GDROM=n.
>
> I have used the block tree from next-20141110 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

Hi Stephen,

Problem is in Makefile:

obj-$(CONFIG_BLK_DEV_SR) += cdrom.o
obj-$(CONFIG_PARIDE_PCD) += cdrom.o
obj-$(CONFIG_CDROM_PKTCDVD) += cdrom.o
+obj-$(CONFIG_SYSCTL) += cdrom_sysctl.o

I tried cdrom-$(CONFIG_SYSCTL)  += cdrom_sysctl.o
to add sysctl only when cdrom.o is created

but now

drivers/scsi/sr_mod.ko
drivers/ide/ide-cd_mod.ko
drivers/ide/ide-cd_mod.ko

can't find cdrom.c functions ...

Is there another way to do it ?

Regards,
Fabian
