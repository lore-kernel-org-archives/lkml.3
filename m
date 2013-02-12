Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3BLMbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:31:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:50624 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab3BLMbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:31:52 -0500
Message-ID: <1360672254.2035.8.camel@pasglop>
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
Date: Tue, 12 Feb 2013 23:30:54 +1100
In-Reply-To: <CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <201302111543.46196.arnd@arndb.de>
	 <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
	 <201302111608.29304.arnd@arndb.de>
	 <CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 11:11 +0100, Michal Simek wrote:
> For high performance IPs using accessors functions is still
> problematic
> because there will be performance regression it means that
> from my point of view there still should be any option to "setup"
> proper endians for the driver and it can't be setup at run-time.
> 
> Sure the question is if drivers like this should be in the mainline.
> But if yes, there should be an option to do it in acceptable way.

No. High performance IP should rely on DMA essentially and be less
affected if not at all. Endianess should affect the control path, not
the data path (unless you got your wiring wrong again :-)

If you want an Kconfig option for an "optimal" version, put the ifdef
trickery in the accessors and make them inline.

We do something like that iirc with OHCI where the type of endianness
needed is a pair of select's and the conditional only happens when both
are set. You can probably do better with feature bits & a mask of
"possible" features relying on the compiler optimisations rather than
the preprocessor.

Cheers,
Ben.


