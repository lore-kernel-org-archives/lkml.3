Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBEPSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:18:35 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:58171 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaBEPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:18:32 -0500
Date: Wed, 5 Feb 2014 10:18:26 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/6] i2c: bcm-kona: register with subsys_initcall
Message-ID: <20140205151826.GC22153@beef>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-2-git-send-email-mporter@linaro.org>
 <20140205090818.GA2614@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205090818.GA2614@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:08:18AM +0100, Wolfram Sang wrote:
> On Tue, Feb 04, 2014 at 07:19:07AM -0500, Matt Porter wrote:
> 
> > Voltage regulators are needed very early due to deferred probe
> > being incompatible with built-in USB gadget drivers.
> 
> What does it need to fix those instead?

[added Alan/Felipe for more insight]

Discussion on that topic came about from this submission:
http://www.spinics.net/lists/linux-usb/msg94217.html

End of it is:
http://www.spinics.net/lists/linux-usb/msg94731.html

We can either add to the many drivers that already do subsys_initcall()
for similar reasons...or I can drop this from the series and add gadget
probe ordering to my TODO list.

In short, it can't be a late_initcall() hack like the original post and
really could be solved by converting to a real bus (and letting
deferred probe do its job)..but Alan voiced concerns about that.

-Matt
