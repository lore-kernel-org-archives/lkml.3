Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3HQTNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:13:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab3HQTNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:13:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Date: Sat, 17 Aug 2013 21:13:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130816204831.GX13964@titan.lakedaemon.net> <201308172108.38824.arnd@arndb.de>
In-Reply-To: <201308172108.38824.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172113.41376.arnd@arndb.de>
X-Provags-ID: V02:K0:c3Ilvy01lM0PUwH7ci1XnDut+icoC57B/YOMMgVFYYD
 IIxBzpZSLaMv2QgiL9Qd3Uwew0764JX4VpKJjFJ86jZQQ8IjYg
 KXJuUWzwbrd8fv5MtizgtNoR/wLIZZS+y/DP6178N/clCc5ns+
 9ZaRcg3+Rf2bCeZMxjP8goM3tZibRLZSwQNjH0ZsPrD5oZmVfU
 5fbi9j+V2VWpgdQ58m3HJdkrByc6kii9Ya0WcbgFDg4XCWGAYB
 ekZxfS8btp/eryzoWSPPqiacANJQn8aFTmdd1A3UEIiLmlVMJX
 kmDiku2pe2bQAmaWGfdq3JMB1AlF2Rnb2g73RXfXpBiCGmXJjE
 dtpcDPM0E2WwTy0n7HJY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 August 2013, Arnd Bergmann wrote:
> On Friday 16 August 2013, Jason Cooper wrote:
> > > +

> 
> You should really try to find out what driver uses this. If you have a requirement
> that VIRT == PHYS here, the most likely explanation is that some driver accidentally
> uses readl/writel on the physical address rather than on the result of ioremap.
> 
> You can try shrinking the area using bisection until you have found the offending
> driver based on the address.
> 

> > > +static void __init armada_1500_timer_and_clk_init(void)
> 
> New platforms should call this as 'l2x0_of_init(0, 0);' and get the bits from DT.
> 
> Note that we should really change the common code to do both the of_clk_init()
> and the l2x0_of_init() automatically, but that needs to be done with some care,
> in order to not break any of the existing platforms. Would you be able to do
> one of the two? We can then get the next person that wants to add a platform
> to do the last one ;-)


I replied to the wrong mail. My comments were obviously meant for Sebastian,
not for Jason.

	Arnd
