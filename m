Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaKMLBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:01:49 -0500
Received: from mail-bl2on0089.outbound.protection.outlook.com ([65.55.169.89]:15620
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932503AbaKMLBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:45 -0500
X-Greylist: delayed 13651 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2014 06:01:45 EST
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>, Soren Brinkmann <sorenb@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH] can: Fix bug in suspend/resume
Thread-Topic: [PATCH] can: Fix bug in suspend/resume
Thread-Index: AQHP/yrOOprZB47R1kO98xYQocKVkJxd2aIAgACINLCAAAGLYA==
Date: Thu, 13 Nov 2014 11:01:30 +0000
References: <a44efc1fb0144cca9d0c4851cc51db25@BL2FFO11FD024.protection.gbl>
 <546484D9.4030005@pengutronix.de> <54648BF4.60007@pengutronix.de> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.224]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21098.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <2abd0a7b76bd4c5fab3cda60b8e2f8d1@BN1AFFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51914003)(189002)(13464003)(24454002)(377454003)(479174003)(51704005)(199003)(120916001)(31966008)(50986999)(54356999)(33646002)(76176999)(62966003)(77156002)(77096003)(104016003)(50466002)(47776003)(95666004)(106466001)(16601075003)(64706001)(23676002)(19580395003)(106116001)(2501002)(15975445006)(46102003)(87936001)(4396001)(99396003)(86362001)(20776003)(107046002)(19580405001)(44976005)(92566001)(108616004)(15202345003)(53416004)(2656002)(6806004)(21056001)(74316001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB019;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB019;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB019;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB019;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sADB1vns023459

Hi Marc,

-----Original Message-----
From: Appana Durga Kedareswara Rao
Sent: Thursday, November 13, 2014 4:28 PM
To: 'Marc Kleine-Budde'; wg@grandegger.com; Michal Simek; Soren Brinkmann; grant.likely@linaro.org; robh+dt@kernel.org
Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org
Subject: RE: [PATCH] can: Fix bug in suspend/resume

Hi Marc,

-----Original Message-----
From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
Sent: Thursday, November 13, 2014 4:16 PM
To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek; Soren Brinkmann; grant.likely@linaro.org; robh+dt@kernel.org
Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Appana Durga Kedareswara Rao
Subject: Re: [PATCH] can: Fix bug in suspend/resume

On 11/13/2014 11:15 AM, Marc Kleine-Budde wrote:
> On 11/13/2014 07:58 AM, Kedareswara rao Appana wrote:
>> When accessing the priv structure use container_of instead of dev_get_drvdata.
>
> Why?

The drvdata here is the struct net_device, not the platform device.
Please state this in the commit message.

If I understand the code correct, you can make use of the existing helper function to_platform_device():

http://lxr.free-electrons.com/source/include/linux/platform_device.h#L42

Thanks for the suggestion.
 Will use this macro(to_platform_device)  .

>
>> Enable the clocks in the suspend before accessing the registers of the CAN.
>>
>> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
>> ---
>>  drivers/net/can/xilinx_can.c |   20 ++++++++++++++++++--
>>  1 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/can/xilinx_can.c
>> b/drivers/net/can/xilinx_can.c index 5e8b560..63ef645 100644
>> --- a/drivers/net/can/xilinx_can.c
>> +++ b/drivers/net/can/xilinx_can.c
>> @@ -972,15 +972,30 @@ static const struct net_device_ops xcan_netdev_ops = {
>>   */
>>  static int __maybe_unused xcan_suspend(struct device *dev)  {
>> -    struct platform_device *pdev = dev_get_drvdata(dev);
>> +    struct platform_device *pdev = container_of(dev,
>> +                    struct platform_device, dev);
>>      struct net_device *ndev = platform_get_drvdata(pdev);
>>      struct xcan_priv *priv = netdev_priv(ndev);
>> +    int ret;
>>
>>      if (netif_running(ndev)) {
>>              netif_stop_queue(ndev);
>>              netif_device_detach(ndev);
>>      }
>>
>> +    ret = clk_prepare_enable(priv->can_clk);
>> +    if (ret) {
>> +            dev_err(dev, "unable to enable device clock\n");
>> +            return ret;
>> +    }
>> +
>> +    ret = clk_prepare_enable(priv->bus_clk);
>> +    if (ret) {
>> +            dev_err(dev, "unable to enable bus clock\n");
>> +            clk_disable_unprepare(priv->can_clk);
>> +            return ret;
>> +    }
>
> Now you have clock imbalance. Per suspend/resume cycle the clocks are
> enabled twice, but disabled only once.
>

The clocks are getting disabled and un prepared at the end of the probe.
In the resume the driver is doing register write.

Sorry spell mistake not in resume in the suspend I am doing a register write.

In order to do that register write I have to again enable and prepare the clocks.


Regards,
Kedar.


Regards,
Kedar.

>> +
>>      priv->write_reg(priv, XCAN_MSR_OFFSET, XCAN_MSR_SLEEP_MASK);
>>      priv->can.state = CAN_STATE_SLEEPING;
>>
>> @@ -999,7 +1014,8 @@ static int __maybe_unused xcan_suspend(struct device *dev)
>>   */
>>  static int __maybe_unused xcan_resume(struct device *dev)  {
>> -    struct platform_device *pdev = dev_get_drvdata(dev);
>> +    struct platform_device *pdev = container_of(dev,
>> +                    struct platform_device, dev);
>>      struct net_device *ndev = platform_get_drvdata(pdev);
>>      struct xcan_priv *priv = netdev_priv(ndev);
>>      int ret;

Marc

--
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
