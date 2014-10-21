Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaJUUv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:51:28 -0400
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:30944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932935AbaJUUv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:51:26 -0400
Message-ID: <5446C668.3020609@opensource.altera.com>
Date: Tue, 21 Oct 2014 15:47:36 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>	 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com> <1413834151.2010.19.camel@x41>
In-Reply-To: <1413834151.2010.19.camel@x41>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR04CA038.namprd04.prod.outlook.com (10.141.249.156) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 0371762FE7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(52164004)(189002)(377424004)(199003)(479174003)(377454003)(51704005)(24454002)(164054003)(15395725005)(106356001)(105586002)(80022003)(99396003)(87266999)(42186005)(77096002)(21056001)(76482002)(64706001)(65806001)(66066001)(54356999)(23676002)(120916001)(65816999)(65956001)(95666004)(97736003)(50986999)(107046002)(76176999)(64126003)(110136001)(31966008)(59896002)(47776003)(86362001)(50466002)(20776003)(92726001)(92566001)(4396001)(40100003)(122386002)(85306004)(102836001)(83506001)(85852003)(15975445006)(46102003)(87976001)(19580395003)(80316001)(19580405001)(15202345003)(33656002)(101416001)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:3;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 02:42 PM, Paul Bolle wrote:
> dinguyen@opensource.altera.com schreef op ma 20-10-2014 om 13:52
> [-0500]:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Update DWC2 kconfig and makefile to support dual-role mode. The platform
>> file will always get compiled for the case where the controller is directly
>> connected to the CPU. So for loadable modules, dwc2.ko is built for host,
>> peripheral, and dual-role mode. The PCI bus interface will be called
>> dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.
>>
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>> ---
>> v5: dwc2.ko for all modes along with dwc2_platform.ko and dwc2_pci.ko will
>>     get built for kernel modules.
>> v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
>>     config options.
>> v2: Remove reference to dwc2_gadget
>> ---
>>  drivers/usb/dwc2/Kconfig  | 61 ++++++++++++++++++++++++++++-------------------
>>  drivers/usb/dwc2/Makefile | 32 ++++++++++++-------------
>>  2 files changed, 53 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
>> index f93807b..1ea702e 100644
>> --- a/drivers/usb/dwc2/Kconfig
>> +++ b/drivers/usb/dwc2/Kconfig
>> @@ -1,5 +1,5 @@
>>  config USB_DWC2
>> -	bool "DesignWare USB2 DRD Core Support"
>> +	tristate "DesignWare USB2 DRD Core Support"
>>  	depends on USB
> 
> (Side note: drivers/usb/dwc2/Kconfig is sourced (in drivers/usb/Kconfig)
> even if USB is _not_ set. But USB_DCW2 still depends on USB. Why is
> that?)

Because USB is for Host-Side support. DWC2 driver should only get built
for when USB is enabled. I think you're getting USB and USB_SUPPORT
mixed up.

In addition, thanks to your comment, I realized that DWC2 should also be
available to build when USB_GADGET is enabled. A patch has been sent:

http://marc.info/?l=linux-usb&m=141392377124818&w=2

> 
>>  	help
>>  	  Say Y here if your system has a Dual Role Hi-Speed USB
>> @@ -10,31 +10,53 @@ config USB_DWC2
>>  	  bus interface module (if you have a PCI bus system) will be
>>  	  called dwc2_pci.ko, and the platform interface module (for
>>  	  controllers directly connected to the CPU) will be called
>> -	  dwc2_platform.ko. For gadget mode, there will be a single
>> -	  module called dwc2_gadget.ko.
>> -
>> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
>> -	  host and gadget drivers are still currently separate drivers.
>> -	  There are plans to merge the dwc2_gadget driver with the dwc2
>> -	  host driver in the near future to create a dual-role driver.
>> +	  dwc2_platform.ko. For all modes(host, gadget and dual-role), there
>> +	  will be a single module called dwc2.ko.
>>  
>>  if USB_DWC2
>>  
>> +choice
>> +	bool "DWC2 Mode Selection"
>> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
>> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
>> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
>> +
> 
> Juggling kconfig tristate logic is still rather hard for me, but don't
> the above three "if" rules all evaluate to non-zero if both USB and
> USB_GADGET are 'm'? If that's correct perhaps USB_DWC2_DUAL_ROLE should
> be the last default (assuming the last default wins, that is).

As the way it is, the functionality is correct. As this is the same as
DWC3's Kconfig, perhaps Felipe can comment if something doesn't seem
correct.

> 
> Besides, will the default USB_DWC2_PERIPHERAL ever trigger as !USB can't
> be true at this point, can it?

Yes it can. USB is for Host-side support, so you can have a condition
where you just want to build for GADGET and !USB.

> 
>>  config USB_DWC2_HOST
>> -	tristate "Host only mode"
>> +	bool "Host only mode"
>>  	depends on USB
>>  	help
>>  	  The Designware USB2.0 high-speed host controller
>> -	  integrated into many SoCs.
>> +	  integrated into many SoCs. Select this option if you want the
>> +	  driver to operate in Host-only mode.
>> +
>> +comment "Gadget/Dual-role mode requires USB Gadget support to be enabled"
>> +
>> +config USB_DWC2_PERIPHERAL
>> +	bool "Gadget only mode"
>> +	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
>> +	help
>> +	  The Designware USB2.0 high-speed gadget controller
>> +	  integrated into many SoCs. Select this option if you want the
>> +	  driver to operate in Peripheral-only mode. This option requires
>> +	  USB_GADGET=y.
>> +
>> +config USB_DWC2_DUAL_ROLE
>> +	bool "Dual Role mode"
>> +	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
>> +	help
>> +	  Select this option if you want the driver to work in a dual-role
>> +	  mode. In this mode both host and gadget features are enabled, and
>> +	  the role will be determined by the cable that gets plugged-in. This
>> +	  option requires USB_GADGET=y.
>> +endchoice
> 
> (I wonder how the dependencies of these three config entries interact
> with the three defaults of this choice. Since we're dealing with three
> options here this requires a piece of paper, a pencil, and clear mind to
> figure out. Maybe I'll try that in a few days...)
> 
>>  config USB_DWC2_PLATFORM
>>  	bool "DWC2 Platform"
>> -	depends on USB_DWC2_HOST
>>  	default USB_DWC2_HOST
>> -	help
>> -	  The Designware USB2.0 platform interface module for
>> -	  controllers directly connected to the CPU. This is only
>> -	  used for host mode.
>> +        default y
> 
> You now have to default lines. Which one wins?

Yes, "default y" should be removed.


Thanks,
Dinh

