Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaIHMdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:33:08 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:50618 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaIHMdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:33:03 -0400
Message-ID: <540DA1E5.1060701@compulab.co.il>
Date: Mon, 08 Sep 2014 15:32:37 +0300
From: Dmitry Lifshitz <lifshitz@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, bcousson@baylibre.com,
        tony@atomide.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <1381402195-29257-2-git-send-email-kishon@ti.com> <52580F34.8030809@ti.com> <20140416161619.GH28035@saruman.home> <540D9449.3090008@compulab.co.il> <540D955C.6060602@ti.com>
In-Reply-To: <540D955C.6060602@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: lifshitz@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

Thank you for a quick reply. See, my reply below.

On 09/08/2014 02:39 PM, Roger Quadros wrote:
> On 09/08/2014 02:34 PM, Dmitry Lifshitz wrote:
>> Hi Felipe, Roger
>>
>> On 04/16/2014 07:16 PM, Felipe Balbi wrote:
>>> On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
>>>> Hi,
>>>>
>>>> On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
>>>>> From: George Cherian <george.cherian@ti.com>
>>>>>
>>>>> Added dr_mode property in dwc3 and set its default mode to device.
>>>>
>>>> If there is a specific reason why this is not set to "otg", we need
>>>> to explain it here.
>>>>
>>>> AFAIK the port is meant to be used as OTG port.
>>>
>>> we still don't have the workaround for dual role ports, I've been
>>> working on it but still need to retest and make sure it's working fine
>>> before merging upstream.
>>>
>>
>>
>> Does the OTG port suppose to work with OMAP5? I mean role switching mechanism?
>>
>> I'm testing kernel v3.16 with OMAP5 based board (CM-T54).
>>
>> If I set CONFIG_USB_DWC3_DUAL_ROLE, than nothing is going on when I plug some device/host cable into micro USB3.0 port (VBUS/ID detection with extcon events works fine).
>>
>> CONFIG_USB_DWC3_HOST/CONFIG_USB_DWC3_GADGET bring port to appropriate mode and it works.
>>
>> What is the purpose of setting dr_mode = "peripheral" in omap5.dtsi, since it is overridden by config options in dwc3_probe()?
>
> If dual role works it should be "otg" then. I'm not sure why it was set to peripheral. Maybe the role switching mechanism
> was not in place earlier.


This is what I have when setting dr_mode = "otg" (and compiling with 
CONFIG_USB_DWC3_DUAL_ROLE):

when load gadget driver and plugging host PC cable:

