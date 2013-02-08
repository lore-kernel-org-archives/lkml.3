Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab3BHCf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:35:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49107 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab3BHCf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:35:27 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "wim@iguana.be" <wim@iguana.be>
Subject: RE: [PATCH] watchdog: davinci_wdt: update to devm_* API
Thread-Topic: [PATCH] watchdog: davinci_wdt: update to devm_* API
Thread-Index: AQHOBOOHURAx9H28hUGry08/sigqhJhuUVgAgADtVoA=
Date: Fri, 8 Feb 2013 02:35:17 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412C59CA@DBDE01.ent.ti.com>
References: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
 <5113E978.2060201@ti.com>
In-Reply-To: <5113E978.2060201@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r182ZUpS000977

Hi Sekhar,

Thanks for the review. 

On Thu, Feb 07, 2013 at 23:20:48, Nori, Sekhar wrote:
> 
> On 2/7/2013 9:02 AM, Kumar, Anil wrote:
> > Update the code to use devm_* API so that driver
> > core will manage resources.
> > 
> > Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> > ---
> > This patch applies on top of v3.8-rc6.
> > 
> > Tested on da850 EVM.
> > 
> > :100644 100644 e8e8724... 6ad76a3... M	drivers/watchdog/davinci_wdt.c
> >  drivers/watchdog/davinci_wdt.c |   34 +++++++++-------------------------
> >  1 files changed, 9 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> > index e8e8724..6ad76a3 100644
> > --- a/drivers/watchdog/davinci_wdt.c
> > +++ b/drivers/watchdog/davinci_wdt.c
> > @@ -69,7 +69,6 @@ static unsigned long wdt_status;
> >  #define WDT_REGION_INITED 2
> >  #define WDT_DEVICE_INITED 3
> >  
> > -static struct resource	*wdt_mem;
> >  static void __iomem	*wdt_base;
> >  struct clk		*wdt_clk;
> >  
> > @@ -201,10 +200,10 @@ static struct miscdevice davinci_wdt_miscdev = {
> >  
> >  static int davinci_wdt_probe(struct platform_device *pdev)
> >  {
> > -	int ret = 0, size;
> > -	struct device *dev = &pdev->dev;
> 
> Its not clear why you had to drop use of this variable?

Actually, I have not found any particular need to take pointer
into dev and then use in the code. Rather we can directly use.  

> 
> > +	int ret = 0;
> > +	static struct resource  *wdt_mem;
> >  
> > -	wdt_clk = clk_get(dev, NULL);
> > +	wdt_clk = clk_get(&pdev->dev, NULL);
> 
> When you are converting to use devres, why not convert this to
> devm_clk_get() as well?
> 
Right. I will do it.

Thanks,
Anil

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
