Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3GJE4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:56:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48426 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3GJE4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:56:37 -0400
Message-ID: <51DCE979.8010108@ti.com>
Date: Wed, 10 Jul 2013 10:26:25 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <51DB16A1.6010006@linutronix.de> <51DBA23A.8000505@ti.com> <51DBF59F.1030109@ti.com>
In-Reply-To: <51DBF59F.1030109@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 5:05 PM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Tuesday 09 July 2013 11:10 AM, George Cherian wrote:
>> On 7/9/2013 1:14 AM, Sebastian Andrzej Siewior wrote:
>>> On 07/08/2013 12:43 PM, George Cherian wrote:
>>>> This patch series adds phy support for AM335X platform.
>>>> This patch series is based on Generic PHY framework [1].
>>>>
>>>>
>>>> This series has
>>>>      - adds dual musb instances support for am335x platform (just for testing)
>>>>      - adds phy-amxxxx-usb driver used in AMxxxx platforms
>>>>      - adds dt  bindings for the phys
>>>>      - removes usb-phy and replaced with generic phy apis in glue layer
>>> No, I don't like this all. You did the one thing I tried to avoid while
>>> posting my quick-and-dirty phy driver recently: You duplicated a lot of
>>> code which can be served by the nop driver and added only power
>>> on/power off callbacks.
>> I wanted to add phy wakeup control also, but currently phy_ops  dont have an op
>> for wkup_ctrl
>> Kishon, Can we add one?
> Since this should be a capability of the PHY, can't we have wkup_ctrl always
> enabled if the PHY has such a capability?

No, we cant have wakeup always enabled. Normally we enable it only when 
we go to low power states and
if the user needs USB a wakeup source.

So how about enable/disable  phy wakeup from phy suspend/resume?
> or if it needs more user control,
> should we implement a sysfs entry to enable wakeup?

Nope, I dont want to create another sysfs entry.
>
> Thanks
> Kishon


-- 
-George