root@cm-debian:~# modprobe g_ether
using random self ethernet address
using random host ethernet address
usb0: HOST MAC fa:db:52:7f:95:c5
usb0: MAC be:75:8d:71:6d:02
using random self ethernet address
using random host ethernet address
g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
g_ether gadget: g_ether ready
root@cm-debian:~# ------------[ cut here ]------------
WARNING: CPU: 0 PID: 65 at 
/home/lifshitz/workroot/git-repo/OMAP5/omap5-kernel/drivers/bus/omap_l3_noc.c:147 
l3_handle_target.isra.2+0x230/0x27c()
44000000.ocp:L3 Standard Error: MASTER UN IDENTIFIED TARGET OCMRAM 
(Read): At Address: 0x00000000 : Data Access in User mode during 
Functional access
Modules linked in: usb_f_eem g_ether usb_f_rndis libcomposite u_ether 
configfs rfcomm ecb btmrvl_sdio btmrvl bluetooth mwifiex_sdio mwifiex 
dwc3 ahci_platform libahci_platform libahci libata snd_soc_cm_t54 
ads7846 dwc3_omap extcon_palmas rtc_palmas extcon_class at24 
snd_soc_wm8731 snd_soc_omap_mcbsp
CPU: 0 PID: 65 Comm: irq/39-palmas Tainted: G        W 
3.16.0-cm-t54+ #99
[<c00156d0>] (unwind_backtrace) from [<c00124ac>] (show_stack+0x10/0x14)
[<c00124ac>] (show_stack) from [<c05e29dc>] (dump_stack+0x74/0x8c)
[<c05e29dc>] (dump_stack) from [<c0037dbc>] (warn_slowpath_common+0x70/0x88)
[<c0037dbc>] (warn_slowpath_common) from [<c0037e68>] 
(warn_slowpath_fmt+0x30/0x40)
[<c0037e68>] (warn_slowpath_fmt) from [<c02d88b8>] 
(l3_handle_target.isra.2+0x230/0x27c)
[<c02d88b8>] (l3_handle_target.isra.2) from [<c02d89b0>] 
(l3_interrupt_handler+0xac/0x13c)
[<c02d89b0>] (l3_interrupt_handler) from [<c007ea00>] 
(handle_irq_event_percpu+0x7c/0x230)
[<c007ea00>] (handle_irq_event_percpu) from [<c007ebf8>] 
(handle_irq_event+0x44/0x64)
[<c007ebf8>] (handle_irq_event) from [<c0081b78>] 
(handle_fasteoi_irq+0xa8/0x134)
[<c0081b78>] (handle_fasteoi_irq) from [<c007e398>] 
(generic_handle_irq+0x20/0x30)
[<c007e398>] (generic_handle_irq) from [<c000f4ac>] (handle_IRQ+0x40/0x90)
[<c000f4ac>] (handle_IRQ) from [<c0008620>] (gic_handle_irq+0x2c/0x60)
[<c0008620>] (gic_handle_irq) from [<c05eacc0>] (__irq_svc+0x40/0x50)
Exception stack(0xec939d80 to 0xec939dc8)
9d80: ecb729b0 20000013 00000000 00000001 ecb72800 eca1e000 00000000 
ec939e44
9da0: ec939ed0 20000013 ecb72818 ed005e14 ec939ec8 ec939dc8 bf015f54 
c05ea548
9dc0: 80000013 ffffffff
[<c05eacc0>] (__irq_svc) from [<c05ea548>] 
(_raw_spin_unlock_irqrestore+0x1c/0x20)
[<c05ea548>] (_raw_spin_unlock_irqrestore) from [<bf015f54>] 
(extcon_update_state+0x144/0x1c4 [extcon_class])
[<bf015f54>] (extcon_update_state [extcon_class]) from [<bf023288>] 
(palmas_vbus_irq_handler+0x64/0xa0 [extcon_palmas])
[<bf023288>] (palmas_vbus_irq_handler [extcon_palmas]) from [<c00815a8>] 
(handle_nested_irq+0xa0/0x10c)
[<c00815a8>] (handle_nested_irq) from [<c03ab85c>] 
(regmap_irq_thread+0x184/0x300)
[<c03ab85c>] (regmap_irq_thread) from [<c007f8b8>] (irq_thread_fn+0x1c/0x40)
[<c007f8b8>] (irq_thread_fn) from [<c007f6a4>] (irq_thread+0x120/0x15c)
[<c007f6a4>] (irq_thread) from [<c0056434>] (kthread+0xdc/0xf0)
[<c0056434>] (kthread) from [<c000eb98>] (ret_from_fork+0x14/0x3c)
---[ end trace 3b365a734f7f3202 ]---
palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB cable is attached



when plugging storage device:

root@cm-debian:~# dmesg | tail -n20
...
omap-dwc3 4a020000.omap_dwc3: ID GND
palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB-HOST cable is attached
palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB cable is attached

and nothing is going on.

Once again, when compiling with predefined role 
(CONFIG_USB_DWC3_HOST/CONFIG_USB_DWC3_GADGET) the port is functional in 
both modes.

I'm wondering, if dwc3_probe() calls
dwc3_core_init_mode() -> dwc3_set_mode() than why it is not required in 
dwc3_omap_set_mailbox()?


>
> George any objections for "otg"?
>
> cheers,
> -roger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Thanks,

Dmitry
