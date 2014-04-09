Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbaDIP7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:59:30 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:59607 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934005AbaDIP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <5344A209.7010507@wwwdotorg.org>
References: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be>
	<CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>
	<5344A209.7010507@wwwdotorg.org>
Date: Wed, 9 Apr 2014 08:59:21 -0700
Message-ID: <CAAYSxhqv_RLfksBE-n8KMg33v6ZfB4B4E8NQUYf8JsPzVrLYzw@mail.gmail.com>
Subject: Re: [rfc]pwm: add BCM2835 PWM driver
From: Tim Kryger <tim.kryger@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 6:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/08/2014 05:02 PM, Tim Kryger wrote:
>> On Thu, Apr 3, 2014 at 6:44 AM, Bart Tanghe <bart.tanghe@thomasmore.be> wrote:
>>> need some recommendation
>>> the memory mapped io registers of the bcm2835 pwm hardware are spreaded
>>> over the memory mapped io
>>> gpio config 0x20200004 - clk config 0x201010A0 - pwm configuration 0x2020C000
>>> to handle this, I've used the base address of the memory mapped io
>>> so I can use positive offsets
>>
>> So the registers for this PWM are located in three distinct memory regions?
> ...
>>> +struct bcm2835_pwm_chip {
>>> +       struct pwm_chip chip;
>>> +       struct device *dev;
>>> +       int channel;
>>> +       void __iomem *mmio;
>>
>> One pointer isn't going to be enough.  You need three.
>>
>> I suggest renaming the first and adding two more:
>>
>> void __iomem *base_pwm;
>> void __iomem *base_clk;
>> void __iomem *base_alt;
>
> Sorry, I forgot about this patch. One comment here; the PWM driver can't
> touch the clock or alt registers; those should be owned by the clock
> driver, and the driver for whatever alt is (pinmux - don't recall what
> it's touching there).

Absolutely.  If these registers are owned by other drivers, go through them.
