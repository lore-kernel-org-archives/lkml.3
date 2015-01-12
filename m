Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbbALPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:04:17 -0500
Received: from mail-bl2on0077.outbound.protection.outlook.com ([65.55.169.77]:43448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbbALPEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:04:15 -0500
X-Greylist: delayed 28101 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 10:04:14 EST
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Soren Brinkmann" <sorenb@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "Michal Simek" <michals@xilinx.com>
Subject: RE: [PATCH v4] can: Convert to runtime_pm
Thread-Topic: [PATCH v4] can: Convert to runtime_pm
Thread-Index: AQHQKnV50g8srEE1sk2hKt6qk1yee5y7FUPsgAFsa5yAAAeseoAAExTg
Date: Mon, 12 Jan 2015 15:04:08 +0000
References: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl>
 <54AD267C.4060004@pengutronix.de>
 <12e7202e137e4d5680185748ebf0cf2d@BY2FFO11FD060.protection.gbl>
 <54B299A0.1000504@pengutronix.de>
 <bb20847c9546459592241f801be2b536@BY2FFO11FD027.protection.gbl>
 <54B3CB51.3060207@pengutronix.de>
 <4a61c12b2e1d4103a41a3faf1d58837a@BN1BFFO11FD030.protection.gbl>
 <54B3D1C0.200@pengutronix.de>
In-Reply-To: <54B3D1C0.200@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.231.7]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ec96dd3ba13848fcbbdbf8ad1f2df792@BY2FFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(51704005)(479174004)(189002)(199003)(377454003)(13464003)(74316001)(87936001)(64706001)(110136001)(106466001)(23676002)(15975445007)(53416004)(2656002)(106116001)(102836002)(92726002)(16601075003)(2950100001)(54356999)(76176999)(50466002)(47776003)(50986999)(93886004)(108616004)(86362001)(6806004)(19580395003)(104016003)(77156002)(19580405001)(62966003)(92566002)(46102003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB061;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB061;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB061;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB061;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 15:04:11.3034
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB061
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0CF4Rik019195

Hi Marc,

> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Monday, January 12, 2015 7:23 PM
> To: Appana Durga Kedareswara Rao
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Soren Brinkmann; grant.likely@linaro.org;
> wg@grandegger.com; Michal Simek
> Subject: Re: [PATCH v4] can: Convert to runtime_pm
>
> On 01/12/2015 02:49 PM, Appana Durga Kedareswara Rao wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> >> Sent: Monday, January 12, 2015 6:56 PM
> >> To: Appana Durga Kedareswara Rao
> >> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; Soren Brinkmann; grant.likely@linaro.org;
> >> wg@grandegger.com; Michal Simek
> >> Subject: Re: [PATCH v4] can: Convert to runtime_pm
> >>
> >> On 01/12/2015 07:59 AM, Appana Durga Kedareswara Rao wrote:
> >>> Hi Marc,
> >>>
> >>>> -----Original Message-----
> >>>> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> >>>> Sent: Sunday, January 11, 2015 9:11 PM
> >>>> To: Appana Durga Kedareswara Rao
> >>>> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
> >>>> kernel@vger.kernel.org; Soren Brinkmann; grant.likely@linaro.org;
> >>>> wg@grandegger.com
> >>>> Subject: Re: [PATCH v4] can: Convert to runtime_pm
> >>>>
> >>>> On 01/11/2015 06:34 AM, Appana Durga Kedareswara Rao wrote:
> >>>> [...]
> >>>>>>>             return ret;
> >>>>>>>     }
> >>>>>>>
> >>>>>>>     priv->write_reg(priv, XCAN_MSR_OFFSET, 0);
> >>>>>>>     priv->write_reg(priv, XCAN_SRR_OFFSET, XCAN_SRR_CEN_MASK);
> >>>>>>>
> >>>>>>>     if (netif_running(ndev)) {
> >>>>>>>             priv->can.state = CAN_STATE_ERROR_ACTIVE;
> >>>>>>
> >>>>>> What happens if the device was not in ACTIVE state prior to the
> >>>>>> runtime_suspend?
> >>>>>>
> >>>>>
> >>>>> I am not sure about the state of CAN at this point of time.
> >>>>> I just followed what other drivers are following for run time  suspend
> :).
> >>>>
> >>>> Please check the state of the hardware if you go with bus off into
> >>>> suspend and then resume.
> >>>>
> >>>
> >>>         if (netif_running(ndev)) {
> >>>                         if (isr & XCAN_IXR_BSOFF_MASK) {
> >>>                                 priv->can.state = CAN_STATE_BUS_OFF;
> >>>                            priv->write_reg(priv, XCAN_SRR_OFFSET,
> >>>                                         XCAN_SRR_RESET_MASK);
> >>>                 } else if ((status & XCAN_SR_ESTAT_MASK) ==
> >>>                                         XCAN_SR_ESTAT_MASK) {
> >>>                         priv->can.state = CAN_STATE_ERROR_PASSIVE;
> >>>                 } else if (status & XCAN_SR_ERRWRN_MASK) {
> >>>                         priv->can.state = CAN_STATE_ERROR_WARNING;
> >>>                 } else {
> >>>                         priv->can.state = CAN_STATE_ERROR_ACTIVE;
> >>>                 }
> >>>         }
> >>>
> >>> Is the above code snippet ok for you?
> >>
> >> Yes, but what's the state of the hardware when it wakes up again?
> >
> > It depends on the previous state of the CAN.
> > I mean In Suspend we are putting the device in sleep mode and in
> > resume we are waking up by putting the device into the Configuration
> > mode. We are not doing any reset of the core in the suspend/resume so it
> depends on the previous state of the CAN when it wakes up that's why
> checking for the status of the CAN in the status register here to put the
> device in appropriate mode.
>
> I understand the software side, but I don't know how your hardware
> behaves. This is why I'm asking.

