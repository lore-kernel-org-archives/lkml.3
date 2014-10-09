Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaJIHjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:39:49 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:43503 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJIHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:39:41 -0400
From: Prabu Thangamuthu <Prabu.T@synopsys.com>
To: Alim Akhtar <alim.akhtar@gmail.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>
CC: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manjunath M Bettegowda <Manjunath.MB@synopsys.com>
Subject: RE: [PATCH v5] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Topic: [PATCH v5] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Index: Ac/iI9OmsHimH3VBQ3mVRB3ChsbEAAArFdgAAC0mY9A=
Date: Thu, 9 Oct 2014 07:37:40 +0000
Message-ID: <705D14B1C7978B40A723277C067CEDE21B33369C@IN01WEMBXB.internal.synopsys.com>
References: <705D14B1C7978B40A723277C067CEDE21B32D001@IN01WEMBXB.internal.synopsys.com>
 <CAGOxZ52-vKJh=FUGbB7X1MDkvGp3c-T_kgsKHPH80DGciyR=QA@mail.gmail.com>
In-Reply-To: <CAGOxZ52-vKJh=FUGbB7X1MDkvGp3c-T_kgsKHPH80DGciyR=QA@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.112.150]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s997dquB028983

Hi Alim,

Thank you for reviewing and testing our Patch.

On Wed, Oct 8, 2014 at 7:17 PM, Alim Akhtar <alim.akhtar@gmail.com > wrote:
> Hi Prabu,
> 
> On Tue, Oct 7, 2014 at 5:17 PM, Prabu Thangamuthu
> <Prabu.T@synopsys.com> wrote:
> > Synopsys DW_MMC IP core supports Internal DMA Controller with 64-bit
> address mode from IP version 2.70a onwards.
> > Updated the dw_mmc driver to support IDMAC 64-bit addressing mode.
> >
> > Tested the features in DW_MMC core v2.70a and v2.40a with HAPS-51
> setup and driver is working fine.
> >
> > Signed-off-by: Prabu Thangamuthu <prabu.t@synopsys.com>
> > ---
> With a minor nit below, this looks good to me.
> 
> So, Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> Have tested this on exynos7 platform which has dw_mmc controller version
> 2.70a, Have tested this on exynos5800 Pi board and found no issue.
> 
> So, Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> > Change log v5:
> >         - Recreated the patch against linux-next as this patch is
> > required for another patch
> > http://www.spinics.net/lists/arm-kernel/msg357985.html
> >
> yes, we are using this on exynos7 platform. Thanks for re-basing and re-
> posting .
> > +               /* Set the last descriptor as the end-of-ring descriptor */
> > +               p->des3 = host->sg_dma;
> > +               p->des0 = IDMAC_DES0_ER;
> > +       }
> > +
> > +       mci_writel(host, BMOD, SDMMC_IDMAC_SWRESET);
> Any reason to use this instead of earlier use of  dw_mci_idmac_reset(host)?
Thanks for pointing this. It's a typo. I will resend the patch with this modification.

Regards,
Prabu Thangamuthu.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
