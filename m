Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3LIHW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:22:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34453 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3LIHWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:22:54 -0500
Message-ID: <52A56FC0.8020001@ti.com>
Date: Mon, 9 Dec 2013 12:52:40 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH 1/9] phy: core: Change the way of_phy_get is called
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386246579-25141-2-git-send-email-k.debski@samsung.com> <52A16104.3080704@ti.com> <009901cef271$3c40d0b0$b4c27210$%debski@samsung.com>
In-Reply-To: <009901cef271$3c40d0b0$b4c27210$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013 04:22 PM, Kamil Debski wrote:
> Hi,
>
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Friday, December 06, 2013 6:31 AM
>>
>> Hi,
>>
>> On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
>>> Previously the of_phy_get function took a struct device * and was
>>> declared static. It was impossible to call it from another driver and
>>> thus it was impossible to get phy defined
>>
>> It was never intended to be called from other drivers. What's up with
>> the wrapper of of_phy_get, phy_get()/devm_phy_get()? Why isn't that
>> enough?
>
> Implementing support for multiple phys in the ehci driver is a bit tricky.
> Especially when we want to do it right. Please have a look at this part of
> the dts file:
>
> +    ehci@12580000 {
> +        compatible = "samsung,exynos4210-ehci";
> +        reg = <0x12580000 0x20000>;
> +        interrupts = <0 70 0>;
> +        clocks = <&clock 304>, <&clock 305>;
> +        clock-names = "usbhost", "otg";
> +        status = "disabled";
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        port@0 {
> +            reg = <0>;
> +            phys = <&usb2phy 1>;
> +            phy-names = "host";
> +            status = "disabled";
> +        };
> +        port@1 {
> +            reg = <1>;
> +            phys = <&usb2phy 2>;
> +            phy-names = "hsic0";
> +            status = "disabled";
> +        };
> +        port@2 {
> +            reg = <2>;
> +            phys = <&usb2phy 3>;
> +            phy-names = "hsic1";
> +            status = "disabled";
> +        };
> +    };
>
> With the above we have a clear specification of ports and their respective
> phys. But to do this properly the ehci driver has to iterate over port
> nodes. It is much easier to use devm_of_phy_get by giving the node as its
> argument.

I see. There are a couple of more things we do in the wrapper that gets 
missed while exporting of_phy_get (get_device and try_module_get). You 
might want to re-work that one.

Thanks
Kishon
