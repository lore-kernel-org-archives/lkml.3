Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKFSPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:15:31 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45263 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKFSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:15:27 -0500
Message-ID: <545BBAA4.90407@linux.com>
Date: Thu, 06 Nov 2014 19:15:00 +0100
From: Matthias Klein <matthias.klein@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-rpi-kernel@lists.infradead.org, lee@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com> <545B071E.7090007@wwwdotorg.org>
In-Reply-To: <545B071E.7090007@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 06.11.2014 um 06:29 schrieb Stephen Warren:
> I guess we should have separate device trees for those, since there are
> some differences in the GPIO and I2C channel usage. That'd leave us with:
>
> bcm2835-rpi-b.dts (Pin3=GPIO0, Pin5=GPIO1, Pin13=GPIO21, I2C-0)
> bcm2835-rpi-b-rev2.dts (Pin3=GPIO1, Pin5=GPIO2, Pin13=GPIO27, 12C-1)
I think for these differences separate device trees are not needed.
These pins are all at the moment configured as ALT0. Both I2C buses are 
configured for I2C,
therefore I doesn't matter which one is wired to the gpio header.

But for clarity it would be better to have a separate device tree for 
each model.


When a gpio signal (which is configured in device tree as ALT0) is used 
as e.g. plain gpio output, does the kernel the reconfiguration from ALT0 
to gpio output?
Or must the gpio signal be configured as output in the device tree?

Is is possible to set at the brcm,function/brcm,pins gpio definition 
also the voltage level of an gpio output for e.g. the LAN_RUN signal?


How do we want to continue?
Is my patch OK, or should I try to write a device tree for every model 
where every gpio signal is defined?


Best regards,
Matthias

