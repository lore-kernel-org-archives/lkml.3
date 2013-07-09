Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3GILgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:36:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33374 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3GILgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:36:12 -0400
Message-ID: <51DBF59F.1030109@ti.com>
Date: Tue, 9 Jul 2013 17:05:59 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <51DB16A1.6010006@linutronix.de> <51DBA23A.8000505@ti.com>
In-Reply-To: <51DBA23A.8000505@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 09 July 2013 11:10 AM, George Cherian wrote:
> On 7/9/2013 1:14 AM, Sebastian Andrzej Siewior wrote:
>> On 07/08/2013 12:43 PM, George Cherian wrote:
>>> This patch series adds phy support for AM335X platform.
>>> This patch series is based on Generic PHY framework [1].
>>>
>>>
>>> This series has
>>>     - adds dual musb instances support for am335x platform (just for testing)
>>>     - adds phy-amxxxx-usb driver used in AMxxxx platforms
>>>     - adds dt  bindings for the phys
>>>     - removes usb-phy and replaced with generic phy apis in glue layer
>> No, I don't like this all. You did the one thing I tried to avoid while
>> posting my quick-and-dirty phy driver recently: You duplicated a lot of
>> code which can be served by the nop driver and added only power
>> on/power off callbacks.
> I wanted to add phy wakeup control also, but currently phy_ops  dont have an op
> for wkup_ctrl
> Kishon, Can we add one?

Since this should be a capability of the PHY, can't we have wkup_ctrl always
enabled if the PHY has such a capability? or if it needs more user control,
should we implement a sysfs entry to enable wakeup?

Thanks
Kishon
