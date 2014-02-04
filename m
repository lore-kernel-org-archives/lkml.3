Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaBDPHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:07:04 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55496 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:07:00 -0500
Message-ID: <52F1020A.3050202@gmail.com>
Date: Tue, 04 Feb 2014 16:06:50 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Kamil Debski <k.debski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de
Subject: Re: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
References: <Pine.LNX.4.44L0.1401291530001.23560-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1401291530001.23560-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 29.01.2014 21:42, Alan Stern wrote:
> On Wed, 29 Jan 2014, Kamil Debski wrote:
>
>> Change the phy provider used from the old one using the USB phy
>> framework to a new one using the Generic phy framework.
>>
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> ---
>>   .../devicetree/bindings/usb/exynos-usb.txt         |   13 +++
>>   drivers/usb/host/ehci-exynos.c                     |   97 +++++++++++++-------
>>   2 files changed, 76 insertions(+), 34 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> index d967ba1..25e199a 100644
>> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> @@ -12,6 +12,10 @@ Required properties:
>>    - interrupts: interrupt number to the cpu.
>>    - clocks: from common clock binding: handle to usb clock.
>>    - clock-names: from common clock binding: Shall be "usbhost".
>> +  - port: if in the SoC there are EHCI phys, they should be listed here.
>> +One phy per port. Each port should have its reg entry with a consecutive
>> +number. Also it should contain phys and phy-names entries specifying the
>> +phy used by the port.
>
> What is the reg entry number used for?  As far as I can see, it isn't
> used for anything.  In which case, why have it at all?

The reg property is here to identify which EHCI port the node is 
describing. This should be mentioned in the documentation, though, as 
well as the whole description of port nodes should be written in a more 
structured manner, just as other properties.

Best regards,
Tomasz
