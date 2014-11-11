Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaKKLbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:31:03 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:46570 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaKKLbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:31:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4] mmc: add Toshiba PCI SD controller driver
Date: Tue, 11 Nov 2014 12:30:30 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: "linux-mmc" <linux-mmc@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <1415638712-18486-1-git-send-email-linux@rainbow-software.org> <CAPDyKFpUS6yG1Fq+dVFn_8AG7-_B-_moo2JCz4AQBKgvp-YaHQ@mail.gmail.com>
In-Reply-To: <CAPDyKFpUS6yG1Fq+dVFn_8AG7-_B-_moo2JCz4AQBKgvp-YaHQ@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201411111230.30686.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 November 2014, Ulf Hansson wrote:
> On 10 November 2014 17:58, Ondrej Zary <linux@rainbow-software.org> wrote:
> > This patch resurrects an old never-finished driver for Toshiba PCI SD
> > controllers found in some older Toshiba laptops (such as Portege R100):
> >
> > 02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA
> > Controller [1179:0805] (rev 05)
> >
> > The code is fixed, cleaned up and successfully tested with SD, SDHC, SDXC
> > and MMC cards on Portege R100. (MMC cards don't even work in Windows!)
> > SDIO probably does not work (don't have any SDIO card).
> >
> > The hardware is slow (around 2 MB/s - same in Windows) because it does
> > not support bus mastering (busmaster enable bit cannot be set in PCI
> > control reg). Also the card clock is limited to 16MHz (33MHz PCI clock
> > divided by 2).
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> Hi Ondrej,
>
> I get these compiler warning while building for x86. Can you please fix
> them.
>
> ../drivers/mmc/host/toshsd.c: In function ‘toshsd_init’:
> ../drivers/mmc/host/toshsd.c:70:9: warning: large integer implicitly
> truncated to unsigned type [-Woverflow]
>          host->ioaddr + SD_INTMASKCARD);
>          ^

Which GCC version did you use? I get no warnings with 4.7.2 (Debian Stable).

-- 
Ondrej Zary
