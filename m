Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3BDK1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:27:42 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:20813 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751055Ab3BDK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:27:41 -0500
Message-ID: <510F8D15.30804@gaisler.com>
Date: Mon, 04 Feb 2013 11:27:33 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com> <CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com> <510F6CF8.3000700@gaisler.com> <CACRpkdYbJiBT5u0qJz+Krpky7W0WNqtSsO6Jo2TYZ2LRcyassA@mail.gmail.com>
In-Reply-To: <CACRpkdYbJiBT5u0qJz+Krpky7W0WNqtSsO6Jo2TYZ2LRcyassA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-04 10:24, Linus Walleij wrote:
>>> And do you really have and test this regularly on both LE and BE hardware?
>>> I am worrying a bit about maintenance...
>>
>> I am more than happy to drop that. I will most probably never test this on
>> LE hardware.
>
> Will someone else? I'm more thinking whether it is customary in
> the SPARC drivers to do things like this, then we should follow
> that pattern of course.

It is definitely not customary in SPARC drivers. The module is marked 
"depends on OF" in Kconfig though and there seems to be no way to depend 
on an endianness. Unless someone instantiates the core in a LE system 
there is no reason for it.


>> 2) The grgpio_to_irq function is very hardware specific, and there is of
>> course no gpio_to_irq support in gpio-generic.
>
> Well, the idea about gpio-generic is to use the pieces you need
> IIRC. You may override.

Ah, I see, bgpio_init is exported, so I might be able use that from my 
driver to get rid of some functions. There is support for BE I saw now. 
It seems broken to me (flips bits, not bytes), but that can be fixed.


>> 3) Running on SPARC, I get Open Firmware information from prom, so there is
>> no platform data to access in the probe function. Of course general Open
>> Firmware support could be added to gpio-generic, but in addition my probe
>> needs to set up very hardware specific things for gpio_to_irq.
>
> We should probably add some way to handle generic GPIO
> with compatible strings etc, but that's way outside my competence
> so OK. Maybe Rob or Grant can say something.

Might be a good idea. However, by just using bgpio_init in a separate 
driver (like most other users of bgpio_init), that would not be required 
or used by me anyhow.


I'll look into using bgpio_init from my driver.

Cheers,
Andreas Larsson

