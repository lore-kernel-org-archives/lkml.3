Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaDNKhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:37:33 -0400
Received: from rhcavspool01.kulnet.kuleuven.be ([134.58.240.193]:47849 "EHLO
	cavspool01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751003AbaDNKha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:37:30 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 06:37:30 EDT
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: DD4A4128083.A2CF4
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <534BB90B.7030904@thomasmore.be>
Date: Mon, 14 Apr 2014 12:31:39 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@linaro.org>, Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [rfc]pwm: add BCM2835 PWM driver
References: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be>	<CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>	<5344A209.7010507@wwwdotorg.org> <CAAYSxhqv_RLfksBE-n8KMg33v6ZfB4B4E8NQUYf8JsPzVrLYzw@mail.gmail.com>
In-Reply-To: <CAAYSxhqv_RLfksBE-n8KMg33v6ZfB4B4E8NQUYf8JsPzVrLYzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it the responsibility of the pwm driver to handle the pinmux of the 
io pins? Or is the end user, or a parent driver responsible to handle this?
Idem for the clock?


On 04/09/2014 05:59 PM, Tim Kryger wrote:
> On Tue, Apr 8, 2014 at 6:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 04/08/2014 05:02 PM, Tim Kryger wrote:
>>> On Thu, Apr 3, 2014 at 6:44 AM, Bart Tanghe <bart.tanghe@thomasmore.be> wrote:
>>>> need some recommendation
>>>> the memory mapped io registers of the bcm2835 pwm hardware are spreaded
>>>> over the memory mapped io
>>>> gpio config 0x20200004 - clk config 0x201010A0 - pwm configuration 0x2020C000
>>>> to handle this, I've used the base address of the memory mapped io
>>>> so I can use positive offsets
>>> So the registers for this PWM are located in three distinct memory regions?
>> ...
>>>> +struct bcm2835_pwm_chip {
>>>> +       struct pwm_chip chip;
>>>> +       struct device *dev;
>>>> +       int channel;
>>>> +       void __iomem *mmio;
>>> One pointer isn't going to be enough.  You need three.
>>>
>>> I suggest renaming the first and adding two more:
>>>
>>> void __iomem *base_pwm;
>>> void __iomem *base_clk;
>>> void __iomem *base_alt;
>> Sorry, I forgot about this patch. One comment here; the PWM driver can't
>> touch the clock or alt registers; those should be owned by the clock
>> driver, and the driver for whatever alt is (pinmux - don't recall what
>> it's touching there).
> Absolutely.  If these registers are owned by other drivers, go through them.

