Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3GOMJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:09:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20255 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3GOMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:09:43 -0400
X-AuditID: cbfee691-b7fef6d000002d62-02-51e3e6853cdb
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-4-git-send-email-dianders@chromium.org>
 <002a01ce7d7d$6bd9e870$438db950$%jun@samsung.com>
 <CAD=FV=UtX0Z1ABdi5h270ks8Py2o1iPK4DonOHJH3N0Q1YShTQ@mail.gmail.com>
In-reply-to: <CAD=FV=UtX0Z1ABdi5h270ks8Py2o1iPK4DonOHJH3N0Q1YShTQ@mail.gmail.com>
Subject: RE: [PATCH v2 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
Date: Mon, 15 Jul 2013 21:09:40 +0900
Message-id: <003f01ce8154$2f5ea1d0$8e1be570$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac59ft5YgylTFv29RESKj3xBbjzWoADoyOzA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zI93WZ48DDdYskLZ4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi94FV9ksNj2+xmpxedccNosj//sZLWac38dk
	cer6ZzaLVbv+MDrwecxuuMjisXPWXXaPnp1nGD0OXVnL6LF5Sb3HlRNNrB59W1YxenzeJBfA
	EcVlk5Kak1mWWqRvl8CV8enWfbaCWbIVUx98ZWpgPCLWxcjJISFgIvHp/HtWCFtM4sK99Wxd
	jFwcQgLLGCXO9x9nhinafnEWWJGQwHRGiZmXzCCK/jBKzH1/nR0kwSagJfH3zRuwBhEBbYmX
	D1YygxQxC/SwSHz89JYRomM7k8S61iVMIFWcAsES14/NAbOFBeIlfu+7AzaJRUBV4v7LBjYQ
	m1fAVmJRzwxWCFtQ4sfkeywgNrOAnsTHP7cZIWx5ic1r3gJt4wA6VV3i0V9diCOMJN5/uAJV
	IiKx78U7sBskBHZwSDxZ9IQJYpeAxLfJh1ggemUlNh2A+lhS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkBQxcQfj/QPWhxiTgdZPZJYSTc4H
	ppi8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCK
	fPxxg0fX6M6kV6880x4bCVaf0GVJzKmxWh1yUSNhrsvOWbwrpXWC/G0cZnHNF2wU3PjriZL4
	zZo70zqrBTX8klTrF4VwcCrt/BeyWi1wZcnWqR+3qN/hX6xkbC968Ee3b2HPReajF97nm2zM
	XvJg/QrN7Acx94sj5m+9t4BLj9Vi93pp4dNKLMUZiYZazEXFiQDtcy5OJwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t9jQd3WZ48DDaZ1ilo8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurRe+Cq2wWmx5fY7W4vGsOm8WR//2MFjPO72Oy
	OHX9M5vFql1/GB34PGY3XGTx2DnrLrtHz84zjB6Hrqxl9Ni8pN7jyokmVo++LasYPT5vkgvg
	iGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlxJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHp1n22glmyFVMffGVqYDwi
	1sXIySEhYCKx/eIsVghbTOLCvfVsILaQwHRGiZmXzLoYuYDsP4wSc99fZwdJsAloSfx984YZ
	xBYR0JZ4+WAlM0gRs0APi8THT28ZITq2M0msa13CBFLFKRAscf3YHDBbWCBe4ve+O2CTWARU
	Je6/bABbxytgK7GoZwYrhC0o8WPyPRYQm1lAT+Ljn9uMELa8xOY1b4G2cQCdqi7x6K8uxBFG
	Eu8/XIEqEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iRGcgJ5J7WBc2WBxiFGAg1GJh/eAxuNAIdbEsuLK3EOMEhzMSiK8Sy8ChXhTEiurUovy
	44tKc1KLDzEmAz06kVlKNDkfmBzzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2a
	WpBaBLOFiYNTqoGx58m/uXveyXCHeMe58qgbHhPRsxTa7vpq8cmC97efuKdcuOpnu1pQU179
	f3/vtfexpTWiLI+Nsv/dFFl/4Ocv7uLzD41qftz7eVFU5XOoemzOQT/zWZv3Wv9cO0HUJXZh
	kli+QX3llv/70mNvcuZPtRPu35v85cecF8z8/1e8nml67ltLR1KKEktxRqKhFnNRcSIA8mUZ
	7YQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, July 11, 2013, Doug Anderson wrote:
> Seungwon,
> 
> On Wed, Jul 10, 2013 at 7:54 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > On Wed, July 10, 2013, Doug Anderson wrote:
> >> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
> >> looping around forever.  This has been seen to happen on exynos5420
> >> silicon despite the fact that we haven't enabled any wakeup events.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >> Changes in v2:
> >> - Use suspend_noirq as per James Hogan.
> >>
> >>  drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
> >>  1 file changed, 23 insertions(+)
> >>
> >> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> >> index f013e7e..36b9620 100644
> >> --- a/drivers/mmc/host/dw_mmc-exynos.c
> >> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> >> @@ -30,6 +30,7 @@
> >>  #define SDMMC_CLKSEL_TIMING(x, y, z) (SDMMC_CLKSEL_CCLK_SAMPLE(x) |  \
> >>                                       SDMMC_CLKSEL_CCLK_DRIVE(y) |    \
> >>                                       SDMMC_CLKSEL_CCLK_DIVIDER(z))
> >> +#define SDMMC_CLKSEL_WAKEUP_INT              BIT(11)
> >>
> >>  #define SDMMC_CMD_USE_HOLD_REG               BIT(29)
> >>
> >> @@ -102,6 +103,27 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
> >>       return 0;
> >>  }
> >>
> >> +/**
> >> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
> >> + *
> >> + * We have seen cases (at least on the exynos5420) where turning off the INT
> >> + * power rail during suspend will leave the WAKEUP_INT bit in the CLKSEL
> >> + * register asserted.  This bit is 1 to indicate that it fired and we can
> >> + * clear it by writing a 1 back.  Clear it to prevent interrupts from going off
> >> + * constantly.
> >> + */
> > As I know this bit is auto-cleared.
> > Did you find the cause of this problem?
> > How about your GPIO setting in sleep?
> > Currently, we don't know why the problem is happened.
> > At least, we should make it clear.
> 
> Yes, the documentation that I have says that this bit is "auto
> cleared" as well but doesn't indicate under what conditions it is auto
> cleared.  From testing how this bit reacts I have found that writing a
> 1 to it clears the bit--in other words it behaves like bits in
> RINTSTS.  That's a terrible design for a bit in a register with shared
> config but appears to be how it works.
> 
> Note: in a sense it will be "auto cleared" because doing a
> read-modify-write of any other bits in this register will clear the
> interrupt.
> 
> I have asked for official confirmation.
> 
> We have found that on exynos5420 bits 8-10 of CLKSEL are marked as
> RESERVED.  Those bits are documented to enable the WAKEUP_INT on
> exynos5250.  My best guess is that these bits are not used on
> exynos5420 and the WAKEUP_INT line is left floating, which means it
> can fire randomly.  I have also asked for official confirmation about
> this.
Sorry for late response.
Yes, it's not clear.
If you get the confirmation, could you share this problem?
Possibly, auto-clear may not be implemented.
Then, manual should be correct.

Thanks,
Seungwon Jeon
> 
> 
> I will likely merge this change locally in our kernel tree while
> waiting for a response.  If you would like to wait before Acking
> that's very reasonable.  Do you have any other problems with this
> change assuming my understanding above is correct?
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

