Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaLBNar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:30:47 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:59905 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbaLBNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141202131611.GC4072@katana>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
	<1417514749-24319-4-git-send-email-harinik@xilinx.com>
	<20141202111907.GC23671@leverpostej>
	<CAFcVECLtPx6shBXJbg9Uf_8fnhkMoO1zpoxGcdda7PSA7z_2rA@mail.gmail.com>
	<20141202125203.GA4072@katana>
	<CAFcVECJwFoFd6GrmF282CG+fELnYb=FNCTDq=RYKky_dHha=Jg@mail.gmail.com>
	<20141202131611.GC4072@katana>
Date: Tue, 2 Dec 2014 19:00:40 +0530
Message-ID: <CAFcVECKMqACtumHZGHbToUUSjd_dWCcLbu=_ZjNnnGdAZQ_3fg@mail.gmail.com>
Subject: Re: [PATCH 3/4] devicetree: bindings: Add defeature-repeated-start
 property for Cadence I2C
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 2, 2014 at 6:46 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> But given the bugs, it will be useful to just disable it if the system doesn't
>> require repeated start.
>
> What do you do when disable repeated start? Sending STOP and START? If
> so, this is really something different than repeated start. By using
> I2C_FUNC_I2C a user expects repeated start, so if the HW does not
> support it, we should say so and don't try to emulate it with something
> different.
>

Yes, we send stop.
Using repeated start, when number of messages passed > 1, HOLD bit is set
by the driver. This is an indication to the controller not to send a STOP.
If we disable repeated start, the driver will not set HOLD bit.
All the messages are sent but with START and a STOP for each of them.

Regards,
Harini
