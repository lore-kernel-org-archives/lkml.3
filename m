Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaHGKBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:01:12 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:29947
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757264AbaHGKBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:01:08 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>
CC: "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>
Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPsJp6xKTt7EIbSUuPcoEni/e+fJvC0RvQgABXoYCAAW7XYIAAM8cAgAAe6hA=
Date: Thu, 7 Aug 2014 10:01:05 +0000
Message-ID: <6537011f698c4c7faaf5b66b870afbd2@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
 <41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
 <14d042bbcfb04308bfb3a1db18e46bec@BL2PR03MB338.namprd03.prod.outlook.com>
 <31f8f5504fc24d999f5af74338602bed@BLUPR03MB373.namprd03.prod.outlook.com>
 <c9727eaf22dc40f796793c6b127dfb9e@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <c9727eaf22dc40f796793c6b127dfb9e@BL2PR03MB338.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(377454003)(51704005)(85306004)(83072002)(85852003)(74316001)(2656002)(76576001)(87936001)(76482001)(93886004)(77982001)(21056001)(46102001)(105586002)(99286002)(64706001)(83322001)(79102001)(19580395003)(4396001)(33646002)(107046002)(20776003)(19580405001)(101416001)(74662001)(95666004)(106356001)(86362001)(81542001)(106116001)(54356999)(74502001)(50986999)(76176999)(2201001)(80022001)(66066001)(2501001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB343;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan Yao-B46683 Data: Thursday, August 07, 2014 4:05 PM
>To: Duan Fugang-B38611; wsa@the-dreams.de; marex@denx.de
>Cc: LW@KARO-electronics.de; mark.rutland@arm.com; shawn.guo@linaro.org;
>linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>i2c@vger.kernel.org; Li Frank-B20596
>Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
>driver
>
>Hi Fugang,
>
>> >> >+	/* Waiting for Transfer complete. */
>> >> >+	while (timeout--) {
>> >> >+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>> >> >+		if (temp & I2SR_ICF)
>> >> >+			break;
>> >> >+		udelay(10);
>> >> >+	}
>> >> Whether there have better method like interrupt to avoid dead wait
>> >> here until timeout ?
>> >
>> >Can you give me more suggestion? We have discussed it with our team,
>> >It seems the short query wait is necessary.
>> >
>> At least, you can use schdule_timeout() instead of udelay() ?
>
>In fact, the waiting time normally is less than 10-50us, but the minimum
>time interval for schdule_timeout() is 1 jiffies.
>So maybe schdule_timeout() is not very necessary?
>
Oh, if the waiting time is 10 ~ 50us, you can use usleep_range(10, 50).
