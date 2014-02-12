Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaBLMGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:06:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21281 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLMGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:06:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-7a-52fb63b38682
Message-id: <1392206769.22265.25.camel@AMDC1943>
Subject: Re: [PATCH 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 12 Feb 2014 13:06:09 +0100
In-reply-to: <20140212100219.GX15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
 <20140212090746.GR15081@lee--X1> <1392197497.22265.8.camel@AMDC1943>
 <20140212100219.GX15081@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7qbk38HGbxcy2SxccZ6VouzTW/Y
	Le5/PcpocXnXHDaLGef3MVmsPXKX3eJ0N6vFxRVfmBw4PO5c28PmMe9koEffllWMHp83yQWw
	RHHZpKTmZJalFunbJXBltP/kKugVrPj3bS9bA+NPni5GTg4JAROJOftPskHYYhIX7q0Hsrk4
	hASWMkrMmtrACOF8ZpTYMH05E0gVr4CBxJZfy9lBbGGBSIkrD4+wgNhsAsYSm5cvAerm4BAR
	UJE498YcpJdZYDGTxJn+w2AbWARUJa5dmQTWyymgK9F2+R4zxIK3QAvWX2cESTALqEtMmreI
	GeIkJYnd7Z3sEHF5ic1r3jJDHCEo8WPyPZYJjAKzkLTMQlI2C0nZAkbmVYyiqaXJBcVJ6bmG
	esWJucWleel6yfm5mxghIf5lB+PiY1aHGAU4GJV4eBk8fwUJsSaWFVfmHmKU4GBWEuENivod
	JMSbklhZlVqUH19UmpNafIiRiYNTqoGxe2shu2TLrktlJ7aZ839UV+cwyvNmujln4/Ms9/m6
	5nerevSONPFbZt2+/IgvJmDxhfNXPKzsQ6ofVOduOJlo9fV82Jq2Lo9F/geO9soEejrOiLn0
	bLXotE6xsIkhr1/P9HE+Yd0rITs/4oby7sSc6Rocq7t8lF7w3yn4Vvqa85vjqz8fDFKUWIoz
	Eg21mIuKEwHduKWXTwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2014-02-12 at 10:02 +0000, Lee Jones wrote:
> On Wed, 12 Feb 2014, Krzysztof Kozlowski wrote:
> 
> > On Wed, 2014-02-12 at 09:07 +0000, Lee Jones wrote:
> > > > The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
> > > > interrupts are named similarly). Use consistent names for interrupts to
> > > > limit possible errors.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > ---
> > > >  drivers/mfd/sec-irq.c           |    8 ++++----
> > > >  include/linux/mfd/samsung/irq.h |    4 ++--
> > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > <snip>
> > > 
> > > >  #define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
> > > >  #define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
> > > > -#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
> > > > +#define S2MPS11_IRQ_RTCA0_MASK		(1 << 2)
> > > 
> > > This doesn't look correct to me.
> > 
> > It is just renaming RTCA2 to RTCA0 because there is no "alarm 2"
> > registers. Actually the behavior of driver does not change (especially
> > that there is no RTC driver for S2MPS11) but now it looks properly:
> >  - set ALARM0 registers for RTCA0 interrupt,
> >  - set ALARM1 registers for RTCA1 interrupt,
> > 
> > This patch is not essential.
> 
> I mean the logic.
> 
> If these masks are used for registers then I assume RTCA0 would be
> BIT(1) amd RTCA1 would be BIT(2), but this patch swaps them round.


Yes, one could assume that and in case of S5M8767 this is right (the
order is proper)... but on S2MPS11/S2MPS14 this is reverted:
 - BIT(0): RTC periodic 60s
 - BIT(1): RTC Alarm 1
 - BIT(2): RTC Alarm 0

The original code (BIT(1) for RTCA1 and BIT(2) for RTCA2) was wrong here
and may lead to errors. I think that this was changed during mainstream
process to match S5M8767. However some old internal driver sources for
S2MPS11 have:
#define S2MPS11_IRQ_RTCA2_MASK          (1 << 1)
#define S2MPS11_IRQ_RTCA1_MASK          (1 << 2)


Best regards,
Krzysztof

> 
> > > >  #define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
> > > >  #define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
> > > >  #define S2MPS11_IRQ_WTSR_MASK		(1 << 5)
> > > 
> > 
> 

