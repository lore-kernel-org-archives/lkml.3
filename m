Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3H1DzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 23:55:25 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53153 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3H1DzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 23:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130827184447.GR3005@radagast>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
	<20130710052534.GB15674@arwen.pp.htv.fi>
	<CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
	<20130712065734.GE31802@arwen.pp.htv.fi>
	<CAHbNUh0Sa-atYMHbhEUX2vnVAcsdBJxw9RRzAp+6vqE8hi=p1w@mail.gmail.com>
	<20130827184447.GR3005@radagast>
Date: Wed, 28 Aug 2013 09:25:22 +0530
Message-ID: <CAHbNUh06Rxd9JRieeXCydB_JwiUOrUXADL6nUGZxONQJmz2-CQ@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
From: Tushar Behera <tushar.behera@linaro.org>
To: balbi@ti.com
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 00:14, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 13, 2013 at 02:11:27PM +0530, Tushar Behera wrote:
>> On 12 July 2013 12:27, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Wed, Jul 10, 2013 at 10:42:27AM -0700, Julius Werner wrote:
>> >> Hi Felipe,
>> >>
>> >> This is intended to pull down a reset signal line, not to switch power
>> >> to the device. I could implement that with the regulator framework
>> >> too, but I think that would just be confusing and harder to understand
>> >> without providing any benefit. It's really just a plain old GPIO.
>> >
>> > alright, in that case how about using drivers/reset/ ?
>> >
>>
>> IIUC, reset-gpio driver only provides APIs for reset controls (reset,
>> assert, deassert). We still need to find out the location from where
>> we would be calling the reset function.
>
> that's fair, but at least you reuse a bunch of boilerplate code to claim
> the GPIO, set proper direction and value. No need to duplicate that in
> your driver.
>

SMSC3503 driver code was recently updated by Mark Brown [1] which
allows the device to work even if it is not connected to I2C bus. The
timing is still an issue though [2]. With this USB works on
linux-next, but surely that [2] is not the solution.

[1] http://comments.gmane.org/gmane.linux.usb.general/92061
[2] https://lkml.org/lkml/2013/8/14/814
-- 
Tushar Behera
