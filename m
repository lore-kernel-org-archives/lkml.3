Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbbATRL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:11:59 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32774 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbATRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:11:57 -0500
Message-ID: <54BE8C55.5040606@collabora.co.uk>
Date: Tue, 20 Jan 2015 18:11:49 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 5/7] mfd: cros_ec: Instantiate ChromeOS EC character
 device
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-6-git-send-email-javier.martinez@collabora.co.uk> <20150120082013.GU21886@x1> <54BE7C53.8070605@collabora.co.uk> <20150120162952.GB30656@x1> <54BE83FF.7030709@collabora.co.uk> <20150120165527.GH30656@x1>
In-Reply-To: <20150120165527.GH30656@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/20/2015 05:55 PM, Lee Jones wrote:
> On Tue, 20 Jan 2015, Javier Martinez Canillas wrote:
> 
>> Hello Lee,
>> 
>> On 01/20/2015 05:29 PM, Lee Jones wrote:
>> > 
>> > It's not a blocker, but it is a ridiculous name to use inside the
>> > driver/ directory 'cos almost everything is a dev(ice) here.
>> > 
>> 
>> Right, do you think that "cros-ec-chardev" will be a more suitable
>> name? Sorry, I'm really bad at naming things...
> 
> But is it really a chardev?  Don't chardevs usually live in
> drivers/char?  It probably uses a chardev node in /dev, but what does
> it really do?  What information can/will userspace obtain from this
> memory block?
> 

Right, is a driver that register a chardev but mostly to expose an ioctl
interface to send commands to the Embedded Controller from user-space.

The Application Processor communicates with Embedded Controller by sending
commands over an interface. This can be either spi or i2c on ARM (depending
on the Chromebook model) or LPC on x86 Chromebooks so the platform driver
instantiated by the "cros-ec-dev" mfd cell is to allow user-space to send
commands to the Embedded Controller (using the correct transport method).

So this chardev is used by the ectool binary in ChromeOS to communicate
with the Embedded Controller.

The actual driver is located in drivers/platform/chrome/cros_ec_dev.c and
is added by "platform/chrome: Add Chrome OS EC userspace device interface"
[0] in this series.

In the downstream ChromiumOS kernel tree it is located in drivers/mfd but
I moved to drivers/platform/chrome/ since you asked me to find a better
place for it.

Best regards,
Javier

[0]: https://lkml.org/lkml/2015/1/2/81
