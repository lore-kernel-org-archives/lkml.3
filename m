Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaLAM6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:58:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13916 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaLAM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:58:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-3c-547c65f971ab
Message-id: <547C65F7.4090801@samsung.com>
Date: Mon, 01 Dec 2014 13:58:31 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
 <20141129192607.GB17355@amd>
In-reply-to: <20141129192607.GB17355@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xK7o/U2tCDA5t1rG4te4cq8XGGetZ
	LY7unMhkMf8IkNv/ZiGrxcd7/1gtzr1ayWhxtukNu8X9r0cZLS7vmsNmsfXNOkaLng1bWS2W
	Xr/IZHH31FE2iwnT17JYtO49wm6xe9dTVovDb9pZLc7sX8lmcbqb1UHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j8NfF7J4bFrVyeZx59oeNo95JwM99sz/werRt2UVo8ezj++YPVas/s7u8XmT
	XABvFJdNSmpOZllqkb5dAldG37GXbAUNghVXFveyNjBe5O1i5OSQEDCROPt+JjuELSZx4d56
	ti5GLg4hgaWMEqe+P2SHcD4ySuw+txysildAS+L5vB5WEJtFQFVi2ZZesDibgKHEzxevmUBs
	UYEIiT+n97FC1AtK/Jh8jwXEFhGQl9jat4IZZCizwF0WiQsn34A1CAuESHyeOIEJYttyRolF
	Wy8C3cHBwSmgKXFgozJIDbOAtcTKSdsYIWx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqa
	XFCclJ5rpFecmFtcmpeul5yfu4kRErdfdzAuPWZ1iFGAg1GJh1dzbXWIEGtiWXFl7iFGCQ5m
	JRHet941IUK8KYmVValF+fFFpTmpxYcYmTg4pRoY/Swe7BTyzGm16fRVebrmiNoK+Zz70f1M
	0lwVc1axZXS+6Fnut3fhlTTHmb2v9kgY3dgwe1by1wkXS8qFC3Zs+B5Vf0d1po1Xys5061f8
	Yes6H5c5dphpHzux5wuvcv9m5cdvcj7V35n6sp2lfoc8T3rrhIcbAleYbHc4lT3Jfd3TuJzz
	Ux1rlViKMxINtZiLihMB4sTfg7kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Thanks for the review.

On 11/29/2014 08:26 PM, Pavel Machek wrote:
> Hi!
>
>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>> index 01e9f30..50a8dad 100644
>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>> @@ -41,6 +41,62 @@ Optional properties:
>>   	 To get more informations, please refer to documentaion.
>>   	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>>
>> +- led-flash : the LED submodule device node
>> +
>> +There are two led outputs available - fled1 and fled2. Each of them can
>> +control a separate led or they can be connected together to double
>> +the maximum current for a single connected led. One led is represented
>> +by one child node.
>> +
>> +Required properties:
>> +- compatible : must be "maxim,max77693-flash"
>> +
>> +Optional properties:
>> +- maxim,fleds : array of current outputs in order: fled1, fled2
>> +	Note: both current outputs can be connected to a single led
>> +	Possible values:
>> +		0 - the output is left disconnected,
>> +		1 - a diode is connected to the output.
>
> Is this one needed? Just ommit child note if it is not there.

It is needed because you can have one led connected two both
outputs. This allows to describe such a design.

>> +- maxim,trigger-type : Array of trigger types in order: flash, torch
>> +	Possible trigger types:
>> +		0 - Rising edge of the signal triggers the flash/torch,
>> +		1 - Signal level controls duration of the flash/torch.
>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>> +	in order: fled1, fled2
>> +	Possible flag values (can be combined):
>> +		1 - FLASH pin of the chip,
>> +		2 - TORCH pin of the chip,
>> +		4 - software via I2C command.
>
> Is it good idea to have bitfields like this?
>
> Make these required properties of the subnode?

This is related to a single property: trigger. I think that splitting
it to three properties would make unnecessary noise in the
binding.

Best Regards,
Jacek Anaszewski

