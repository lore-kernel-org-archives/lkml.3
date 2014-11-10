Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaKJWAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:09 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49000 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKJWAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:06 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org,
        arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V4 04/14] genirq: Generic chip: Add big endian I/O accessors
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
	<1415342669-30640-5-git-send-email-cernekee@gmail.com>
Date: Mon, 10 Nov 2014 14:00:02 -0800
In-Reply-To: <1415342669-30640-5-git-send-email-cernekee@gmail.com> (Kevin
	Cernekee's message of "Thu, 6 Nov 2014 22:44:19 -0800")
Message-ID: <7hy4riogwt.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Cernekee <cernekee@gmail.com> writes:

> Use io{read,write}32be if the caller specified IRQ_GC_BE_IO when creating
> the irqchip.
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

I bisected a couple ARM boot failures in next-20141110 on atmel sama5 platforms down to
this patch, though I'm not quite yet sure how it's causing the failure.
I'm not getting any console output, so haven't been able to dig deeper
yet.  Maybe the atmel maintainers (Cc'd) can help dig.

I've confirmed that reverting $SUBJECT patch (commit
b79055952badbd73710685643bab44104f2509ea2) on top of next-20141110 gets
things booting again.

Also, it only happens with sama5_defconfig, not with multi_v7_defconfig.

Kevin