As far as I know the above is  the our can controller behavior. Anyway I will check with  the h/w team
And will get back to you regarding this. Meanwhile I am sending the next version of the patch
Please review it.

Regards,
Kedar.
>
> >
> >>
> >>>
> >>>>>>>             netif_device_attach(ndev);
> >>>>>>>             netif_start_queue(ndev);
> >>>>>>>     }
> >>>>>>>
> >>>>>>>     return 0;
> >>>>>>> }
> >>>>>>
> >>>>>>
> >>>>>>>
> >>>>>>> @@ -1020,9 +1035,9 @@ static int __maybe_unused
> >> xcan_resume(struct
> >>>>>>> device *dev)
> >>>>>>>
> >>>>>>>     priv->write_reg(priv, XCAN_MSR_OFFSET, 0);
> >>>>>>>     priv->write_reg(priv, XCAN_SRR_OFFSET, XCAN_SRR_CEN_MASK);
> >>>>>>> -   priv->can.state = CAN_STATE_ERROR_ACTIVE;
> >>>>>>>
> >>>>>>>     if (netif_running(ndev)) {
> >>>>>>> +           priv->can.state = CAN_STATE_ERROR_ACTIVE;
> >>>>>>>             netif_device_attach(ndev);
> >>>>>>>             netif_start_queue(ndev);
> >>>>>>>     }
> >>>>>>> @@ -1030,7 +1045,10 @@ static int __maybe_unused
> >>>> xcan_resume(struct
> >>>>>> device *dev)
> >>>>>>>     return 0;
> >>>>>>>  }
> >>>>>>>
> >>>>>>> -static SIMPLE_DEV_PM_OPS(xcan_dev_pm_ops, xcan_suspend,
> >>>>>> xcan_resume);
> >>>>>>> +static const struct dev_pm_ops xcan_dev_pm_ops = {
> >>>>>>> +   SET_SYSTEM_SLEEP_PM_OPS(xcan_suspend, xcan_resume)
> >>>>>>> +   SET_PM_RUNTIME_PM_OPS(xcan_runtime_suspend,
> >>>>>> xcan_runtime_resume,
> >>>>>>> +NULL) };
> >>>>>>>
> >>>>>>>  /**
> >>>>>>>   * xcan_probe - Platform registration call @@ -1071,7 +1089,7
> >>>>>>> @@ static int xcan_probe(struct platform_device *pdev)
> >>>>>>>             return -ENOMEM;
> >>>>>>>
> >>>>>>>     priv = netdev_priv(ndev);
> >>>>>>> -   priv->dev = ndev;
> >>>>>>> +   priv->dev = &pdev->dev;
> >>>>>>>     priv->can.bittiming_const = &xcan_bittiming_const;
> >>>>>>>     priv->can.do_set_mode = xcan_do_set_mode;
> >>>>>>>     priv->can.do_get_berr_counter = xcan_get_berr_counter; @@ -
> >>>>>> 1137,15
> >>>>>>> +1155,22 @@ static int xcan_probe(struct platform_device *pdev)
> >>>>>>>
> >>>>>>>     netif_napi_add(ndev, &priv->napi, xcan_rx_poll, rx_max);
> >>>>>>>
> >>>>>>> +   pm_runtime_set_active(&pdev->dev);
> >>>>>>> +   pm_runtime_irq_safe(&pdev->dev);
> >>>>>>> +   pm_runtime_enable(&pdev->dev);
> >>>>>>> +   pm_runtime_get_sync(&pdev->dev);
> >>>>>> Check error values?
> >>>>>
> >>>>> Ok
> >>>>>>> +
> >>>>>>>     ret = register_candev(ndev);
> >>>>>>>     if (ret) {
> >>>>>>>             dev_err(&pdev->dev, "fail to register failed
> >>>>>>> (err=%d)\n",
> >>>>>> ret);
> >>>>>>> +           pm_runtime_put(priv->dev);
> >>>>>>
> >>>>>> Please move the pm_runtime_put into the common error exit path.
> >>>>>>
> >>>>>
> >>>>> Ok
> >>>>>
> >>>>>>>             goto err_unprepare_disable_busclk;
> >>>>>>>     }
> >>>>>>>
> >>>>>>>     devm_can_led_init(ndev);
> >>>>>>> -   clk_disable_unprepare(priv->bus_clk);
> >>>>>>> -   clk_disable_unprepare(priv->can_clk);
> >>>>>>> +
> >>>>>>> +   pm_runtime_put(&pdev->dev);
> >>>>>>> +
> >>>>>>>     netdev_dbg(ndev, "reg_base=0x%p irq=%d clock=%d, tx fifo
> >>>>>> depth:%d\n",
> >>>>>>>                     priv->reg_base, ndev->irq, priv->can.clock.freq,
> >>>>>>>                     priv->tx_max);
> >>>>>>>
> >>>>>>
> >>>>>> I think you have to convert the _remove() function, too. Have a
> >>>>>> look at the gpio-zynq.c driver:
> >>>>>>
> >>>>>>> static int zynq_gpio_remove(struct platform_device *pdev) {
> >>>>>>>     struct zynq_gpio *gpio = platform_get_drvdata(pdev);
> >>>>>>>
> >>>>>>>     pm_runtime_get_sync(&pdev->dev);
> >>>>>>
> >>>>>> However I don't understand why the get_sync() is here. Maybe
> >>>>>> SÃ¶ren can help?
> >>>>>
> >>>>> I converted the remove function to use the run-time PM and .
> >>>>> Below is the remove code snippet.
> >>>>>
> >>>>>        ret = pm_runtime_get_sync(&pdev->dev);
> >>>>>         if (ret < 0) {
> >>>>>                 netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> >>>>>                                 __func__, ret);
> >>>>>                 return ret;
> >>>>>         }
> >>>>>
> >>>>>         if (set_reset_mode(ndev) < 0)
> >>>>>                 netdev_err(ndev, "mode resetting failed!\n");
> >>>>>
> >>>>>         unregister_candev(ndev);
> >>>>>         netif_napi_del(&priv->napi);
> >>>>>         free_candev(ndev);
> >>>>
> >>>>>         pm_runtime_disable(&pdev->dev);
> >>>>
> >>>> Can this make a call to xcan_runtime_*()? I'm asking since the ndev
> >>>> has been unregistered and already free()ed. Better move this
> >>>> directly after the set_reset_mode(). This way you are symmetric to
> >>>> the probe()
> >> function.
> >>>
> >>> If I move the  pm_runtime_disable after the set_reset_mode I am
> >>> getting the below error.
> >>> ERROR:
> >>> xilinx_can e0008000.can can0 (unregistering): xcan_get_berr_counter:
> >>> pm_runtime_get fail
> >>>
> >>> If I move the pm_runtime_disable after unregister_candev everything
> >>> is
> >> working fine.
> >>
> >> Fine - but who calls xcan_get_berr_counter here? Can you add a
> >> dump_stack() here?
> >>
> >
> > I think it is getting called from the atomic context.
> > When I  am trying to do a rmmod I am getting the above error.
> > ERROR:
> > xilinx_can e0008000.can can0 (unregistering): xcan_get_berr_counter:
> >  pm_runtime_get fail.
> >
> > I am getting only the above error in the console when I do rmmod.
>
> Put a dump_stack into xcan_get_berr_counter(), then you'll see where it's
> called from. However calling from atomic context should be fine.
>
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
