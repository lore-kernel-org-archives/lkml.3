Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaIIRcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:32:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaIIRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:32:16 -0400
Message-ID: <540F399B.4070304@infradead.org>
Date: Tue, 09 Sep 2014 10:32:11 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, paulz@synopsys.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: randconfig build error with next-20140909, in drivers/usb/dwc2/platform.c
References: <CA+r1Zhj_jPHoYvGTdqYMpGNfzm9EkvqG-kBE2yTpfJVNK4xygQ@mail.gmail.com>
In-Reply-To: <CA+r1Zhj_jPHoYvGTdqYMpGNfzm9EkvqG-kBE2yTpfJVNK4xygQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 07:46, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/usb/dwc2/platform.o: In function `dwc2_platform_driver_init':
> platform.c:(.init.text+0x0): multiple definition of `init_module'
> drivers/usb/dwc2/gadget.o:gadget.c:(.init.text+0x0): first defined here
> drivers/usb/dwc2/platform.o: In function `dwc2_platform_driver_exit':
> platform.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/usb/dwc2/gadget.o:gadget.c:(.exit.text+0x0): first defined here
> make[3]: *** [drivers/usb/dwc2/dwc2.o] Error 1
> 

There are other issues as well.

1.  On i386, with these configs:

CONFIG_USB_DWC2=m
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
# CONFIG_USB_DWC2_DUAL_ROLE is not set
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set

ERROR: "dwc2_hcd_get_frame_number" [drivers/usb/dwc2/dwc2.ko] undefined!
ERROR: "dwc2_hcd_disconnect" [drivers/usb/dwc2/dwc2.ko] undefined!
ERROR: "dwc2_hcd_start" [drivers/usb/dwc2/dwc2.ko] undefined!

2.  on x86_64, with these configs:

CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
# CONFIG_USB_DWC2_DUAL_ROLE is not set
CONFIG_USB_DWC2_PLATFORM=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set

drivers/built-in.o: In function `dwc2_hc_set_even_odd_frame':
core.c:(.text+0x1aff55): undefined reference to `dwc2_hcd_get_frame_number'
drivers/built-in.o: In function `dwc2_handle_common_intr':
(.text+0x1b3a48): undefined reference to `dwc2_hcd_start'
drivers/built-in.o: In function `dwc2_handle_common_intr':
(.text+0x1b3b05): undefined reference to `dwc2_hcd_disconnect'
drivers/built-in.o: In function `dwc2_handle_common_intr':
(.text+0x1b3b38): undefined reference to `dwc2_hcd_start'
drivers/built-in.o: In function `dwc2_handle_common_intr':
(.text+0x1b3e38): undefined reference to `dwc2_hcd_start'
drivers/built-in.o: In function `dwc2_driver_remove':
platform.c:(.text+0x1b7b35): undefined reference to `dwc2_hcd_remove'
drivers/built-in.o: In function `dwc2_driver_probe':
platform.c:(.text+0x1b7b72): undefined reference to `dwc2_set_all_params'
platform.c:(.text+0x1b7c66): undefined reference to `dwc2_hcd_init'



-- 
~Randy
