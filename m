Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965644AbaGPQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:40:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:57987 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609AbaGPQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:40:07 -0400
Message-ID: <53C6AAE1.7090802@linutronix.de>
Date: Wed, 16 Jul 2014 18:40:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-5-git-send-email-bigeasy@linutronix.de> <20140716151604.GG1365@saruman.home> <53C6A050.2050409@linutronix.de> <20140716160614.GI1365@saruman.home>
In-Reply-To: <20140716160614.GI1365@saruman.home>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 06:06 PM, Felipe Balbi wrote:

>>> well, other than in probe and other functions which need to
>>> make sure clocks are on, but it seems unnecessary to
>>> enable/disable in every function.
>> 
>> What do you have in mind? Do you plan to let the uart on while
>> the minicom is attached but is doing nothing? In that case,
>> ->startup() and ->shutdown() should be enough.
> 
> no the idea was to keep it on for as long as it's transferring 
> characters and idle it otherwise, if that can't be done easily,
> then I guess your way is the only way.

But maybe we have to add some additional logic here to keep it up for
the transfer. I've been just (maybe over)thinking: If you send 300
bytes over DMA via 300 baud it should take 10 seconds. The PM-timeout
could hit before the transfer is complete.
Same thing with hw-flowcontrol where you could get stalled for a few
seconds.
However it doesn't seem to be a problem in current omap-serial driver.

> cheers

Sebastian
