Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaFIWRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:17:14 -0400
Received: from mout.perfora.net ([74.208.4.194]:62768 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbaFIWRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:17:12 -0400
Message-ID: <5396322D.6030003@ziswiler.com>
Date: Tue, 10 Jun 2014 00:16:13 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com> <538CA24B.1010602@wwwdotorg.org> <538CA635.4050502@ziswiler.com> <20140602221627.GP31751@sirena.org.uk> <538D64FD.2010909@ziswiler.com> <20140603094537.GQ31751@sirena.org.uk> <538EBACB.70100@ziswiler.com> <20140604111755.GG2520@sirena.org.uk>
In-Reply-To: <20140604111755.GG2520@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:d3O+q4OcCRySPhh71ndLIfKNglFqytYa0nockXYFjir
 +QAVQCHcvAm/4SBpZcNMFrdS/w51JbXENROAG6LvRcFwLqVK7z
 DnoEO9CH/JF+noO3DUmQsHMuE3cF5j6MKYbeTbZ6OLxejxmHuw
 OjfqFxjU9M8SL3gAh4d1Fa2Vvze9s1wPzyk9ZZBq9XMH03gWhd
 0t+EAD9PmTwMrfK+UzeAUDk3hUioNeyqWzqUFASablJiQfJk71
 i8ZGFalBFXTswWCNNzM1ijVhBdO4zFimMzWDonw1oW92Pp7NDv
 NekEFGhEaBxXC33nL1GIo7/+Jri5DWkOflLMv6puq/2pLHZuqH
 UwIygNRdbihcNPCZ/7gU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 01:17 PM, Mark Brown wrote:
> You're saying you're controlling it from userspace.  This is a
> particular detail of what you are doing in your system.  You happen to
> want to control the devices you are hanging off the system with
> userspace drivers but that's just what you're doing right now.

Sorry, I don't get it. Yes, spidev is to control stuff from user space 
just like i2c-dev however bad that might sound.

> No, that's in the controller node - the chip selects are described
> there.  The child node references a chip select number that the master
> has and describes what's connected to that chip select.

Well, unfortunately SPI without any chip select is just plain simply 
useless. It won't work.

> It's a perfectly fine way of controlling things from userspace if that's
> a sensible way of controlling devices but that does not mean you should
> describe it in the device tree in that fashion.

Only that without describing such a chip select in the device tree 
spidev won't ever work.

I don't see us reaching any consensus here therefore I retreat. I will 
re-submit the whole thing without spidev however sad having to see that 
useful feature being dropped.
