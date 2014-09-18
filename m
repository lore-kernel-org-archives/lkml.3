Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaIRP7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:59:55 -0400
Received: from [207.46.100.59] ([207.46.100.59]:61664 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932094AbaIRP7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:59:53 -0400
Message-ID: <541B0030.3000904@opensource.altera.com>
Date: Thu, 18 Sep 2014 10:54:24 -0500
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
Subject: Re: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com> <1409070003-21195-2-git-send-email-dinguyen@opensource.altera.com> <2539965.N1OFkvgc6j@amdc1032>
In-Reply-To: <2539965.N1OFkvgc6j@amdc1032>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA039.namprd04.prod.outlook.com (10.141.154.157) To
 BN3PR0301MB1186.namprd03.prod.outlook.com (25.160.156.148)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(189002)(51704005)(479174003)(24454002)(377454003)(199003)(66066001)(76176999)(92566001)(107046002)(64706001)(65956001)(47776003)(85306004)(83506001)(65806001)(19580395003)(80316001)(87976001)(20776003)(83322001)(97736003)(92726001)(31966008)(46102003)(33656002)(19580405001)(65816999)(95666004)(74502003)(105586002)(21056001)(64126003)(4396001)(42186005)(50986999)(83072002)(85852003)(77982003)(81542003)(87266999)(76482002)(99396002)(79102003)(110136001)(54356999)(59896002)(23746002)(80022003)(74662003)(101416001)(86362001)(77096002)(106356001)(90102001)(81342003)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1186;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On 09/12/2014 10:49 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> [ added linux-kernel ML to cc: ]
> 
> Hi,
> 
> On Tuesday, August 26, 2014 11:19:52 AM dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Update DWC2 kconfig and makefile to support dual-role mode. The platform
>> file will always get compiled for the case where the controller is directly
>> connected to the CPU. So for loadable modules, only dwc2.ko is needed.
> 
> Kconfig and Makefile changes should be done after (or at the same time as)
> driver code itself is modified to support dual-role mode.  Each individual
> patch of the patchset should be correct itself (not cause any breakages)
> in order to keep the whole patchset bisectable.
> 

Paulz mentioned this in v1 of this patch series and ever since then, I
have been careful to test each patch on it's own, and each version since
then has passed 0-Day kbuild testing. But I may have missed something in
v4. Will try to move the edits to Kconfig/Makefile to end for v5.

>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>> ---
>> v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
>>     config options.
>> v2: Remove reference to dwc2_gadget
>> ---
>>  drivers/usb/dwc2/Kconfig  | 63 +++++++++++++++++++++++++++--------------------
>>  drivers/usb/dwc2/Makefile | 21 ++++++++--------
>>  2 files changed, 47 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
>> index f93807b..4396a1f 100644
>> --- a/drivers/usb/dwc2/Kconfig
>> +++ b/drivers/usb/dwc2/Kconfig
>> @@ -1,40 +1,29 @@
>>  config USB_DWC2
>> -	bool "DesignWare USB2 DRD Core Support"
>> +	tristate "DesignWare USB2 DRD Core Support"
>>  	depends on USB
>>  	help
>>  	  Say Y here if your system has a Dual Role Hi-Speed USB
>>  	  controller based on the DesignWare HSOTG IP Core.
>>  
>> -	  For host mode, if you choose to build the driver as dynamically
>> -	  linked modules, the core module will be called dwc2.ko, the PCI
>> -	  bus interface module (if you have a PCI bus system) will be
>> -	  called dwc2_pci.ko, and the platform interface module (for
>> -	  controllers directly connected to the CPU) will be called
>> -	  dwc2_platform.ko. For gadget mode, there will be a single
>> -	  module called dwc2_gadget.ko.
>> -
>> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
>> -	  host and gadget drivers are still currently separate drivers.
>> -	  There are plans to merge the dwc2_gadget driver with the dwc2
>> -	  host driver in the near future to create a dual-role driver.
>> +	  If you choose to build the driver as dynamically
>> +	  linked modules, a single dwc2.ko(regardless of mode of operation)
> 
> minort nitpick: " " is missing after dwc2.ko
> 
>> +	  will get built for both platform IPs and PCI.
> 
> Why do you want ot merge both platform and PCI drivers into one?
> 
> To do it properly you need to modify module_init/exit() of the final
> module to properly handle both PCI and platform devices.  It should
> be easier to leave separate dwc2_pci/platform drivers and just put
> the common code into dwc2.ko.

I need to rework to the comment. I think it should say, "will get built
for either platform IPs or PCI." I am not merging both platform and PCI
drivers into one.

> 
>>  if USB_DWC2
>>  
>> +choice
>> +	bool "DWC2 Mode Selection"
>> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
>> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
>> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
>> +
>>  config USB_DWC2_HOST
>> -	tristate "Host only mode"
>> +	bool "Host only mode"
>>  	depends on USB
>>  	help
>>  	  The Designware USB2.0 high-speed host controller
>> -	  integrated into many SoCs.
>> -
>> -config USB_DWC2_PLATFORM
>> -	bool "DWC2 Platform"
>> -	depends on USB_DWC2_HOST
>> -	default USB_DWC2_HOST
>> -	help
>> -	  The Designware USB2.0 platform interface module for
>> -	  controllers directly connected to the CPU. This is only
>> -	  used for host mode.
>> +	  integrated into many SoCs. Select this option if you want the
>> +	  driver to operate in Host-only mode.
>>  
>>  config USB_DWC2_PCI
>>  	bool "DWC2 PCI"
> 
> Why have you left this option into middle of 'choice' selection?

Will move...

> 
> You've also left the "depends on USB_DWC2_HOST && PCI" unmodified
> which causes DWC2 PCI support to show up only if "Host only mode"
> is selected (it is not available if "Dual Role mode" is selected).
> 

Does PCI support gadget? I left it unmodified because I didn't think the
PCI driver supported Gadget.


>> @@ -47,11 +36,31 @@ config USB_DWC2_PCI
>>  comment "Gadget mode requires USB Gadget support to be enabled"
>>  
>>  config USB_DWC2_PERIPHERAL
>> -	tristate "Gadget only mode"
>> -	depends on USB_GADGET
>> +	bool "Gadget only mode"
>> +	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
>>  	help
>>  	  The Designware USB2.0 high-speed gadget controller
>> -	  integrated into many SoCs.
>> +	  integrated into many SoCs. Select this option if you want the
>> +	  driver to operate in Peripheral-only mode. This option requires
>> +	  USB_GADGET=y.
>> +
>> +config USB_DWC2_DUAL_ROLE
>> +	bool "Dual Role mode"
>> +	depends on ((USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2))
> 
> I believe that extra parentheses are not needed.

Yes, I can remove the extra parentheses.

> 
>> +	help
>> +	  Select this option if you want the driver to work in a dual-role
>> +	  mode. In this mode both host and gadget features are enabled, and
>> +	  the role will be determined by the cable that gets plugged-in. This
>> +	  option requires USB_GADGET=y.
>> +endchoice
>> +
>> +config USB_DWC2_PLATFORM
>> +	bool
>> +        depends on !PCI
> 
> Why have you introduced this limitation (without even mentioning it in
> the patch description)?  I suspect that by this change and disabling
> PCI in your config you've workarounded the issue of having the common
> module for PCI and platform parts completely.  Sorry but this is
> incorrect as we want to have PCI and platform support in one compiled
> kernel.

Yes...I will remove.

> 
>> +        default y
>> +        help
>> +          The Designware USB2.0 platform interface module for
>> +          controllers directly connected to the CPU.
>>  
>>  config USB_DWC2_DEBUG
>>  	bool "Enable Debugging Messages"
>> diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
>> index b73d2a5..3026135 100644
>> --- a/drivers/usb/dwc2/Makefile
>> +++ b/drivers/usb/dwc2/Makefile
>> @@ -1,10 +1,17 @@
>>  ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
>>  ccflags-$(CONFIG_USB_DWC2_VERBOSE)	+= -DVERBOSE_DEBUG
>>  
>> -obj-$(CONFIG_USB_DWC2_HOST)		+= dwc2.o
>> +obj-$(CONFIG_USB_DWC2)			+= dwc2.o
>>  dwc2-y					:= core.o core_intr.o
>> -dwc2-y					+= hcd.o hcd_intr.o
>> -dwc2-y					+= hcd_queue.o hcd_ddma.o
>> +
>> +ifneq ($(filter y,$(CONFIG_USB_DWC2_HOST) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
>> +	dwc2-y				+= hcd.o hcd_intr.o
>> +	dwc2-y				+= hcd_queue.o hcd_ddma.o
>> +endif
>> +
>> +ifneq ($(filter y,$(CONFIG_USB_DWC2_PERIPHERAL) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
>> +	dwc2-y       			+= gadget.o
>> +endif
>>  
>>  # NOTE: The previous s3c-hsotg peripheral mode only driver has been moved to
>>  # this location and renamed gadget.c. When building for dynamically linked
> 
> This comment is no longer true after your changes.

Well, this patch series doesn't affect this comment. gadget.c is still
gadget.c that was renamed from s3c-hsotg. I'd like to leave this comment
here for now because people are still forgetting that s3c-hsotg is now
gadget.

> 
>> @@ -19,10 +26,4 @@ ifneq ($(CONFIG_USB_DWC2_PCI),)
>>  	dwc2_pci-y			:= pci.o
>>  endif
> 
> dwc2_pci will still be build as separate module despite what the updated
> documentation for USB_DWC2 says.

Ah...So should I keep for PCD, dwc2-pci.ko or dwc2.ko?

> 
>> -ifneq ($(CONFIG_USB_DWC2_PLATFORM),)
>> -	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_platform.o
>> -	dwc2_platform-y			:= platform.o
>> -endif
>> -
>> -obj-$(CONFIG_USB_DWC2_PERIPHERAL)	+= dwc2_gadget.o
>> -dwc2_gadget-y				:= gadget.o
>> +dwc2-$(CONFIG_USB_DWC2_PLATFORM) += platform.o
> 
> platform.c references code from hcd.c but will be built alone for
> USB_DWC2_PERIPHERAL=y config (the link failure will happen).

I believed I have wrapped all the necessary functions from hcd.c so that
the link failure will not happen. But I will check again.

Thanks for your review.
Dinh


