Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaDXG5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:57:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23510 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDXG5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:57:34 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-61-5358b5dcc18d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
 <001a01cf5f54$af090810$0d1b1830$%han@samsung.com>
 <000001cf5f5c$2f6c2440$8e446cc0$%han@samsung.com>
 <CAFp+6iGo-Rk8d28=dosVW63f-ZrZjmxj9fsm7D7Vn4-HdhSgjw@mail.gmail.com>
In-reply-to: <CAFp+6iGo-Rk8d28=dosVW63f-ZrZjmxj9fsm7D7Vn4-HdhSgjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Thu, 24 Apr 2014 15:57:31 +0900
Message-id: <000201cf5f8a$76c7b9c0$64572d40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9fiCgZuhOOCebvQ/WkXRO9iQxqUQAASVKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ907WyOCDbY847BYsvsGq8XB+/UW
	bVcOsls0L17PZnF54SVWi94FV9ksNj2+xmpxedccNovZS/pZLGac38dksWhZK7PFhN8X2Bx4
	PPbPXcPusXlJvcfsuz8YPfq2rGL0OH5jO5PH501yAWxRXDYpqTmZZalF+nYJXBmbTq5lL3gr
	W3Ho70nGBsYXYl2MnBwSAiYSW6fsZYSwxSQu3FvP1sXIxSEksIxR4uPzS+wwRQvm3WWHSCxi
	lLgw/QaU85tR4uzS/2wgVWwCahJfvhwG6xAR0JXomfiRBaSIWWATs8SnJzDtG5kkHp59BdTB
	wcEpECyxYV8ZSIOwgI/EhPs3wO5gEVCV+PCnAWwor4CtxJ2HC1ggbEGJH5PvgdnMAuoSk+Yt
	Yoaw5SU2r3nLDDJSAij+6K8uxA1GEi/mvWCDKBGR2PfiHSPICRICUzkk9rQfYYbYJSDxbfIh
	FoheWYlNB5ghPpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IRK84Mbe4
	NC9dLzk/dxMjJPIn7GC8d8D6EGMy0PqJzFKiyfnAxJFXEm9obGZkYWpiamxkbmlGmrCSOK/a
	o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxZof8k4oyKPi+prS50jfq03P9W8ztFGZkf
	lc2LtoeIPV+dOWHiUoHW4qMZB0/tfr7JYOn9X5z/ZrKuUQrcn3RgqZXv52MHX57bmZx56s0J
	K8F9F1Munzd20byla/3pUgBfriS71NvFkeZOWx9tLJ/J9enzA5nQ3Nz22B7bWOtr3xYolac+
	sedUYinOSDTUYi4qTgQAnpNDwBIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAd07WyOCDT4uZbZYsvsGq8XB+/UW
	bVcOsls0L17PZnF54SVWi94FV9ksNj2+xmpxedccNovZS/pZLGac38dksWhZK7PFhN8X2Bx4
	PPbPXcPusXlJvcfsuz8YPfq2rGL0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJ6xgzNp1cy17wVrbi0N+TjA2ML8S6GDk5JARMJBbMu8sOYYtJXLi3nq2L
	kYtDSGARo8SF6TfYIZzfjBJnl/5nA6liE1CT+PLlMFiHiICuRM/EjywgRcwCm5glPj25C9Wx
	kUni4dlXQB0cHJwCwRIb9pWBNAgL+EhMuH+DEcRmEVCV+PCnAWwor4CtxJ2HC1ggbEGJH5Pv
	gdnMAuoSk+YtYoaw5SU2r3nLDDJSAij+6K8uxA1GEi/mvWCDKBGR2PfiHeMERqFZSCbNQjJp
	FpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnFaeSe9gXNVgcYhRgINRiYdX
	4VZ4sBBrYllxZe4hRgkOZiUR3jVzI4KFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+Y8vJK
	4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVEu5KjY0asv5W97
	f3hX7hw29YPOXLN6iwV151dtKpsy+0Lejitm/nEzA/sma92Tt6jMsUzSKWDiqb0kuXmrn7Fq
	TbRk3arVSZcFBL6ETe24UpNuzb+yd97EpU+id0ZqRUusOuOpr+Oy4uqGhklyH5qent7gKsW4
	+jl/UWvAqkmHo0SrI1tbfZVYijMSDbWYi4oTAfcty2tvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 3:40 PM, Vivek Gautam wrote:
