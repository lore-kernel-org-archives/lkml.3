Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3FKQTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:19:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:36707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FKQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:19:05 -0400
Message-ID: <51B74DF1.3010502@linutronix.de>
Date: Tue, 11 Jun 2013 18:18:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <20130611142358.GG29135@zurbaran> <51B74252.5090906@linutronix.de> <20130611161054.GJ29135@zurbaran>
In-Reply-To: <20130611161054.GJ29135@zurbaran>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 06:10 PM, Samuel Ortiz wrote:
> Hi Sebastian,

Hi Samuel,

> On Tue, Jun 11, 2013 at 05:29:22PM +0200, Sebastian Andrzej Siewior wrote:
>>> Then, this is a pretty big patchset, with iio, input and mfd all mixed
>>> together and it is likely to create merge conflicts.
>> They somehow depend on each other. Otherwise I would have sent three
>> series, one per subsystem.
> Of course they depend on each other, but the dependency is mostly for
> iio and input to depend on the MFD changes.

Except for the one #18 as mentioned below.

>> Still. There is #18 which reworks the "step addressing" and involves
>> changes in both (iio & input) at the same time.
> Would splitting iio and input break anything there ?

Yes. Once the header files is modified without the two .c files the
driver is not working. To fix this I need another patch making sure
input + iio does not the header files and another to user it (once
everything is merged).

>> There is #21. Adding this to the initial "DT support" patch would be bad
>> I think because it requires some changes on the iio side which have
>> nothing to do with DT. Putting the iio changes before DT would require
>> to make some change to platform-data part which will go away anyway.
> Wouldn't it workif you split this one into an MFD+dts file changes and
> another one for the iio changes ?

It would work in general. The first few DT-iio patches wouldn't make
sense but then why not.

>> So I started collecting ACKs from input and iio to avoid this split. If
>> you really want the split then I will start doing so…
> I think it would be nicer, yes.

Nicer. I see. Please tell me what you think about #1 because I really
would like to drop regmap and then I can start reshuffle the series :)

> 
> Cheers,
> Samuel.
> 

Sebastian
