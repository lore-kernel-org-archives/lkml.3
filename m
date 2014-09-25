Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaIYJ7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:59:04 -0400
Received: from mail-by2on0139.outbound.protection.outlook.com ([207.46.100.139]:51169
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752072AbaIYJ7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:59:01 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>
CC: "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHP2J/6bTKAgO1WJ0e+ynaEgW5au5wRk9uAgAAFd8A=
Date: Thu, 25 Sep 2014 09:58:59 +0000
Message-ID: <0f491b0c56264ee09a09f94b718536f4@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
 <1411632689-31531-2-git-send-email-yao.yuan@freescale.com>
 <6a2c63ad3a60461a830a00281c9d0b3c@BLUPR03MB373.namprd03.prod.outlook.com>
In-Reply-To: <6a2c63ad3a60461a830a00281c9d0b3c@BLUPR03MB373.namprd03.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB371;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(189002)(13464003)(199003)(76482002)(31966008)(83322001)(54356999)(2656002)(101416001)(86362001)(19580405001)(10300001)(21056001)(19580395003)(50986999)(76176999)(120916001)(2201001)(85306004)(66066001)(4396001)(92566001)(64706001)(46102003)(77982003)(80022003)(79102003)(81542003)(74662003)(74502003)(81342003)(90102001)(97736003)(107046002)(76576001)(2501002)(106356001)(108616004)(83072002)(20776003)(87936001)(99286002)(85852003)(33646002)(74316001)(106116001)(105586002)(99396003)(95666004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB371;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Duan Fugang-B38611
> Sent: Thursday, September 25, 2014 5:25 PM
> To: Yuan Yao-B46683; wsa@the-dreams.de; marex@denx.de
> Cc: LW@KARO-electronics.de; mark.rutland@arm.com; shawn.guo@linaro.org;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-i2c@vger.kernel.org
> Subject: RE: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
> driver
> 
> From: Yuan Yao <yao.yuan@freescale.com> Sent: Thursday, September 25,
> 2014 4:11 PM
> >To: wsa@the-dreams.de; marex@denx.de
> >Cc: LW@KARO-electronics.de; mark.rutland@arm.com; Duan Fugang-B38611;
> >shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> >kernel@lists.infradead.org; linux-i2c@vger.kernel.org
> >Subject: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
> >driver
> >
> >Add dma support for i2c. This function depend on DMA driver.
> >You can turn on it by write both the dmas and dma-name properties in
> >dts node.
> >DMA is optional, even DMA request unsuccessfully, i2c can also work well.
> >
> >Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> >---
> > drivers/i2c/busses/i2c-imx.c | 352
> >+++++++++++++++++++++++++++++++++++++++++--
> > 1 file changed, 342 insertions(+), 10 deletions(-)
> >
> >diff --git a/drivers/i2c/busses/i2c-imx.c
> >b/drivers/i2c/busses/i2c-imx.c index 613069b..c643756 100644
> >--- a/drivers/i2c/busses/i2c-imx.c
> >+++ b/drivers/i2c/busses/i2c-imx.c
> >@@ -37,22 +37,27 @@
> >+	 */
> >+	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> >+	reinit_completion(&i2c_imx->dma->cmd_complete);
> >+	result = wait_for_completion_interruptible_timeout(
> >+				&i2c_imx->dma->cmd_complete,
> >+				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> >+	if (result <= 0) {
> >+		dmaengine_terminate_all(dma->chan_using);
> >+		if (result)
> >+			return result;
> >+		else
> >+			return -ETIMEDOUT;
> >+	}
> >+
> >+	/* Waiting for Transfer complete. */
> >+	while (1) {
> >+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> >+		if (temp & I2SR_ICF)
> Why not wait for IIF ?

[Yuan Yao] 
IIF is often used. But IIF cannot indicate transfer completely in DMA mode. 
So TCF(I2SR_ICF) is the only choice.

> >+			break;
> >+		if (time_after(jiffies, orig_jiffies +
> >+				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT))) {
> >+			dev_dbg(dev, "<%s> Timeout\n", __func__);
> >+			return -ETIMEDOUT;
> >+		}
> >+		schedule();
> >+	}

Thanks & Best regards,
Yuan Yao