> On Thu, Apr 24, 2014 at 6:56 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Thursday, April 24, 2014 9:33 AM, Jingoo Han wrote:
> >> On Thursday, April 24, 2014 9:18 AM, Anton Tikhomirov wrote:
> >> > On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> >> > >
> >> > > Facilitate getting required 3.3V and 1.0V VDD supply for
> >> > > OHCI controller on Exynos.
> >> > >
> >> > > With patches for regulators' nodes merged in 3.15:
> >> > > c8c253f ARM: dts: Add regulator entries to smdk5420
> >> > > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> >> > >
> >> > > certain perripherals will now need to ensure that,
> >> > > they request VDD regulators in their drivers, and enable
> >> > > them so as to make them working.
> >> > >
> >> > > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> > > Cc: Jingoo Han <jg1.han@samsung.com>
> >> > > ---
> >> > >
> >> > > Based on 'usb-next' branch of Greg's usb tree.
> >> > >
> >> > >  drivers/usb/host/ohci-exynos.c |   47
> >> > > ++++++++++++++++++++++++++++++++++++++++
> >> > >  1 file changed, 47 insertions(+)
> >> > >
> >> > > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-
> >> > > exynos.c
> >> > > index 68588d8..e2e72a8 100644
> >> > > --- a/drivers/usb/host/ohci-exynos.c
> >> > > +++ b/drivers/usb/host/ohci-exynos.c
> 
> [snip]
> 
> >> > > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device
> >> > > *pdev)
> >> > >           exynos_ohci->otg = phy->otg;
> >> > >   }
> >> > >
> >> > > + exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> >> > > + if (IS_ERR(exynos_ohci->vdd33)) {
> >> > > +         err = PTR_ERR(exynos_ohci->vdd33);
> >> > > +         goto fail_regulator1;
> >> > > + }
> >> > > + err = regulator_enable(exynos_ohci->vdd33);
> >> > > + if (err) {
> >> > > +         dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
> >> > > +         goto fail_regulator1;
> >> > > + }
> >> > > +
> >> > > + exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
> >> > > + if (IS_ERR(exynos_ohci->vdd10)) {
> >> > > +         err = PTR_ERR(exynos_ohci->vdd10);
> >> > > +         goto fail_regulator2;
> >> > > + }
> >> > > + err = regulator_enable(exynos_ohci->vdd10);
> >> > > + if (err) {
> >> > > +         dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
> >> > > +         goto fail_regulator2;
> >> > > + }
> >> > > +
> >> >
> >> > Do we need to skip regulator settings together with PHY configuration
> >> > in case of exynos5440?
> >>
> >> Oh, right. In the case of exynos5440, regulator settings is not
> >> necessary. Vivek, would you fix it in order skip regulator settings
> >> in exynos5440? It also applies to ehci-exynos.
> >
> > Sorry, in the case of exynos5440, this patch already skips
> > regulator settings.
> >
> > In the case of exynos5440, there is no need to set PHY setting
> > and regulator setting.
> 
> Right, in case of exynos5440, we are skipping PHY setting and regulator setting.
> Actually i had missed taking into account 5440, so just curious. Do we
> really not need a regulator
> settings for Exynos5440 ?

To be more specific, there is no regulator on ssdk5440 board
which is the Exynos5440-based board.

Best regards,
Jingoo Han

> > How about making regulator setting "optional"?
> > Then, regulator setting can be done, only when regulator
> > is supported.
> 
> True, so with Exynos5440 not needing the regulator, we should make the
> regulator settings optional.

[.....]

> Thanks for the suggestion.
> I will make the required changes, and post the patchset again.

OK, I see.
Thank you for accepting my suggestion.

Best regards,
Jingoo Han

