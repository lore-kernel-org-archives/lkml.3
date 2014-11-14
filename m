Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaKNJOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:14:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60212 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbaKNJOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:14:12 -0500
Message-ID: <5465C75D.4070909@ti.com>
Date: Fri, 14 Nov 2014 14:41:57 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com> <5465C06C.90705@linutronix.de>
In-Reply-To: <5465C06C.90705@linutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/14/2014 02:12 PM, Sebastian Andrzej Siewior wrote:
> On 11/14/2014 09:24 AM, George Cherian wrote:
>> Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
>> condition. There are chances that we could get multiple interrupts
>> till the time the babble recover work gets scheduled. Sometimes
>> this could even end up in an endless loop making MUSB itself unusable.
> How do you trigger the babble error? Is this something that happens
> during suspend resume, plugging / unplugging a device or randomly while
> the device is used?
I have never seen this error while device is successfully enumerated 
and  while working fine.
Mostly u get it when we connect/disconnect devices to HOST port.
Normally I use the following for testing BABBLE
  - Especially when a fully loaded USB HUB getting connected to HOST port.
  - Or repeatedly load and unload musb_hdrc.ko with some device connected.

If nothing of the above work you might be the lucky one to have a good 
board!!!!

>
> Sebastian
>

