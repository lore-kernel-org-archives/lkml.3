Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3E3MYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:24:17 -0400
Received: from smtp302.phy.lolipop.jp ([210.157.22.85]:35538 "EHLO
	smtp302.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3E3MYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:24:04 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 08:24:03 EDT
Message-ID: <51A742A1.8010108@sakamocchi.jp>
Date: Thu, 30 May 2013 21:14:25 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: How to get driver_data of struct ieee1394_device_id in kernel
 driver module?
References: <51A20AEE.7060201@sakamocchi.jp> <20130526233513.1a95d0d5@stein> <20130526225757.GA32606@kroah.com>
In-Reply-To: <20130526225757.GA32606@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan and Greg,

I'm glad to contact with you.

I'm quite a beginner of Linux Firewire subsystem (Juju) and the others 
like PCI and USB. So it's hard for me to realize what Juju should be.
But I can rebuild Juju and test it with my devices and modules for which 
I'm working. I'm pleased to test your patches in this way if you need to 
check probe() function in driver module.


Thanks

Takashi Sakamoto

(May 27 2013 07:57), Greg Kroah-Hartman wrote:
> On Sun, May 26, 2013 at 11:35:13PM +0200, Stefan Richter wrote:
>> I think your approach is sensible.  There is of course just the little
>> problem that firewire-core keeps the matching device_id table entry as a
>> secret to itself.  Therefore, struct ieee1394_device_id.driver_data is
>> currently totally useless.
>>
>> How about we make it available like in the following patch?
>>
>> Besides being useful to your presently out-of-tree work, the in-tree
>> sound/firewire/speakers.c::fwspk_detect() could be rewritten to use this
>> approach.  Maybe I will post an expanded version of this patch which
>> incorporates such a first in-tree usage.
>
> Why not pass it in the probe() function, like USB and PCI does?  That
> way, if the driver wants to save it for that device, it can.
>
> thanks,
>
> greg k-h

