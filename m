Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbaEFN7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:59:09 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49982 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbaEFN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:59:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, Bjorn Helgaas <bhelgaas@google.com>,
        Marek Vasut <marex@denx.de>, santosh.shilimkar@ti.com
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Tue, 06 May 2014 15:59 +0200
Message-ID: <4764413.ZAEU5S5p0p@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399383244-14556-7-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gphsvx8dMcd7jA6duQgC8Pf/yrvGof4abbINljBFhi0
 TZXgJPOrXS/Fbf6bWd7+Hfd0QU8zdf0y7IEbaQ3B5uS0kiBAyb
 VMU0FBYCWwy71xk/iQPlm5zTw+ScE6tJIF6MH/pK05G+J+YMZm
 puhc945dxMcdS6zkKZslGzZvksiebI74zKQQ04vGhZkPrcdAiL
 h14JHZgYJewkDvtdZPzPERz8XmxjksttdQfrLk5qTuR3wplWUl
 Tfmm/sycUREGVLyTnL1XPTceUEsdR3JCvkrpHbIf+YydxfA/+0
 v0ajPortOaesm9KiqH2qSjCsTHbTzHN6G9FopVGjRhZxBgkuzQ
 dkkn8KOfOvbzEWZneaa8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 19:03:52 Kishon Vijay Abraham I wrote:
> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> address. So whenever the cpu issues a read/write request, the 4 most
> significant bits are used by L3 to determine the target controller.
> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> the outbound translation window the *base* should be programmed as 0x000_0000.
> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> we have programmed in the translation window with base as 0x000_0000.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Marek Vasut <marex@denx.de>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Mohit Kumar <mohit.kumar@st.com>

Sorry, but NAK.

We have a standard 'dma-ranges' property to handle this, so use it.

See the x-gene PCIe driver patches for an example. Please also talk
to Santosh about it, as he is implementing generic support for
parsing dma-ranges in platform devices at the moment.

I also suspect you will have to implement swiotlb support to make
generic PCI devices work behind this bridge. Otherwise you end up
with random physical addresses passed into DMA registers.

	Arnd

