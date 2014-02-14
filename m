Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBNPrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:47:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63984 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBNPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:47:36 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-00-52fe3a94b199
Message-id: <52FE3A91.1090107@samsung.com>
Date: Fri, 14 Feb 2014 16:47:29 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        kishon <kishon@ti.com>, Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Julius Werner <jwerner@chromium.org>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
 <1390225363-24210-1-git-send-email-gautam.vivek@samsung.com>
 <52F39710.80101@samsung.com>
 <CAFp+6iFYoN1w_BX7mMEa-Xx5ADaPTTKeDzjsSbQmwVKdSEsmOw@mail.gmail.com>
In-reply-to: <CAFp+6iFYoN1w_BX7mMEa-Xx5ADaPTTKeDzjsSbQmwVKdSEsmOw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xK7pTrP4FGbQ+sbE4eL/eYv6Rc6wW
	bVcOslu8/b6F3aJ58Xo2i8sLL7FadBx6zGTx4/UFNoveBVfZLC487WGzWNi2hMXi8q45bBYz
	zu9jsli0rJXZ4vCbdlYHfo/ZDRdZPHbOusvusX/uGnaPvi2rGD2O39jO5PF5k1wAWxSXTUpq
	TmZZapG+XQJXxt9jVgUHuSo+fbJrYFzK0cXIySEhYCLxv+EuM4QtJnHh3nq2LkYuDiGBpYwS
	0/efgnI+M0osXPIFrIpXQEvi16qXjCA2i4CqxNaVP9lBbDYBNYnPDY/YQGxRgQiJv/PWM0LU
	C0r8mHyPBcQWEdCRONTazwIylFngBYtE54SLTCAJYQF7ic2/lrJDbHvDKLF92WZWkASnQLDE
	oWfvwGxmAWuJlZO2MULY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyR+vu5gXHrM6hCjAAejEg9vgf6/ICHWxLLiytxDjBIczEoivKckgEK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoY79SduHqirSnXaPcMK0nGJ73PtzY5yty1PPrj2svXB3jz7PVW
	F7Ms6ZVutNmsc0lp1uVt+45ql9je+izl2hasGe9iMOXw/nV3xYP6me342o/6L1y79fGrTomP
	hp0Zjx0dry5oLvf+fr/qCS/X5M4/ZTlMc9I+9n9Jl7R6Yppwesb3Gf+17W5zKLEUZyQaajEX
	FScCAI2DGJh9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 14.02.2014 14:53, Vivek Gautam wrote:
>>> Changes from v2:
>>> 1) Added support for multiple PHYs (UTMI+ and PIPE3) and
>>>      related changes in the driver structuring.
>>
>>
>> I'm a bit skeptical about this separation. Can the PHY operate with just the
>> UTMI+ or PIPE3 part enabled alone without the other? Can any PHY consumer
>> operate this way?
>
> Yes :-)
> As also pointed by Kishon the PHY consumer (which is DWC3 in case of
> Exynos5 SoC series)
> should theoretically be able use either UTMI+ phy for High speed
> operations or both (UTMI+ and PIPE3)
> for Super Speed operations.

OK, that's fine then. This is the explanation I needed, thanks.

>>
>> I believe the right thing to do here is to do all the initialization in
>> .power_on() and let the driver simply call phy_power_on() when it needs the
>> PHY and phy_power_off() otherwise.
>
> If this is what we should be doing then what will be the purpose of
> two separate APIs :
> phy_power_on() and phy_init().
> Am i missing while understanding the things.
>

I don't understand this separation as well. Operations that should be 
done together shouldn't be separated. Is there any case when you can 
call one of phy_power_on() and phy_init() without calling another one 
right before/after it?

Best regards,
Tomasz
