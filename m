Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3FSPU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:20:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3FSPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:20:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
Date: Wed, 19 Jun 2013 17:20:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        "Linux-Arch" <linux-arch@vger.kernel.org>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com> <201306141636.29390.arnd@arndb.de> <1371226483.2726.19.camel@dabdike>
In-Reply-To: <1371226483.2726.19.camel@dabdike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191720.47185.arnd@arndb.de>
X-Provags-ID: V02:K0:Tst3BQDX3MCBUyhws/HZ7TCkaWWVMR5QGCQ50S4R0Z4
 bes4gF8dre1ycQn3HHLJAu8YIdbiImCmiPiZmcjd96QrRHWg7B
 SmCIiEnck8/XIJRvP1QzTBV/ue6s8tGHPo+C9GHPkRfK8LIwG+
 jIW61Io7QjJ/mFTaMjmu6lJARW9IjuexeHCd015Pk62rGq6TVJ
 ZjuUHTjY9zMfdp+OWxSe5tTmS2Np96Ip04Hz9itfCxASXPhqSP
 j5xak4LVPWVJLQeHAZjeGrs1TM+ArlHoLQQgp8JbjX63iEbg6J
 qx/9578pCZ1OnjBrxGsL001DJ7+rZL0WLD0+3WOSs0FgExaJT2
 MEyUs9c79DqGkkKssKdk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013, James Bottomley wrote:
> This is the MMAP_PAGE_ZERO exploit.  The original exploit relied on a
> leaky personality capability clearing mask and was fixed in 2.6.31 by
> 
> commit f9fabcb58a6d26d6efde842d1703ac7cfa9427b6
> Author: Julien Tinnes <jt@cr0.org>
> Date:   Fri Jun 26 20:27:40 2009 +0200
> 
>     personality: fix PER_CLEAR_ON_SETID
> 
> So it's not really relevant to 3.x kernels, is it?

Probably not. There is always a risk that something like this
can turn into an exploit, but it needs a combination with a couple
of other bugs.

	Arnd
