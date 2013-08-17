Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3HQTNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:13:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3HQTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:13:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Date: Sat, 17 Aug 2013 21:12:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172112.30773.arnd@arndb.de>
X-Provags-ID: V02:K0:6dKqo8R5fBv3LchLfCJ11RHczm7fiat1Nwn9k6Ye2X2
 JAKnVLIAIceLtgONC+refdzJVNgeBvGuuDZ7U50JMoGTn1VMs9
 JiBYyP3ATr+w3pusFLeSt+xmhhRVIpfwuL2g17w19IOimDgHod
 nOolY60HgIj88JIfTORq/G3nXyueeoup0QPo9MYcQXkde9Kmoe
 5RF4r7ctUGzoqFtUZ38XPDq1sNf1nQ78romiu1EHBUThPpov7d
 eND1KuGo48qS/nVN7cQGfhXUJIgme3tJrfj4DstJOg/rRUYzu3
 oKvfDl0oX+znWZf4/1pO84xffjuyF4GR2UCRuDxNEv1Q5csfXx
 +vho6j1joXtrVGEyLUjk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 August 2013, Sebastian Hesselbarth wrote:
> +config MACH_ARMADA_1500
> +       bool "Marvell Armada 1500 boards"
> +       select ARMADA_1500_CLK
> +       select ARM_GIC
> +       select CACHE_L2X0
> +       select CPU_PJ4B
> +       select DW_APB_TIMER_OF
> +       select LOCAL_TIMERS if SMP
> +       select HAVE_ARM_TWD if LOCAL_TIMERS
> +       select HAVE_SMP
> +       select PINCTRL_ARMADA_1500

Hmm, I also noticed that this enables support for both the Cortex-A9
(using GIC and L2X0) and the PJ4 based variants of Armada 1500. I
wonder if we should have separate options for the two. E.g. if you
want to build a kernel for the Chromecast, there would be no need to
enabled PJ4 support.

I have not been able to find out which core is used in most of the
production Google TV boxes.

	Arnd
