Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaIBJvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:51:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11717 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaIBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:51:41 -0400
X-AuditID: cbfee61b-f79f86d00000144c-57-5405932a879a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Rob Herring <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: calxedaxgmac: fix driver dependencies
Date: Tue, 02 Sep 2014 11:51:34 +0200
Message-id: <10071967.pgEgsHtCJd@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAL_JsqJV0rJ_PCLBsZNYdYdbER7UR_MV40BGjpykh7uubLh__g@mail.gmail.com>
References: <7268934.nBXHizFkl4@amdc1032>
 <CAL_JsqJV0rJ_PCLBsZNYdYdbER7UR_MV40BGjpykh7uubLh__g@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV2tyawhBtOn6lnMOd/CYnG26Q27
	xeVdc9gsji0Qs/i/Zwe7A6vHlpU3mTw2repk8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	u/O/MBf85q2Yd/k0UwPjeu4uRg4OCQETiW8L5LoYOYFMMYkL99azdTFycQgJLGKUuPqoBcpp
	YZJ4uH01K0gVm4CVxMT2VYwgtoiAosTvtmmsIEXMArsYJZZ1XGIBSQgL2Et0zN0JVsQioCrR
	se0PG4jNK6AlsX3FSXYQW1TAU2LH9pVgcU6BYIn5L/uZQGwhgQKJ/ftvsULUC0r8mHwPbCaz
	gLzEvv1TWSFsdYlJ8xYxT2AUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECA7jZ9I7GFc1WBxiFOBgVOLhlfjBEiLEmlhWXJl7iFGCg1lJhFewgzVEiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA6P68/+t/wS1HS8mzZG7lBmz
	7nLMi/49M4MiTrOa8uR7ruktfBu5dILBo3MhLZNnHhUqW8B5o/3k7SRb2R1TdbxSVE6WnmjZ
	FpE+41glW8TR063iDhkfqlbn90XfsDJjuSen6Kmdo2uwQG6JssEHMebnxpdZz8xS6xc4dPfy
	Xzuf3dWTlFPmNyixFGckGmoxFxUnAgC5jclmXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, September 01, 2014 09:36:39 PM Rob Herring wrote:
> On Mon, Sep 1, 2014 at 10:39 AM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Calxeda 1G/10G XGMAC Ethernet support should be available only on
> > Calxeda ECX-1000/2000 (Highbank/Midway) platforms.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Rob Herring <robh@kernel.org>
> > ---
> >  drivers/net/ethernet/calxeda/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > Index: b/drivers/net/ethernet/calxeda/Kconfig
> > ===================================================================
> > --- a/drivers/net/ethernet/calxeda/Kconfig      2014-07-30 14:31:12.159522474 +0200
> > +++ b/drivers/net/ethernet/calxeda/Kconfig      2014-09-01 17:33:49.232810483 +0200
> > @@ -1,6 +1,7 @@
> >  config NET_CALXEDA_XGMAC
> >         tristate "Calxeda 1G/10G XGMAC Ethernet driver"
> >         depends on HAS_IOMEM && HAS_DMA
> > +       depends on ARCH_HIGHBANK || COMPILE_TEST
> 
> Opinions differ on whether drivers should be restricted in this way.
> There is no actual dependency requiring ARCH_HIGHBANK. So I leave it
> to David.

The hardware is specific to ARCH_HIGHBANK and it is just unavailble on
any other platform (i.e. I have completely no use for this option on
ARM Exynos platform).  In such cases we restrict drivers to the specific
hardware platform so they don't pollute configs for other platforms
(i.e. this option is enabled by default in multi_v7_defconfig and once
I go from multi defconfing to single platform one, the option stays
enabled).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

