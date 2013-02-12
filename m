Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052Ab3BLA0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:26:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:52512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687Ab3BLA0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:26:31 -0500
Message-ID: <1360628726.17442.19.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Date: Tue, 12 Feb 2013 11:25:26 +1100
In-Reply-To: <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <201302111526.37892.arnd@arndb.de>
	 <CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
	 <201302111543.46196.arnd@arndb.de>
	 <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 16:57 +0100, Michal Simek wrote:
> But it reminds me that maybe the easiest solution is not to use endian
> accessors just use two simple macros which should work on all systems.
> 
> #define <name>_readreg(offset)          ({__raw_readl(offset); rmb(); })
> #define <name>_writereg(offset, val)    ({wmb(); __raw_writel(val, offset); })
> 
> which is probably the faster solution which add minimum additional code
> to driver and can also remove endian detection code.

Except that rmb & wmb might not be the right barriers for IOs ...

Cheers,
Ben.


