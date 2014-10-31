Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbaJaVh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:37:28 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59029 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJaVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:37:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: at91: rm9200 add system timer resources to watchdog
Date: Fri, 31 Oct 2014 22:36:55 +0100
Message-ID: <3833756.aJxOhkuG91@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141031205756.GB11327@piout.net>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com> <3170633.12AsIiHlY5@wuerfel> <20141031205756.GB11327@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FoPnmnEn6Og0kDuJSD4mq+ideXJlwR3lsloHk/JoDuo
 Q/UZ3RyP/J0Z00mXi7v5wJ6m7S9eKKByzyy698hxlv6mzwWIUc
 K2ncCTr8Zg7tTXwkE6+2cIlG2XYwLCzxdFnzWVcaCtxGtZcI+T
 BlkzMLLFhaZObVHWGCT0bWp10MkYnOu6G1Cr2D6JVPgG7EODz+
 uALWwCxnzYQmBZsg3+NkJJNoleFwMj6qR2Cbh+nxUh1ZE7kGca
 gru6UxV5mW9VDZUTIg2XfSQGFngjaU3yXXabZZvijEzmKv3KjK
 vTjMZ0p5c3BpgAH9EeJ3hU3rfacBXA8lZDPoP8dv012a/7IE5B
 PAfNLi3etvnxV9blkU9M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2014 21:57:56 Alexandre Belloni wrote:
> On 31/10/2014 at 21:50:05 +0100, Arnd Bergmann wrote :
> > On Friday 31 October 2014 21:45:58 Alexandre Belloni wrote:
> > > To be able to make the watchdog driver independent from the mach/ includes, pass
> > > the system timer register space as a resource.
> > > 
> > > Also, change the name to avoid conflicting with the at91sam9 watchdog driver.
> > > 
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > > 
> > 
> > Doing this change as a separate patch breaks bisection because now the device
> > name no longer matches untile the other patch is applied too.
> > 
> 
> Yeah, I was not sure how important that was as there is no user of the
> watchdog in the kernel. My thinking was that both patch can then go
> through different trees.
> 
> I can definitely squash them.

AFAICT, arch/arm/configs/at91rm9200_defconfig enables the device and it
gets registered through at91_add_standard_devices. You definitely have
my Ack to merge the mach-at91 patch through the watchdog tree.

	Arnd
