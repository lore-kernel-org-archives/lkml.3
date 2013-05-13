Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3EMTpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:45:17 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47647 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3EMTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:45:14 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH] usb: phy: samsung: adding usbphy for Exynos4X12
Date: Mon, 13 May 2013 21:45:04 +0200
Message-ID: <1748996.XYuP0diKxY@flatron>
User-Agent: KMail/4.10.3 (Linux/3.9.1-gentoo-r1; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAFp+6iEztRFVA9H8KCjp+ePmRyYJ3yt9q=7r8z3-tpjf_subbQ@mail.gmail.com>
References: <1368469557-8625-1-git-send-email-tobetter@gmail.com> <CAFp+6iEztRFVA9H8KCjp+ePmRyYJ3yt9q=7r8z3-tpjf_subbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Tuesday 14 of May 2013 01:10:32 Vivek Gautam wrote:
> Hi Dongjin,
> 
> On Mon, May 13, 2013 at 11:55 PM, Dongjin Kim <tobetter@gmail.com> 
wrote:
> > This patch adds usb host phy (USB 2.0 PHY) support for Samsung
> > Exynos4X12 SoC. New functions,
> > samsung_exynos4x12_usb2phy_enable/_disable and selecting reference
> > clock, for Exynos4X12 are added. Since it has different register set
> > up with Exynos4210 or Exynos5250, "samsung,exynos4x12-usb2phy" is
> > added.
> A patch-set for 4x12 from Tomasz too.
> [PATCH 0/6] Samsung USB PHY SoC support cleanup
> @ http://www.mail-archive.com/linux-usb@vger.kernel.org/msg18177.html
> 
> 
> Hi Tomasz,
> 
> Planning to re-spin that series ?

Hmm, I thought it has been merged, but it seems like somehow it hasn't. I 
wonder why...

Well, I'll rebase and send the series again then. Thanks for notification.

Best regards,
Tomasz

> 
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> > ---
> > 
> >  .../devicetree/bindings/usb/samsung-usbphy.txt     |    5 ++
> >  drivers/usb/phy/phy-samsung-usb.c                  |   30 ++++++-
> >  drivers/usb/phy/phy-samsung-usb.h                  |   18 ++++
> >  drivers/usb/phy/phy-samsung-usb2.c                 |   90
> >  ++++++++++++++++++++ 4 files changed, 140 insertions(+), 3
> >  deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> > b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt index
> > 33fd354..f805878 100644
> > --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> > +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> > 
> > @@ -18,6 +18,11 @@ Exynos4210:
> >  - clock-names: names of clock correseponding IDs clock property as
> >  requested>  
> >                by the controller driver.
> > 
> > +Exynos4x12:
> > +- compatible : should be "samsung,exynos4x12-usb2phy"
> > +- reg : base physical address of the phy registers and length of
> > memory mapped +       region.
> > +
> > 
> >  Exynos5250:
> >  - compatible : should be "samsung,exynos5250-usb2phy"
> >  - reg : base physical address of the phy registers and length of
> >  memory mapped> 
> > diff --git a/drivers/usb/phy/phy-samsung-usb.c
> > b/drivers/usb/phy/phy-samsung-usb.c index 7b118ee5..efb26de 100644
> > --- a/drivers/usb/phy/phy-samsung-usb.c
> > +++ b/drivers/usb/phy/phy-samsung-usb.c
> > @@ -91,10 +91,11 @@ void samsung_usbphy_set_isolation(struct
> > samsung_usbphy *sphy, bool on)> 
> >                  */
> >                 
> >                 break;
> >         
> >         case TYPE_EXYNOS4210:
> > +       case TYPE_EXYNOS4X12:
> >                 /*
> > 
> > -                * Fall through since exynos4210 and exynos5250 have
> > similar -                * register architecture: two separate
> > registers for host and -                * device phy control with
> > enable bit at position 0. +                * Fall through since
> > exynos4210/4x12 and exynos5250 have +                * similar
> > register architecture: two separateregistersfor +                *
> > host and device phy control with enable bit at position 0.> 
> >                  */
> >         
> >         case TYPE_EXYNOS5250:
> >                 if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
> > 
> > @@ -210,6 +211,29 @@ int samsung_usbphy_get_refclk_freq(struct
> > samsung_usbphy *sphy)> 
> >                         refclk_freq = FSEL_CLKSEL_24M;
> >                         break;
> >                 
> >                 }
> > 
> > +       } else if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
> > +               switch (clk_get_rate(ref_clk)) {
> > +               case 9600 * KHZ:
> > +                       refclk_freq = FSEL_CLKSEL_9600K;
> > +                       break;
> > +               case 10 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_10M;
> > +                       break;
> > +               case 12 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_12M;
> > +                       break;
> > +               case 19200 * KHZ:
> > +                       refclk_freq = FSEL_CLKSEL_19200K;
> > +                       break;
> > +               case 20 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_20M;
> > +                       break;
> > +               case 24 * MHZ:
> > +               default:
> > +                       /* default reference clock */
> > +                       refclk_freq = FSEL_CLKSEL_24M;
> > +                       break;
> > +               }
> > 
> >         } else {
> >         
> >                 switch (clk_get_rate(ref_clk)) {
> > 
> >                 case 12 * MHZ:
> > diff --git a/drivers/usb/phy/phy-samsung-usb.h
> > b/drivers/usb/phy/phy-samsung-usb.h index 70a9cae..ad86bce 100644
> > --- a/drivers/usb/phy/phy-samsung-usb.h
> > +++ b/drivers/usb/phy/phy-samsung-usb.h
> > @@ -47,6 +47,23 @@
> > 
> >  #define RSTCON_HLINK_SWRST                     (0x1 << 1)
> >  #define RSTCON_SWRST                           (0x1 << 0)
> > 
> > +/* For Exynos4x12 */
> > +#define PHYCLK_COMMON_ON_N_PHY0                        (0x1 << 4)
> > +#define PHYCLK_COMMON_ON_N_PHY1                        (0x1 << 7)
> > +
> > +#define PHYPWR_NORMAL_MASK_HSIC1               (0x7 << 12)
> > +#define PHYPWR_NORMAL_MASK_HSIC0               (0x7 << 9)
> > +#define PHYPWR_NORMAL_MASK_PHY1                        (0x7 << 6)
> > +
> > +#define PHYPWR_ANALOG_POWERDOWN_PHY1           (0x1 << 7)
> > +
> > +#define RSTCON_HLINK_SWRST_MASK                        (0xf << 7)
> > +#define RSTCON_PHY1_SWRST_MASK                 (0xf << 3)
> > +#define RSTCON_PHY0_SWRST_MASK                 (0x7 << 0)
> > +
> > +#define EXYNOS4X12_PHY_HSIC_CTRL0              (0x04)
> > +#define EXYNOS4X12_PHY_HSIC_CTRL1              (0x08)
> > +
> > 
> >  /* EXYNOS5 */
> >  #define EXYNOS5_PHY_HOST_CTRL0                 (0x00)
> > 
> > @@ -241,6 +258,7 @@
> > 
> >  enum samsung_cpu_type {
> >  
> >         TYPE_S3C64XX,
> >         TYPE_EXYNOS4210,
> > 
> > +       TYPE_EXYNOS4X12,
> > 
> >         TYPE_EXYNOS5250,
> >  
> >  };
> > 
> > diff --git a/drivers/usb/phy/phy-samsung-usb2.c
> > b/drivers/usb/phy/phy-samsung-usb2.c index 45ffe03..b95d05d 100644
> > --- a/drivers/usb/phy/phy-samsung-usb2.c
> > +++ b/drivers/usb/phy/phy-samsung-usb2.c
> > @@ -158,6 +158,59 @@ static void samsung_exynos5_usb2phy_enable(struct
> > samsung_usbphy *sphy)> 
> >         writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
> >  
> >  }
> > 
> > +static bool exynos4_phyhost_is_on(void *regs)
> > +{
> > +       u32 reg;
> > +
> > +       reg = readl(regs + SAMSUNG_PHYPWR);
> > +
> > +       return !(reg & PHYPWR_ANALOG_POWERDOWN_PHY1);
> > +}
> > +
> > +static void samsung_exynos4x12_usb2phy_enable(struct samsung_usbphy
> > *sphy) +{
> > +       void __iomem *regs = sphy->regs;
> > +       u32 phypwr;
> > +       u32 phyclk;
> > +       u32 rstcon;
> > +
> > +       /*
> > +        * phy_usage helps in keeping usage count for phy
> > +        * so that the first consumer enabling the phy is also
> > +        * the last consumer to disable it.
> > +        */
> > +
> > +       atomic_inc(&sphy->phy_usage);
> > +
> > +       if (exynos4_phyhost_is_on(regs)) {
> > +               dev_info(sphy->dev, "Already power on PHY\n");
> > +               return;
> > +       }
> > +
> > +       writel(EXYNOS_USBPHY_ENABLE, sphy->pmuregs +
> > EXYNOS4X12_PHY_HSIC_CTRL0); +       writel(EXYNOS_USBPHY_ENABLE,
> > sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1); +
> > +       /* Common block configuration during suspend */
> > +       phyclk = sphy->ref_clk_freq
> > +               & ~(PHYCLK_COMMON_ON_N_PHY1);
> > +       writel(phyclk, regs + SAMSUNG_PHYCLK);
> > +
> > +       /* Enable normal mode of Host */
> > +       phypwr = readl(regs + SAMSUNG_PHYPWR);
> > +       phypwr &= ~(PHYPWR_NORMAL_MASK_HSIC0 |
> > PHYPWR_NORMAL_MASK_HSIC1
> > +                       | PHYPWR_NORMAL_MASK_PHY1);
> > +       writel(phypwr, regs + SAMSUNG_PHYPWR);
> > +
> > +       /* Reset both PHY and Link of Host */
> > +       rstcon = readl(regs + SAMSUNG_RSTCON)
> > +               | (RSTCON_HLINK_SWRST_MASK | RSTCON_PHY1_SWRST_MASK);
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> > +       udelay(10);
> > +       rstcon &= ~(RSTCON_HLINK_SWRST_MASK | RSTCON_PHY1_SWRST_MASK);
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> > +       udelay(80);
> > +}
> > +
> > 
> >  static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
> >  {
> >  
> >         void __iomem *regs = sphy->regs;
> > 
> > @@ -228,6 +281,27 @@ static void
> > samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)> 
> >         writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> >  
> >  }
> > 
> > +static void samsung_exynos4x12_usb2phy_disable(struct samsung_usbphy
> > *sphy) +{
> > +       void __iomem *regs = sphy->regs;
> > +       u32 phypwr;
> > +
> > +       if (atomic_dec_return(&sphy->phy_usage) > 0) {
> > +               dev_info(sphy->dev, "still being used\n");
> > +               return;
> > +       }
> > +
> > +       /* unset to normal of Host and Device */
> > +       phypwr = readl(regs + SAMSUNG_PHYPWR)
> > +               | (PHYPWR_NORMAL_MASK_PHY1
> > +                               | PHYPWR_NORMAL_MASK_HSIC1
> > +                               | PHYPWR_NORMAL_MASK_HSIC0);
> > +       writel(phypwr, regs + SAMSUNG_PHYPWR);
> > +
> > +       writel(0, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
> > +       writel(0, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
> > +}
> > +
> > 
> >  static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
> >  {
> >  
> >         void __iomem *regs = sphy->regs;
> > 
> > @@ -293,6 +367,8 @@ static int samsung_usb2phy_init(struct usb_phy
> > *phy)> 
> >         /* Initialize usb phy registers */
> >         if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
> >         
> >                 samsung_exynos5_usb2phy_enable(sphy);
> > 
> > +       else if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12)
> > +               samsung_exynos4x12_usb2phy_enable(sphy);
> > 
> >         else
> >         
> >                 samsung_usb2phy_enable(sphy);
> > 
> > @@ -336,6 +412,8 @@ static void samsung_usb2phy_shutdown(struct
> > usb_phy *phy)> 
> >         /* De-initialize usb phy registers */
> >         if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
> >         
> >                 samsung_exynos5_usb2phy_disable(sphy);
> > 
> > +       if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12)
> > +               samsung_exynos4x12_usb2phy_disable(sphy);
> > 
> >         else
> >         
> >                 samsung_usb2phy_disable(sphy);
> > 
> > @@ -451,6 +529,12 @@ static const struct samsung_usbphy_drvdata
> > usb2phy_exynos4 = {> 
> >         .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> >  
> >  };
> > 
> > +static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
> > +       .cpu_type               = TYPE_EXYNOS4X12,
> > +       .devphy_en_mask         = EXYNOS_USBPHY_ENABLE,
> > +       .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> > +};
> > +
> > 
> >  static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
> >  
> >         .cpu_type               = TYPE_EXYNOS5250,
> >         .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> > 
> > @@ -466,6 +550,9 @@ static const struct of_device_id
> > samsung_usbphy_dt_match[] = {> 
> >                 .compatible = "samsung,exynos4210-usb2phy",
> >                 .data = &usb2phy_exynos4,
> >         
> >         }, {
> > 
> > +               .compatible = "samsung,exynos4x12-usb2phy",
> > +               .data = &usb2phy_exynos4x12,
> > +       }, {
> > 
> >                 .compatible = "samsung,exynos5250-usb2phy",
> >                 .data = &usb2phy_exynos5
> >         
> >         },
> > 
> > @@ -482,6 +569,9 @@ static struct platform_device_id
> > samsung_usbphy_driver_ids[] = {> 
> >                 .name           = "exynos4210-usb2phy",
> >                 .driver_data    = (unsigned long)&usb2phy_exynos4,
> >         
> >         }, {
> > 
> > +               .name           = "exynos4x12-usb2phy",
> > +               .driver_data    = (unsigned long)&usb2phy_exynos4x12,
> > +       }, {
> > 
> >                 .name           = "exynos5250-usb2phy",
> >                 .driver_data    = (unsigned long)&usb2phy_exynos5,
> >         
> >         },
> > 
> > --
> > 1.7.9.5
> > 
> > _______________________________________________
> > devicetree-discuss mailing list
> > devicetree-discuss@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/devicetree-discuss
