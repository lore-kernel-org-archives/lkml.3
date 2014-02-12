Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaBLKDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:03:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19780 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:03:41 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c5-52fb46fb3c58
Message-id: <1392199417.22265.12.camel@AMDC1943>
Subject: Re: [PATCH 08/14] mfd: sec: Add support for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 12 Feb 2014 11:03:37 +0100
In-reply-to: <20140212091724.GS15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-9-git-send-email-k.kozlowski@samsung.com>
 <20140212091724.GS15081@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7q/3X4HGUy4x2SxccZ6VouzTW/Y
	Le5/PcpocXnXHDaLGef3MVmsPXKX3eJ0N6vFxRVfmBw4PO5c28PmMe9koEffllWMHp83yQWw
	RHHZpKTmZJalFunbJXBlzN/RxVzQz1exePpM5gbGVu4uRk4OCQETicbbv5ggbDGJC/fWs3Ux
	cnEICSxllPiz8TcLhPOZUaJ7WxszSBWvgIHEzXVTWUFsYQEbiXVtW9lAbDYBY4nNy5cA2Rwc
	IgIqEufemIP0MgssZpI4038YrIZFQFXiw6LzjCA2p4CuxJG2qcwQC5YxSrQ9uwI2lFlAXWLS
	vEXMECcpSexu72SHiMtLbF7zFuoIQYkfk++xTGAUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECAnyLzsYFx+zOsQowMGoxMPL4PkrSIg1say4MvcQowQHs5II712X
	30FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGPNCbx6ce/U/w9sVV9oTFmwq07rze+UZdgn/5ata
	zI5IOs4qa1Q0Z/t0ctl3+YnMBertoY9WG4bI26xetu16aQJn461PftZlTfd/XZ8v/XGv7yzJ
	/i1m3Iu/Lfl4e5n2l+wYtaXpzIEi/wKq+L83T86yPLEgLnSx35aL+xujZu5it/KVT9cTeqfE
	UpyRaKjFXFScCADqapW7UAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 09:17 +0000, Lee Jones wrote:
> > Add support for S2MPS14 PMIC device to the MFD sec-core driver.
> > The S2MPS14 is similar to S2MPS11 but it has fewer regulators, two
> > clocks instead of three and a little different registers layout.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c              |   48 +++++++++--
> >  drivers/mfd/sec-irq.c               |   89 +++++++++++++++++++-
> >  include/linux/mfd/samsung/core.h    |    1 +
> >  include/linux/mfd/samsung/irq.h     |   27 +++++++
> >  include/linux/mfd/samsung/rtc.h     |   56 +++++++++++--
> >  include/linux/mfd/samsung/s2mps14.h |  152 +++++++++++++++++++++++++++++++++++
> >  6 files changed, 361 insertions(+), 12 deletions(-)
> >  create mode 100644 include/linux/mfd/samsung/s2mps14.h
> > 
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> 
> <snip>
> 
> > +static const struct mfd_cell s2mps14_devs[] = {
> > +	{
> > +		.name = "s2mps14-pmic",
> > +	}, {
> > +		.name = "s2mps14-rtc",
> > +	}, {
> > +		.name = "s2mps14-clk",
> > +	}
> > +};
> 
> No device tree support for the children?

There aren't any compatibles also for other devices (s2mps11, s5m876X)
so I didn't want to introduce different behavior for S2MPS14. If you
want of_compatible here then it should be added for all devices.

> 
> <Snip>
> 
> > +#define S2MPS14_LDO_VSEL_MASK	0x3F
> > +#define S2MPS14_BUCK_VSEL_MASK	0xFF
> > +#define S2MPS14_ENABLE_MASK	(0x03 << S2MPS14_ENABLE_SHIFT)
> > +#define S2MPS14_ENABLE_SHIFT	6
> > +#define S2MPS14_LDO_N_VOLTAGES	(S2MPS14_LDO_VSEL_MASK + 1)
> > +#define S2MPS14_BUCK_N_VOLTAGES (S2MPS14_BUCK_VSEL_MASK + 1)
> 
> Nit: Can you line these up using tabs please?
> 

Sure.



