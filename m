Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBLJbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:31:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63282 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBLJbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:31:41 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ef-52fb3f7bdac3
Message-id: <1392197497.22265.8.camel@AMDC1943>
Subject: Re: [PATCH 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 12 Feb 2014 10:31:37 +0100
In-reply-to: <20140212090746.GR15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
 <20140212090746.GR15081@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7rV9r+DDN50yVhsnLGe1eJs0xt2
	i/tfjzJaXN41h81ixvl9TBZrj9xltzjdzWpxccUXJgcOjzvX9rB5zDsZ6NG3ZRWjx+dNcgEs
	UVw2Kak5mWWpRfp2CVwZv85OZSw4zVkx/dMLpgbG3exdjJwcEgImEje3r2OEsMUkLtxbz9bF
	yMUhJLCUUeLk2xWMEM5nRolDp2axglTxCuhLNOxpZgKxhQUiJa48PMICYrMJGEtsXr4EqJuD
	Q0RAReLcG3OQXmaBxUwSZ/oPg8VZBFQlfh4wBSnnFNCVWPrsB9SyZYwSzx+cBJvDLKAuMWne
	ImaIi5Qkdrd3skPE5SU2r3nLDHGDoMSPyfdYJjAKzELSMgtJ2SwkZQsYmVcxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihIT4lx2Mi49ZHWIU4GBU4uFl8PwVJMSaWFZcmXuIUYKDWUmEV/8E
	UIg3JbGyKrUoP76oNCe1+BAjEwenVANjdPl7Lx6pedLmHnXWG2b65zQrrj79WXz90lty13lX
	XGTtZPiSdkFygkJA9a1Ey6tsPwN3ZHVozZyS4F4w79E9MdOU5Z9Tj78xvvso1Zyvadtl3xuf
	fFU81Xp3Sbi4/mJ+nz15Dg9bk4iW6bZaqam762UKzQq8i5PPqO6RidA2ebt65au8RcJKLMUZ
	iYZazEXFiQDhkL/gTwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 09:07 +0000, Lee Jones wrote:
> > The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
> > interrupts are named similarly). Use consistent names for interrupts to
> > limit possible errors.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-irq.c           |    8 ++++----
> >  include/linux/mfd/samsung/irq.h |    4 ++--
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> <snip>
> 
> >  #define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
> >  #define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
> > -#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
> > +#define S2MPS11_IRQ_RTCA0_MASK		(1 << 2)
> 
> This doesn't look correct to me.

It is just renaming RTCA2 to RTCA0 because there is no "alarm 2"
registers. Actually the behavior of driver does not change (especially
that there is no RTC driver for S2MPS11) but now it looks properly:
 - set ALARM0 registers for RTCA0 interrupt,
 - set ALARM1 registers for RTCA1 interrupt,

This patch is not essential.

Best regards,
Krzysztof

> 
> >  #define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
> >  #define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
> >  #define S2MPS11_IRQ_WTSR_MASK		(1 << 5)
> 

