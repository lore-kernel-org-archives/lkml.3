Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbaCTPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:07:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20227 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaCTPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:07:23 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ae-532b042abeb6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
Date: Thu, 20 Mar 2014 16:07:04 +0100
Message-id: <348852006.YgTlFegqas@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2662651.GJX9HVKij5@amdc1032>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
 <532AA2B0.1060103@ti.com> <2662651.GJX9HVKij5@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jAV0tFu1gg5ZbHBbnbjWwWtxZwWyx
	6fE1VotjOx4xWVzeNYfNYn/vBiaLhu4edos5MzazWvxafpTRYuXFv8wOXB7XX/1n8tg56y67
	x6ZVnWwec6Y1sXicvHCSxWPzknqPpz/2Mnscv7GdyePzJrkAzigum5TUnMyy1CJ9uwSujAcz
	LjAWHGer+L+KtYGxn7WLkZNDQsBEovPqLTYIW0ziwr31YLaQwCJGiblvnLoYuYDsFiaJPQsu
	MYMk2ASsJCa2r2IEsUUEFCRWXdnLClLELHCMSeLnz+lMIAlhgRSJGQ9msoDYLAKqEt9bethB
	bF4BbYndE16DbRAV8JTYsX0lkM3BwSmgJXFhoTvEsiZGieb+3cwQ9YISPybfA5vDLCAvsW//
	VFYIW0dif+s0tgmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFx
	8kx6B+OqBotDjAIcjEo8vCv2aAYLsSaWFVfmHmKU4GBWEuGtYNYOFuJNSaysSi3Kjy8qzUkt
	PsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDYdkutkDenPe3qj2uZm9N/nOjs3fS9
	21Hw9/WMQxO3rr/hNsuqXaItvMBY8XRr8K8vV42frhYuzQxNLXpSqcBiJLjlkZic+fHGbcFc
	DwWumyglvvB/dMeRaZGXST6raa2N1Pw5c16+P1QZ5/J0ub/hlA03d1dta5k422XKlFVnMq5Y
	vdUSMl+oxFKckWioxVxUnAgApPV+B48CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 20, 2014 01:57:10 PM Bartlomiej Zolnierkiewicz wrote:

> > > +#define DA8XX_SYSCFG1_VIRT(x)	(da8xx_syscfg1_base + (x))
> > > +#define DA8XX_PWRDN_REG		0x18
> > > +
> > > +/* SATA PHY Control Register offset from AHCI base */
> > > +#define SATA_P0PHYCR_REG	0x178
> > > +
> > > +#define SATA_PHY_MPY(x)		((x) << 0)
> > > +#define SATA_PHY_LOS(x)		((x) << 6)
> > > +#define SATA_PHY_RXCDR(x)	((x) << 10)
> > > +#define SATA_PHY_RXEQ(x)	((x) << 13)
> > > +#define SATA_PHY_TXSWING(x)	((x) << 19)
> > > +#define SATA_PHY_ENPLL(x)	((x) << 31)
> > 
> > These can be replaced with BIT(N)
> 
> OK, I'll fix it.

Uh, no, we can't use BIT() here.

BIT(N) does (1UL << (N)) and here we have ((N) << offset).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

