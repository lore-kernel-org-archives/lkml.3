Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161778AbaKNTRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:17:41 -0500
Received: from exprod5og120.obsmtp.com ([64.18.0.137]:34673 "HELO
	exprod5og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161750AbaKNTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:17:40 -0500
MIME-Version: 1.0
In-Reply-To: <2126031.OOHBs2pzVu@wuerfel>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
	<1415924401-3013-2-git-send-email-fkan@apm.com>
	<2126031.OOHBs2pzVu@wuerfel>
Date: Fri, 14 Nov 2014 11:17:38 -0800
Message-ID: <CAL85gmCXBFCs6dNQXDLh4HAgZ4SN7Wwnon_D3a4q_Rq3oz-Vvg@mail.gmail.com>
Subject: Re: [PATCH V2 1/7] arm64: dts: Add APM X-Gene USB DTS node
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =devicetree@vger.kernel.org, Bao Truong <btruong@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 7:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 November 2014 16:19:55 Feng Kan wrote:
>>
>> +               usb0: dwusb@19000000 {
>> +                       status = "disabled";
>> +                       compatible = "xhci-platform";
>> +                       reg =  <0x0 0x19000000 0x0 0x100000>;
>> +                       interrupts = <0x0 0x89 0x4>;
>> +                       dma-coherent;
>> +               };
>> +
>> +               usb1: dwusb@19800000 {
>> +                       status = "disabled";
>> +                       compatible = "xhci-platform";
>> +                       reg =  <0x0 0x19800000 0x0 0x100000>;
>> +                       interrupts = <0x0 0x8a 0x4>;
>> +                       dma-coherent;
>> +               };
>>
>
> Call the nodes 'usb', not 'dwusb'.
This was a deliberate change on our part to make sure backward
compatibility with a older bootloader.

> Should these be 'status="disabled"', or
> do you expect every machine to have both connected?
Not all platform has both enabled at this point. Not enabling them
would allow us to save some power
if the IP is not used.
>
>         Arnd
