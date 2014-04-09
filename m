Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbaDIBfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:35:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbaDIBfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:35:20 -0400
Message-ID: <5344A209.7010507@wwwdotorg.org>
Date: Tue, 08 Apr 2014 19:27:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@linaro.org>,
        Bart Tanghe <bart.tanghe@thomasmore.be>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [rfc]pwm: add BCM2835 PWM driver
References: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be> <CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>
In-Reply-To: <CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 05:02 PM, Tim Kryger wrote:
> On Thu, Apr 3, 2014 at 6:44 AM, Bart Tanghe <bart.tanghe@thomasmore.be> wrote:
>> need some recommendation
>> the memory mapped io registers of the bcm2835 pwm hardware are spreaded
>> over the memory mapped io
>> gpio config 0x20200004 - clk config 0x201010A0 - pwm configuration 0x2020C000
>> to handle this, I've used the base address of the memory mapped io
>> so I can use positive offsets
> 
> So the registers for this PWM are located in three distinct memory regions?
...
>> +struct bcm2835_pwm_chip {
>> +       struct pwm_chip chip;
>> +       struct device *dev;
>> +       int channel;
>> +       void __iomem *mmio;
> 
> One pointer isn't going to be enough.  You need three.
> 
> I suggest renaming the first and adding two more:
> 
> void __iomem *base_pwm;
> void __iomem *base_clk;
> void __iomem *base_alt;

Sorry, I forgot about this patch. One comment here; the PWM driver can't
touch the clock or alt registers; those should be owned by the clock
driver, and the driver for whatever alt is (pinmux - don't recall what
it's touching there).
