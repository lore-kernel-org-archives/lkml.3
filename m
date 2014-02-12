Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBLAgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:36:21 -0500
Received: from relmlor4.renesas.com ([210.160.252.174]:41530 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100AbaBLAgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:36:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,828,1384268400"; 
   d="scan'";a="154012482"
Message-ID: <52FAC1F3.4050806@renesas.com>
Date: Wed, 12 Feb 2014 09:36:03 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] sh: sh7757: switch RSPI clock to dev ID match
References: <1389522649-1753-1-git-send-email-geert@linux-m68k.org> <CAMuHMdUYc8Ceid2z3c2Bm1ZDteu2iV-O4cPX4LdxiTnzhsh_Rw@mail.gmail.com>
In-Reply-To: <CAMuHMdUYc8Ceid2z3c2Bm1ZDteu2iV-O4cPX4LdxiTnzhsh_Rw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.148]
X-ClientProxiedBy: HKNPR01CA008.apcprd01.prod.exchangelabs.com
 (10.242.116.18) To HKXPR06MB007.apcprd06.prod.outlook.com (10.242.98.21)
X-Forefront-PRVS: 01208B1E18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(41574002)(377454003)(51704005)(24454002)(199002)(189002)(479174003)(63696002)(81816001)(81686001)(80022001)(65806001)(23676002)(47776003)(59766001)(95416001)(74366001)(83506001)(74706001)(59896001)(31966008)(74502001)(85306002)(74662001)(87976001)(92566001)(92726001)(69226001)(66066001)(65956001)(95666001)(77982001)(15975445006)(74876001)(47446002)(79102001)(64126003)(47976001)(94946001)(47736001)(49866001)(81342001)(77096001)(80316001)(76786001)(36756003)(50986001)(90146001)(575784001)(4396001)(86362001)(83072002)(81542001)(85852003)(19580395003)(19580405001)(93136001)(56816005)(94316002)(76482001)(76796001)(93516002)(50466002)(33656001)(83322001)(80976001)(54316002)(56776001)(46102001)(54356001)(51856001)(42186004)(53806001);DIR:OUT;SFP:1101;SCL:1;SRVR:HKXPR06MB007;H:[10.161.41.115];CLIP:211.11.155.148;FPR:ACC6FFC2.2F029F73.39C26B43.CC41BF62.202A2;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert-san,

(2014/02/07 21:45), Geert Uytterhoeven wrote:
> On Sun, Jan 12, 2014 at 11:30 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>
>> Switch the RSPI MSTP clock on SH7757 from a con ID match to a dev ID
>> match, so we can start looking it up using clk_get() with a NULL ID.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>> ---
>> Untested, as I don't have the hardware, but this is a prerequisite for
>> "spi: rspi: Use NULL as the clock ID".
> 
> Is there anyone who can test this?
> 
> "spi: rspi: Use NULL as the clock ID" is queued for v3.15:
> https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/drivers/spi/spi-rspi.c?h=for-next&id=29f397b739ceef90c8b848f6579cbacd088e896e
> and this patch should go in first.
> 
> Thanks!
> 
>>  arch/sh/kernel/cpu/sh4a/clock-sh7757.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
>> index e84a43229b9c..5c0e3c335161 100644
>> --- a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
>> +++ b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
>> @@ -132,7 +132,7 @@ static struct clk_lookup lookups[] = {
>>         CLKDEV_CON_ID("usb_fck", &mstp_clks[MSTP103]),
>>         CLKDEV_DEV_ID("renesas_usbhs.0", &mstp_clks[MSTP102]),
>>         CLKDEV_CON_ID("mmc0", &mstp_clks[MSTP220]),
>> -       CLKDEV_CON_ID("rspi2", &mstp_clks[MSTP127]),
>> +       CLKDEV_DEV_ID("rspi.2", &mstp_clks[MSTP127]),
>>  };
>>
>>  int __init arch_clk_init(void)

I could test this patch. And then, the patch worked correctly.

Best regards,
Yoshihiro Shimoda

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
