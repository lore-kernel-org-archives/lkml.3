Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaFBMRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:17:04 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61799 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFBMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140531134805.GA3287@katana>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
	<1401452797-29521-2-git-send-email-lee.jones@linaro.org>
	<20140530123656.GC2742@katana>
	<20140530133405.GB29731@lee--X1>
	<20140530174800.GA4917@katana>
	<20140530192516.GA4319@lee--X1>
	<20140531134805.GA3287@katana>
Date: Mon, 2 Jun 2014 14:16:59 +0200
Message-ID: <CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 3:48 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> Right, I read the function which provides the functionality, but my
>> point is; I don't think my patch changes the semantics in a way which
>> would adversely affect this option.  If you think that it does, can you
>> specify how please?
>
> Currently, if a driver would be DT only and does not provide a seperate
> i2c_device_id table, then the driver is unusable with method 4. I don't
> like to have some drivers being capable of it and some not.
>
>> Does the sysfs method create a i2c_device_id table?  If not, how does
>> it probe successfully pre-patch?
>
> The sysfs method creates a device. Its name is matched against
> i2c_device_ids only since it does not have a node pointer for DT to be
> matched against.

Is this really so useful on embedded systems?

I was under the impression that this method was something used
on say PC desktops with temperature monitors and EEPROMs
on some I2C link on the PCB, usage entirely optional and fun
for userspace hacks.

And when we say "people use it" do we mean "sensors-detect
uses it, on desktops", really?

Yours,
Linus Walleij
