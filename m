Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaE2Iem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:34:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60731 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaE2Iei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:34:38 -0400
Message-ID: <5386F0FE.7040003@ti.com>
Date: Thu, 29 May 2014 14:04:06 +0530
From: Satish Patel <satish.patel@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <tony@atomide.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC controller
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com> <1401267437-22489-2-git-send-email-satish.patel@ti.com> <20140528185334.GA30763@kroah.com>
In-Reply-To: <20140528185334.GA30763@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 12:23 AM, Greg KH wrote:
> On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
>> SmartCard controller uses this interface to communicate with
>> SmartCard via PHY
>>
>> Some SmartCard PHY has multiple slots for cards.
>> This inerface also enables controller to communicate
>> with one or more SmartCard connected over phy.
>>
>> interface structure includes following APIs
>> - set/get config
>> - activate/deactivate smart card
>> - warm reset
>> - register_notify (for card insert/remove/overheat)
>> - unregister_notify
>>
>> Signed-off-by: Satish Patel <satish.patel@ti.com>
>> ---
>>   Documentation/sc_phy.txt |  171 ++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/sc_phy.h   |  136 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 307 insertions(+)
>>   create mode 100644 Documentation/sc_phy.txt
>>   create mode 100644 include/linux/sc_phy.h
>
> These are .h files, but where is the "api" functions that use
> these structures defined at?
>
This is like template/wrappers, smart card phy driver will write API 
functions. And smartcard controller will call these functions.
With proposed approach, smartcard controller can communicate with any 
smart card phy (TI/NxP) without change in code. Using DT entry smartcard 
and PHY will gets connected with each other.
Refer diagram given @Documentation/sc_phy.txt.


> confused,
>
> greg k-h
>
