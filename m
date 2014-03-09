Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaCIXZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 19:25:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40287 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaCIXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 19:25:34 -0400
Message-ID: <531CF864.9040406@gmail.com>
Date: Mon, 10 Mar 2014 00:25:24 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: David Miller <davem@davemloft.net>
CC: rob@landley.net, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com> <1394192092-27461-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140309.191235.1047481546773873653.davem@davemloft.net>
In-Reply-To: <20140309.191235.1047481546773873653.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 12:12 AM, David Miller wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Date: Fri,  7 Mar 2014 12:34:52 +0100
>
>> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
>>    ("net: phy: resume/suspend PHYs on attach/detach")
>> introduced a feature to suspend PHYs when entering halted state.
>>
>> Unfortunately, not all bootloaders properly power-up PHYs on reset
>> and fail to access ethernet because the PHY is still powered down.
>>
>> Therefore, this adds code and documentation for a sysfs attribute to
>> allow/deny PHYs to be suspended on a per-PHY basis. Disabling that
>> attribute prevents PHYs from being suspended when entering halted state.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Reported-by: Andrew Lunn <andrew@lunn.ch>
>
> I know you won't like what I have to say, but I want to see a solution
> without this sysfs knob.
>
> First of all, you obviously have a way to end up having the sysfs knob
> get set on the appropriate systems.
>
> Therefore, you obviously have some way to propagate the same piece of
> information into the kernel somehow during boot time.
>
> For example, via a device tree property or similar.

There is no way to determine if a bootloader is broken or not. The
sysfs knob allows to provide a use case based decision. Of course, we
can invent some freaky device tree property but that the DT maintainers
will not like either.

This is not an issue with broken HW but SW. The PHY is fine, you can
suspend and resume it perfectly in Linux. But the bootloader fails to
properly initialize it on a warm boot. You could update the bootloader
and the issue disappears.

> Please pursue an avenue such as that.  This sysfs thing, it's a user
> facing interface we'd have to live with forever.

If you want me to try a devicetree property for the issue, we also
create ABI and we will have to live with it forever.

I am open for suggestions, but I have a bad feeling about a "broken
bootloader" DT property.

Sebastian
