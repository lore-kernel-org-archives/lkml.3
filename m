Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3GVFp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:45:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37895 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab3GVFp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:45:58 -0400
Message-ID: <51ECC705.2070904@ti.com>
Date: Mon, 22 Jul 2013 11:15:41 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 3/4] arm: dts: Add USB phy nodes for AM33XX
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-4-git-send-email-george.cherian@ti.com> <51E94571.8080805@cogentembedded.com> <51E94B30.9070805@linutronix.de> <51E98663.2040308@cogentembedded.com> <51E98897.6050105@linutronix.de> <51EA06EB.4080709@ti.com>
In-Reply-To: <51EA06EB.4080709@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/2013 9:11 AM, George Cherian wrote:
> On 7/20/2013 12:12 AM, Sebastian Andrzej Siewior wrote:
>> On 07/19/2013 08:33 PM, Sergei Shtylyov wrote:
>>> Hello.
>> Hello,
>>
>>>> usb: usb@47400000 {
>>>>      compatible = "ti,am33xx-usb";
>>>>           usb0_phy: phy@47401300 {
>>>>          compatible = "ti,am335x-usb-phy";
>>>>      }
>>>>      usb0: usb@47401000 {
>>>>          musb0: usb@47401400 {
>>>>              compatible = "mg,musbmhdrc";
>>>>          }
>>>>      }
>>>>      usb1_phy: phy@47402300 {
>>>>          compatible = "ti,am335x-usb-phy";
>>>>      }
>>>>      usb1: usb@47402000 {
>>>>          musb1: usb@47402400 {
>>>>              compatible = "mg,musbmhdrc";
>>>>          }
>>>>      }
>>>> }

How about something like this ?

Here am making
     wrapper -> musb instance 0 -> phy0
     wrapper -> musb instance 1 -> phy1

                 musb: usb@47400000 {
                         compatible = "ti,musb-am33xx";
                         reg = <0x47400000 0x1000>;
                         ranges;
                         #address-cells = <1>;
                         #size-cells = <1>;
                         interrupts = <17>;
                         ti,hwmods = "usb_otg_hs";

                         usb0@47401000 {
                                 reg = <0x47401000 0x800>;
                                 interrupts = <18>;
                                 interrupt-names = "mc";
                                 multipoint = <1>;
                                 num-eps = <16>;
                                 ram-bits = <12>;
                                 port-mode = <3>;
                                 power = <250>;
                                 phys = <&phy1>;
                                 phy-names = "am335x-usb0";
                                 phy1: am335x-usb0 {
                                         compatible = "ti,am335x-usb2";
                                         #phy-cells = <0>;
                                         id= <0>;
                                 };
                         };

                         usb1@47401800 {
                                 reg = <0x47401800 0x800>;
                                 interrupts = <19>;
                                 interrupt-names = "mc";
                                 multipoint = <1>;
                                 num-eps = <16>;
                                 ram-bits = <12>;
                                 port-mode = <3>;
                                 power = <250>;
                                 phys = <&phy2>;
                                 phy-names = "am335x-usb1";
                                 phy2: am335x-usb1 {
                                         compatible = "ti,am335x-usb2";
                                         #phy-cells = <0>;
                                         id= <1>;
                                 };
                         };

                 };

-- 
-George

