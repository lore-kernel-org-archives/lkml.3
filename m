Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3BYXZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:25:42 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42495 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755004Ab3BYXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:25:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Lubomir Rintel <lkundrak@v3.sk>, Daniel Drake <dsd@laptop.org>
CC: Harro Haan <hrhaan@gmail.com>, Dan Williams <dcbw@redhat.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Feb 2013 15:21:23 -0800
Subject: RE: [PATCH] libertas sdio: remove CMD_FUNC_INIT call
Thread-Topic: [PATCH] libertas sdio: remove CMD_FUNC_INIT call
Thread-Index: Ac4SvTEV3wp2szF0RnWOIEyTKztmXAA8HTvg
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D7F8FF0@SC-VEXCH1.marvell.com>
References: <1358493883-28433-1-git-send-email-lkundrak@v3.sk>
	 <477F20668A386D41ADCC57781B1F70430D140B07DE@SC-VEXCH1.marvell.com>
	 <1361249203.14137.27.camel@unicorn.kokotovo>
	 <477F20668A386D41ADCC57781B1F70430D9D6CEA08@SC-VEXCH1.marvell.com>
 <1361730693.31709.1.camel@unicorn.kokotovo>
In-Reply-To: <1361730693.31709.1.camel@unicorn.kokotovo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1PNPhTc027837

Hi Daniel,

> > There seems to be a race condition in lbs_thread().
> >
> > At line 582:
> >  582                 if (!priv->fw_ready)
> >  583                         continue;
> >
> > The fw_ready is 0, so you never get the chance to execute the FUNC_INIT command.
> >
> >  617                 /* Execute the next command */
> >  618                 if (!priv->dnld_sent && !priv->cur_cmd)
> >  619                         lbs_execute_next_command(priv);
> >
> >
> > Could you try the following change?
> >
> > diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libe
> > index 739309e..8f5d977 100644
> > --- a/drivers/net/wireless/libertas/if_sdio.c
> > +++ b/drivers/net/wireless/libertas/if_sdio.c
> > @@ -825,6 +825,8 @@ static void if_sdio_finish_power_on(struct if_sdio_card *car
> >
> >         sdio_release_host(func);
> >
> > +       priv->fw_ready = 1;
> > +
> >         /*
> >          * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
> >          */
> > @@ -839,7 +841,6 @@ static void if_sdio_finish_power_on(struct if_sdio_card *car
> >                         netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
> >         }
> >
> > -       priv->fw_ready = 1;
> >         wake_up(&card->pwron_waitq);
> >
> >         if (!card->started) {
> 
> Thank you.
> Everything seem to work fine for me with the patch applied.

Do you have any concern for OLPC platforms with above change? If it doesn't seem to break OLPC I will send a patch to the list.

Thanks,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
