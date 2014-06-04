Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaFDCDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:03:42 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:31497
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbaFDCDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:03:41 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>,
        "adam.lee@canonical.com" <adam.lee@canonical.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Guan <samuel.guan@bayhubtech.com>
Subject: RE: [PATCH v3] mmc: sdhci-pci-o2micro: Add SeaBird SeaEagle SD3
 support
Thread-Topic: [PATCH v3] mmc: sdhci-pci-o2micro: Add SeaBird SeaEagle SD3
 support
Thread-Index: AQHPaEgnXn4iOE0pa0+q8MUIrojU/5s/5IcAgCB7cPA=
Date: Wed, 4 Jun 2014 02:03:24 +0000
Message-ID: <d21e5b126cc34679bb6a620c340aa5dc@CO2PR04MB651.namprd04.prod.outlook.com>
References: <1399287028-2582-1-git-send-email-peter.guo@bayhubtech.com>
 <CAPDyKFr6sKcZfBuzNi69d21nSYm17oy7j64eXwLdd4dyPqXe+A@mail.gmail.com>
In-Reply-To: <CAPDyKFr6sKcZfBuzNi69d21nSYm17oy7j64eXwLdd4dyPqXe+A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(377454003)(13464003)(24454002)(199002)(71364002)(189002)(99286001)(19580405001)(83322001)(66066001)(2656002)(79102001)(83072002)(54356999)(76482001)(74316001)(87936001)(85852003)(33646001)(74662001)(21056001)(76176999)(80022001)(81342001)(77982001)(50986999)(92566001)(81542001)(99396002)(31966008)(64706001)(77096999)(4396001)(76576001)(19580395003)(74502001)(101416001)(46102001)(20776003)(86362001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CO2PR04MB761;H:CO2PR04MB651.namprd04.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.guo@bayhubtech.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5423sqQ010793

Hi Hansson,

Have you include this patch to PR? If so could you tell me at which git  repository it is.  

BR
Peter.Guo

-----Original Message-----
From: Ulf Hansson [mailto:ulf.hansson@linaro.org] 
Sent: Wednesday, May 14, 2014 5:55 PM
To: Peter Guo
Cc: Chris Ball; adam.lee@canonical.com; linux-mmc; linux-kernel@vger.kernel.org; Samuel Guan
Subject: Re: [PATCH v3] mmc: sdhci-pci-o2micro: Add SeaBird SeaEagle SD3 support

On 5 May 2014 12:50, peter.guo <peter.guo@bayhubtech.com> wrote:
> From: Peter Guo <peter.guo@bayhubtech.com>
>
> Add O2Micro/BayHubTech chip 8520 subversion B1 SD3.0 support.
> Add O2Micro/BayHubTech chip 8620 and 8621 SD3.0 support Enable Led 
> function of 8520 chip.
>
> Signed-off-by: Peter Guo <peter.guo@bayhubtech.com>
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

Thanks Peter, Adam!

Unless someone objects, I intend to include this in the next PR I send to Chris.

Kind regards
Ulf Hansson

> ---
>  drivers/mmc/host/sdhci-pci-o2micro.c | 78 
> +++++++++++++++++++++++++++++++++++-
>  drivers/mmc/host/sdhci-pci-o2micro.h |  3 ++
>  2 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c 
> b/drivers/mmc/host/sdhci-pci-o2micro.c
> index f49666b..eafcd92 100644
> --- a/drivers/mmc/host/sdhci-pci-o2micro.c
> +++ b/drivers/mmc/host/sdhci-pci-o2micro.c
> @@ -21,6 +21,45 @@
>  #include "sdhci-pci.h"
>  #include "sdhci-pci-o2micro.h"
>
> +static void o2_pci_set_baseclk(struct sdhci_pci_chip *chip, u32 
> +value) {
> +       u32 scratch_32;
> +       pci_read_config_dword(chip->pdev,
> +                             O2_SD_PLL_SETTING, &scratch_32);
> +
> +       scratch_32 &= 0x0000FFFF;
> +       scratch_32 |= value;
> +
> +       pci_write_config_dword(chip->pdev,
> +                              O2_SD_PLL_SETTING, scratch_32); }
> +
> +static void o2_pci_led_enable(struct sdhci_pci_chip *chip) {
> +       int ret;
> +       u32 scratch_32;
> +
> +       /* Set led of SD host function enable */
> +       ret = pci_read_config_dword(chip->pdev,
> +                                   O2_SD_FUNC_REG0, &scratch_32);
> +       if (ret)
> +               return;
> +
> +       scratch_32 &= ~O2_SD_FREG0_LEDOFF;
> +       pci_write_config_dword(chip->pdev,
> +                              O2_SD_FUNC_REG0, scratch_32);
> +
> +       ret = pci_read_config_dword(chip->pdev,
> +                                   O2_SD_TEST_REG, &scratch_32);
> +       if (ret)
> +               return;
> +
> +       scratch_32 |= O2_SD_LED_ENABLE;
> +       pci_write_config_dword(chip->pdev,
> +                              O2_SD_TEST_REG, scratch_32);
> +
> +}
> +
>  void sdhci_pci_o2_fujin2_pci_init(struct sdhci_pci_chip *chip)  {
>         u32 scratch_32;
> @@ -216,6 +255,40 @@ int sdhci_pci_o2_probe(struct sdhci_pci_chip *chip)
>                 scratch &= 0x7f;
>                 pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, 
> scratch);
>
> +               /* DevId=8520 subId= 0x11 or 0x12  Type Chip support */
> +               if (chip->pdev->device == PCI_DEVICE_ID_O2_FUJIN2) {
> +                       ret = pci_read_config_dword(chip->pdev,
> +                                                   O2_SD_FUNC_REG0,
> +                                                   &scratch_32);
> +                       scratch_32 = ((scratch_32 & 0xFF000000) >> 
> + 24);
> +
> +                       /* Check Whether subId is 0x11 or 0x12 */
> +                       if ((scratch_32 == 0x11) || (scratch_32 == 0x12)) {
> +                               scratch_32 = 0x2c280000;
> +
> +                               /* Set Base Clock to 208MZ */
> +                               o2_pci_set_baseclk(chip, scratch_32);
> +                               ret = pci_read_config_dword(chip->pdev,
> +                                                           O2_SD_FUNC_REG4,
> +                                                           
> + &scratch_32);
> +
> +                               /* Enable Base Clk setting change */
> +                               scratch_32 |= O2_SD_FREG4_ENABLE_CLK_SET;
> +                               pci_write_config_dword(chip->pdev,
> +                                                      O2_SD_FUNC_REG4,
> +                                                      scratch_32);
> +
> +                               /* Set Tuning Window to 4 */
> +                               pci_write_config_byte(chip->pdev,
> +                                                     
> + O2_SD_TUNING_CTRL, 0x44);
> +
> +                               break;
> +                       }
> +               }
> +
> +               /* Enable 8520 led function */
> +               o2_pci_led_enable(chip);
> +
>                 /* Set timeout CLK */
>                 ret = pci_read_config_dword(chip->pdev,
>                                             O2_SD_CLK_SETTING, 
> &scratch_32); @@ -276,7 +349,7 @@ int sdhci_pci_o2_probe(struct sdhci_pci_chip *chip)
>                 pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, 
> scratch);
>
>                 ret = pci_read_config_dword(chip->pdev,
> -                                           O2_SD_FUNC_REG0, &scratch_32);
> +                                           O2_SD_PLL_SETTING, 
> + &scratch_32);
>
>                 if ((scratch_32 & 0xff000000) == 0x01000000) {
>                         scratch_32 &= 0x0000FFFF; @@ -299,6 +372,9 @@ 
> int sdhci_pci_o2_probe(struct sdhci_pci_chip *chip)
>                                                O2_SD_FUNC_REG4, scratch_32);
>                 }
>
> +               /* Set Tuning Windows to 5 */
> +               pci_write_config_byte(chip->pdev,
> +                               O2_SD_TUNING_CTRL, 0x55);
>                 /* Lock WP */
>                 ret = pci_read_config_byte(chip->pdev,
>                                            O2_SD_LOCK_WP, &scratch); 
> diff --git a/drivers/mmc/host/sdhci-pci-o2micro.h 
> b/drivers/mmc/host/sdhci-pci-o2micro.h
> index dbec4c9..a87ae24 100644
> --- a/drivers/mmc/host/sdhci-pci-o2micro.h
> +++ b/drivers/mmc/host/sdhci-pci-o2micro.h
> @@ -57,6 +57,9 @@
>  #define O2_SD_UHS2_L1_CTRL     0x35C
>  #define O2_SD_FUNC_REG3                0x3E0
>  #define O2_SD_FUNC_REG4                0x3E4
> +#define O2_SD_LED_ENABLE       BIT(6)
> +#define O2_SD_FREG0_LEDOFF     BIT(13)
> +#define O2_SD_FREG4_ENABLE_CLK_SET     BIT(22)
>
>  #define O2_SD_VENDOR_SETTING   0x110
>  #define O2_SD_VENDOR_SETTING2  0x1C8
> --
> 2.0.0.rc0
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
