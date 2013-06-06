Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3FFDy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:54:57 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:37854 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3FFDy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:54:56 -0400
Date: Thu, 6 Jun 2013 03:54:55 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
cc: linux-omap@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Broken DM816x support in Linux 3.10-rc4
In-Reply-To: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
Message-ID: <alpine.DEB.2.02.1306060346390.15042@utopia.booyaka.com>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-942192677-1370490748=:15042"
Content-ID: <alpine.DEB.2.02.1306060352520.15042@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-942192677-1370490748=:15042
Content-Type: TEXT/PLAIN; CHARSET=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1306060352521.15042@utopia.booyaka.com>

=DA=C4=D2=C1=D7=D3=D4=D7=D5=CA=D4=C5,

On Wed, 5 Jun 2013, Aida Mynzhasova wrote:

> Not so long ago I tried to boot Linux 3.10-rc4 kernel on DM816x EVM
> board. Unfortunately, my attempts were failed by reason of poor
> support of DM81xx-based devices in new kernels.

Yeah, TI pretty much gave up on trying to get support for that chip=20
upstream a few years ago.  Same for DM814x.

> So, I suggest you this patch series, which fixes that kernel crush and=20
> adds new functions/structures, required for early initialization on=20
> DM816x (power and clock domains, hwmods). After applying these patches=20
> the kernel is able to successfully continue booting till clock=20
> initialization (will be added later).

OK, it will be great to get my DM8168EVM booting on mainline.  But there=20
are a few preliminary issues with the patches:

1. All new chip and board support needs to be DT-only.  So, no new board=20
files.  Also, all the hwmod data shouldn't have IRQ, DMA, etc. data - that=
=20
should come from DT.  See for example the recently posted patch "[PATCH=20
13/14] ARM: AM33XX: hwmod data: irq, dma and addr info clean up"

2. Looks like patch 2 is missing from the list.  If it's too big for the=20
list, please break it down into smaller patches.

3. Did you write this code and data, hwmods, etc., or did it come from a=20
TI kernel?  Please note this clearly in the patch descriptions.


- Paul
--843723315-942192677-1370490748=:15042--
