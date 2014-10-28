Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaJ1VF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:05:29 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53245 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1VF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:05:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Hengelein <stefan.hengelein@fau.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kaloz@openwrt.org, khalasa@piap.pl, linux@arm.linux.org.uk
Subject: Re: [PATCH] ARM: ixp4xx: remove compilation warnings in io.h
Date: Tue, 28 Oct 2014 22:04:38 +0100
Message-ID: <16633577.GiaBADujtQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413740985-20365-1-git-send-email-stefan.hengelein@fau.de>
References: <1413740985-20365-1-git-send-email-stefan.hengelein@fau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YlG/IP0TwVuR+ZE+Vv+YqJgYGofGHbuVoP0kuqZmz2+
 tVU8+xGL9Mvz+IoEGCZLpDwLXpwgKdElePrf1fGoaHJoE2D/w6
 lC45TfFc6lM1gNjArKTlC7uy8xJZcAYWdeA5ErC1Sb5f9Vxn1b
 D2PeTvZvbn66Vgx7Puyt+yL5DPKXRMYv2e19YuMMnlilOe34m/
 zz5cRJXm9U3JMiHV2SQOrgSq9l+6Xk3MnGW3u+l7tFKWfD49sT
 mHCe4HXjgH9+Lz8HZB94ULh5zgIHJFQ1ErKDZ/wb6mEmVcnJsg
 gNYz52xdsZFHerwjWA38d7CDkYnY6hqJ+sGC+nG4b/DxxahXiK
 aCJk2NjKScuLpcoG+83U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 October 2014 19:49:45 Stefan Hengelein wrote:
> When arch/arm/mach-ixp4xx/common-pci.c is compiled, two warnings
> occur:
> 
> arch/arm/mach-ixp4xx/include/mach/io.h:144: warning: passing argument 1 of '__raw_readb' makes pointer from integer without a cast
> arch/arm/mach-ixp4xx/include/mach/io.h:79: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast
> 
> Both functions expect an 'volatile void __iomem *' but get an u32.
> The 'u32 addr' variable is initialized with the address of an
> 'volatile void __iomem *' pointer. Passing the pointer
> directly, avoids the warning and semantics are preserved.
> 
> This warning was found with vampyr.
> 
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>

Applied on fixes branch, thanks!

	Arnd
