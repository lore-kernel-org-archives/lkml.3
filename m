Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3GKHlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:41:46 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:15301 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755747Ab3GKHlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:41:44 -0400
Message-ID: <51DE61B5.1000600@itdev.co.uk>
Date: Thu, 11 Jul 2013 08:41:41 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <20130606164629.GG31367@sirena.org.uk> <51B1F859.1010504@itdev.co.uk> <20130607154134.GU31367@sirena.org.uk> <51B20630.7000304@itdev.co.uk> <20130607164700.GW31367@sirena.org.uk> <51B6FE69.6060505@itdev.co.uk> <20130611114727.GY1403@sirena.org.uk> <51B7151F.5070307@itdev.co.uk> <20130619185909.GG1403@sirena.org.uk> <51C47C50.8000606@itdev.co.uk> <20130702101125.GD27646@sirena.org.uk>
In-Reply-To: <20130702101125.GD27646@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Fri, Jun 21, 2013 at 09:16:16AM -0700, Nick Dyer wrote:
>> Mark Brown wrote:
>>> Yes, to be honest.  I'd hope it wouldn't be increasing the number of
>>> read/write operations...
> 
>> For some operations it does. For example updating the whole chip config
>> (which is a common thing to want to do), it would turn a couple of write
>> operations into ~20 on recent chips.
> 
> Is that really happening on peformance critical paths other than initial
> power up (which could be handled more neatly anyway).

Well, you're right that we could probably add more API for performance
critical stuff. But that wasn't your original question.

>>> and of course a system integrator may choose not to copy the reference
>>> design in this respect, it does seem a bit odd after all.
> 
>> You're being a bit optimistic there. Examples of devices that require
>> this are Samsung Galaxy Tab 10.1, Asus Transformer TF101.
> 
> If absoluely nobody has used the separate wakeup pin then the hardware
> designers are wasting a pin there...  my point isn't that nobody would
> use the reference design it's that some boards will have the separate
> signal.

That's entirely hypothetical, and you're wasting our time until you can
actually point to such hardware, happy to write patches to support that
mode of operation as well if you do.
