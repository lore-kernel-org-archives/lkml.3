Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaIRTnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:43:14 -0400
Received: from mail-by2on0095.outbound.protection.outlook.com ([207.46.100.95]:30703
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752955AbaIRTnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:43:13 -0400
Message-ID: <541B3175.6060802@opensource.altera.com>
Date: Thu, 18 Sep 2014 14:24:37 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <paulz@synopsys.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 04/12] usb: dwc2: Add the appropriate init calls in
 platform code
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com> <1409070003-21195-5-git-send-email-dinguyen@opensource.altera.com> <1609564.lrfde17RTW@amdc1032>
In-Reply-To: <1609564.lrfde17RTW@amdc1032>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA033.namprd04.prod.outlook.com (10.141.154.151) To
 CY1PR0301MB1193.namprd03.prod.outlook.com (25.160.165.24)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(24454002)(51704005)(199003)(479174003)(377454003)(189002)(65816999)(54356999)(87266999)(76176999)(50986999)(23746002)(85852003)(99396002)(80022003)(79102003)(92566001)(76482002)(86362001)(31966008)(92726001)(33656002)(87976001)(83072002)(42186005)(90102001)(77096002)(74502003)(50466002)(74662003)(59896002)(85306004)(64126003)(95666004)(105586002)(106356001)(65956001)(65806001)(20776003)(47776003)(21056001)(64706001)(4396001)(66066001)(101416001)(19580395003)(19580405001)(83322001)(80316001)(107046002)(97736003)(81542003)(81342003)(77982003)(46102003)(110136001)(83506001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1193;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 11:18 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> [ added linux-kernel ML to cc: ]
> 
> Hi,
> 
> On Tuesday, August 26, 2014 11:19:55 AM dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Add the proper init calls for either host, gadget or both in platform.c
>>
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>> ---
>>  drivers/usb/dwc2/core.h     | 13 +++++++++++++
>>  drivers/usb/dwc2/gadget.c   |  2 +-
>>  drivers/usb/dwc2/platform.c | 28 ++++++++++++++++++++++++----
> 
> Where are correspoding changes to pci.c?
> 
> I cannot find them in your patchset.

The current PCI driver only supports HCD. If you want PCI to support
gadget, then it can be done in a separate patchset.

> 
>>  3 files changed, 38 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
>> index f55e62d..3a49a00 100644
>> --- a/drivers/usb/dwc2/core.h
>> +++ b/drivers/usb/dwc2/core.h
>> @@ -960,6 +960,19 @@ extern void dwc2_dump_global_registers(struct dwc2_hsotg *hsotg);
>>   */
>>  extern u16 dwc2_get_otg_version(struct dwc2_hsotg *hsotg);
>>  
>> +/* Gadget defines */
>> +#if defined(CONFIG_USB_DWC2_PERIPHERAL) || defined(CONFIG_USB_DWC2_DUAL_ROLE)
>> +extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
>> +extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
>> +extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
>> +#else
>> +static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
>> +static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
>> +{ return 0; }
>> +static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>> +{ return 0; }
>> +#endif
>> +
>>  #if defined(CONFIG_USB_DWC2_HOST) || defined(CONFIG_USB_DWC2_DUAL_ROLE)
>>  /**
>>   * dwc2_hcd_get_frame_number() - Returns current frame number
>> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
>> index 96f868f..efa68a0 100644
>> --- a/drivers/usb/dwc2/gadget.c
>> +++ b/drivers/usb/dwc2/gadget.c
>> @@ -3572,7 +3572,7 @@ err_clk:
>>   * s3c_hsotg_remove - remove function for hsotg driver
>>   * @pdev: The platform information for the driver
>>   */
>> -static int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
>> +int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
>>  {
>>  	usb_del_gadget_udc(&hsotg->gadget);
>>  
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index dd2f8f5..2871f351 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -92,7 +92,14 @@ static int dwc2_driver_remove(struct platform_device *dev)
>>  {
>>  	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
>>  
>> -	dwc2_hcd_remove(hsotg);
>> +	if (IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL))
>> +		s3c_hsotg_remove(hsotg);
>> +	else if (IS_ENABLED(CONFIG_USB_DWC2_HOST))
>> +		dwc2_hcd_remove(hsotg);
>> +	else { /* dual role */
>> +		dwc2_hcd_remove(hsotg);
>> +		s3c_hsotg_remove(hsotg);
> 
> Why not simply always call:
> 
> 		dwc2_hcd_remove(hsotg);
> 		s3c_hsotg_remove(hsotg);
> 
> and add appropriate stub for dwc2_hcd_remove() for
> CONFIG_USB_DWC2_PERIPHERAL=y?

Yes...I'll do this for v5. Same for the init().

Dinh

