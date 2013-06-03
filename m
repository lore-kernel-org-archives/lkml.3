Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3FCD76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:59:58 -0400
Received: from smtp303.phy.lolipop.jp ([210.157.22.87]:55228 "EHLO
	smtp303.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3FCD7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:59:51 -0400
Message-ID: <51AC14B4.4050003@sakamocchi.jp>
Date: Mon, 03 Jun 2013 12:59:48 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: introduce fw_driver.probe and .remove methods
References: <51A20AEE.7060201@sakamocchi.jp> <20130526233513.1a95d0d5@stein> <20130526225757.GA32606@kroah.com> <51A742A1.8010108@sakamocchi.jp> <20130603002749.4fdc36a5@stein> <20130602223843.GA7194@kroah.com> <20130603013502.4df9bc6b@stein>
In-Reply-To: <20130603013502.4df9bc6b@stein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan and Greg,

I test Stefan's patches and it works well with my devices.

 > This is one of two(?) drivers on which he is currently working on;

Yes. I'm developing for two driver modules for some firewire sound 
device. One is "snd-fireworks" as Stefan mentioned and another is 
"snd-bebob" for BridgeCo.'s BeBoB based firewire sound devices. Both of 
them is now out of tree and in my github repository.

 >> Are there other firewire drivers in other trees in linux-next
 >> right now?

I know the persons who work for "snd-dice", an driver module is for TC 
Applied Technologies' Dice based firewire sound devices. I'll inform 
them about your patches and topic branch.


Thanks a lot!

Takashi Sakamoto
o-takashi@sakamocchi.jp

(Jun 03 2013 08:35), Stefan Richter wrote:
> On Jun 02 Greg Kroah-Hartman wrote:
>> On Mon, Jun 03, 2013 at 12:27:49AM +0200, Stefan Richter wrote:
>>> Although all in-tree drivers are being converted to the new methods,
>>> support for the old methods is left in place for the time being, aiming
>>> to avoid conflicts if/when new drivers are being merged into the
>>> mainline via other trees.
>>
>> Are there other firewire drivers in other trees in linux-next right now?
>> If not, I'd just recommend converting everything over and not using the
>> old functions at all.  Especially as there really isn't that many
>> firewire drivers, and new ones are pretty rare these days, right?
>
> I think there is none in -next at the moment.  But Sakamoto-san posted an
> RFC just two days ago:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-June/062614.html
>
> This is one of two(?) drivers on which he is currently working on; the
> other one is the one which is going to need the new id argument
> in .probe().  And then there is another person working on yet another
> sound/firewire/ driver, but upstreaming of that driver might take a
> little more time for some more integration steps, from what I heard.
>
> So, alternatively I could fold "firewire: remove support of
> fw_driver.driver.probe and .remove methods" into this one and commit it to
> a stable topic branch in linux1394.git (to be merged early after 3.10),
> and the audio driver developers could pull this topic branch if they want
> to and when they want to.
>
>> Other than that, your patch looks good.
>
> Thanks for review.

