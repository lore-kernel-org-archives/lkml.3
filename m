Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3DOL1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:27:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61559 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3DOL1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:27:43 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-0b-516be42cabc7
Message-id: <516BE429.9040002@samsung.com>
Date: Mon, 15 Apr 2013 13:27:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-usb@vger.kernel.org,
        mchehab@redhat.com, linux-doc@vger.kernel.org, linux@arm.linux.org.uk,
        javier@dowhile0.org, cesarb@cesarb.net, eballetbo@gmail.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        swarren@nvidia.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, santosh.shilimkar@ti.com, akpm@linux-foundation.org,
        davem@davemloft.net
Subject: Re: [PATCH v3 0/6] Generic PHY Framework
References: <1363770725-13717-1-git-send-email-kishon@ti.com>
 <20130415102009.D358E3E0AA8@localhost> <516BD835.8060007@ti.com>
In-reply-to: <516BD835.8060007@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUiTURjHOXvfnb0OZ2/m5CBRsEjKzxShk6QFEZ3uppcV5NJNbU5lS9Eu
	cjQnKGpaZHMfoG5qi+VSIz+ING1qKjlwLcP8yiWoZaQY5lBy2413v+d5/h8XD0OF9tARTG7+
	PakyX5Ingnx6Yn/UHRvjkaedm+sQYaPdBvH7hTK8bxiHWO9Ox8apchoPGpa42Om1Qrw22Qmx
	xmyH2O3VQez8UQ1x17Kbi5srLDSe7jdCbLA8onFLm5bCs9MC/NYxzMPDzwc5eL3WRuGZZ+Xc
	y0JSrqmGpGnLxSMfZnUUeW39yiF7Bi1F+vRzPDKm89JkwGTjkW5LGZnSNQNSo9mAZLXeC8nv
	d58h+bcaQ0Znejhkq+uEmL3Bv5glzcstlirjUzP4OU2Nam7hd2HJ1opMDdrZKhDEIDYJLX+Z
	pAMcjpzzdlgF+Ewo2wrQyxYHFRg2Aap0eDk+lYCNQkv2GT/T7Gn0c6wW+hiyCajGUQt8LGTF
	yGz5xAvoj6KdJ/P+hrAD70Tfjj+UYttotOz55jcfOzAvrjk5gTY1QNsuI+U7BLGRaERr8idR
	bAwa0DbAAJ9E3bZfVB1g9YdK9Idk+kOyJkC9AEJpUWah6k62IjFOJVGoivKz4zILFF0g8Ozt
	XtA6kjwEWAaIggX10fK0UK6kWFWqGAKIoURhAo/jYCXIkpTelyoLbiuL8qSqIcBhgiLUIDr+
	oTDW2jAsTpGdv1B3JaW6OE6mEEe6NBntLuv15unNv+huv2fvzcdXRxKPXzXtupnO8Gu9+3/W
	B26fjX1g9t68tQckOXL5Sm9lqt3Q6OmHpo1LI4nmBW9yizLk8WRF8BkWJpQmucNLxrPGt6NC
	KjrqFye4svRTT1l78NiuiFblSBKiKKVK8h9W2ms1ygIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 12:36 PM, Kishon Vijay Abraham I wrote:
> On Monday 15 April 2013 03:50 PM, Grant Likely wrote:
>> On Wed, 20 Mar 2013 14:41:59 +0530, Kishon Vijay Abraham I <kishon@ti.com>
>> wrote:
>>> Added a generic PHY framework that provides a set of APIs for the PHY drivers
>>> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
>>> the PHY with or without using phandle. To obtain a reference to the PHY
>>> without using phandle, the platform specfic intialization code (say from board
>>> file) should have already called phy_bind with the binding information. The
>>> binding information consists of phy's device name, phy user device name and an
>>> index. The index is used when the same phy user binds to mulitple phys.
>>>
>>> This framework will be of use only to devices that uses external PHY (PHY
>>> functionality is not embedded within the controller).
>>>
>>> The intention of creating this framework is to bring the phy drivers spread
>>> all over the Linux kernel to drivers/phy to increase code re-use and to
>>> increase code maintainability.
>>>
>>> Comments to make PHY as bus wasn't done because PHY devices can be part of
>>> other bus and making a same device attached to multiple bus leads to bad
>>> design.
>>>
>>> Making omap-usb2 and twl4030 to use this framework is provided as a sample.
>>>
>>> This patch series is developed on 3.9-rc3. Once the patch series gets finalised
>>> I'll resend omap-usb2 and twl4030 part based on Felipe's tree.
>>>
>>
>> [...]
>>
>>>   drivers/Kconfig                                    |    2 +
>>>   drivers/Makefile                                   |    2 +
>>>   drivers/phy/Kconfig                                |   13 +
>>>   drivers/phy/Makefile                               |    5 +
>>>   drivers/phy/phy-core.c                             |  574
>>> ++++++++++++++++++++
>>
>> This looks to be very specific for USB PHYs. Are you intending it to be
>> used for other types of PHYs, like Ethernet PHYs? If not, then this
> 
> Not really. This can be used by USB, SATA and Sylwester was planning to use it
> for video PHY's.

Yes, I have already some RFC patches to handle the display and the camera
interface DPHYs (MIPI DSI, MIPI CSI-2) with this API. I didn't post it, since
this framework is not settled yet. Those DPHYs need very few operations, like
disable/enable only and there was really not suitable API in the kernel until
now to handle them. We had plans in the past to write something like this 
generic PHY framework for the Samsung SoCs.

Some SoCs have plenty different PHYs: USB, SATA, MIPI CSI-2, MIPI DSI, HDMI... 
And some of them are simple enough to be covered by this generic PHY API.

Thanks,
Sylwester
