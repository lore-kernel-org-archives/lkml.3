Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaETPqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:46:03 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:46366 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaETPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:46:01 -0400
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 11:46:00 EDT
Date: Tue, 20 May 2014 16:19:56 +0100 (BST)
From: Jamie Lentin <jm@lentin.co.uk>
X-X-Sender: lentinj@marmot.wormnet.eu
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Add custom driver for Lenovo ThinkPad Compact
 Bluetooth Keyboard
In-Reply-To: <alpine.LNX.2.00.1405201644230.1615@pobox.suse.cz>
Message-ID: <alpine.DEB.2.02.1405201555110.4059@marmot.wormnet.eu>
References: <1395786407-11273-1-git-send-email-jm@lentin.co.uk> <alpine.LNX.2.00.1405201644230.1615@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Jiri Kosina wrote:

> On Tue, 25 Mar 2014, Jamie Lentin wrote:
>
>> This keyboard requires some custom mappings for all keys to be
>> available, and the Fn-lock toggle needs to be controlled in software.
>>
>> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
>> ---
>> I assume that Linux users want Fn-Lock enabled by default, so they can
>> get at the function keys. If this is an incorrect assumption then can
>> change it---so long as there's some way of me leaving it enabled :)
>>
>> Tested with and applies cleanly to 3.13.6.
>>
>>  drivers/hid/Kconfig                   |  10 ++
>>  drivers/hid/Makefile                  |   1 +
>>  drivers/hid/hid-core.c                |   3 +
>>  drivers/hid/hid-ids.h                 |   1 +
>>  drivers/hid/hid-lenovo-tpcompactkbd.c | 191 ++++++++++++++++++++++++++++++++++
>>  5 files changed, 206 insertions(+)
>
> Jamie,
>
> thanks for the driver.
>
> I think it'd make more sense if this could be folded into hid-lenovo-tpkbd
> driver. Could you please do that and resubmit?

I can do if required, although I didn't originally since there would be no 
common code whatsoever between the keyboards. The newer keyboard has no 
leds to register, and no trackpoint settings are exposed like on the older 
keyboard. Equally the newer Fn-Lock setting wouldn't make sense for the 
older keyboards, since they have grown-up function keys. The similarity 
stops with the name.

I have both the USB and the Bluetooth versions of this keyboard now, 
once I have finished support for both[0] I will resubmit support for both.

Cheers,

[0] https://github.com/lentinj/tp-compact-keyboard/blob/usb-keyboard-support/module/hid-lenovo-tpcompactkbd.c
     if anyone is interested

-- 
Jamie Lentin
