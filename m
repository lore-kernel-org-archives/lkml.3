Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaFCGDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:03:31 -0400
Received: from mout.perfora.net ([74.208.4.194]:55350 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbaFCGD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:03:28 -0400
Message-ID: <538D64FD.2010909@ziswiler.com>
Date: Tue, 03 Jun 2014 08:02:37 +0200
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
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com> <538CA24B.1010602@wwwdotorg.org> <538CA635.4050502@ziswiler.com> <20140602221627.GP31751@sirena.org.uk>
In-Reply-To: <20140602221627.GP31751@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:y0KoFeZwnFpPTF2cZK8FRrZrDSnJIYxBjja1GfWe0VB
 o9F+HHs4o/ewZPsb9b//7YeyEYGYS5oE9RRRHm+JSihyIC+lNb
 HTOISEkDpAXgJuKU1fps+veJD52RjQT1eBtSZWvkXhhzAtg3Tq
 yfyCIcJEhK/z5STNPtZ8ZIQEhUhytcIHVtSvJm1vptKoZM+HDJ
 L+BW//r+qOSQ624fsleGx/9hRRC3ZW+yDs6ZDmI3GKvRjqxr1T
 9EhKIP+nlFqR/hzjy9mWFJwe88kUvnoPm7MlkRv2frxw1BpOLE
 WOwiIz6KvR6BVydkY+EfzWrf+Y41Fis6GQof6sejQEoSFaGyxo
 VB0s5naEUGuFVQQBUJeg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 12:16 AM, Mark Brown wrote:
> On Mon, Jun 02, 2014 at 06:28:37PM +0200, Marcel Ziswiler wrote:
>> On 06/02/2014 06:11 PM, Stephen Warren wrote:
>
>>>> +CONFIG_SPI_SPIDEV=y
>
>>> Is this useful with DT? I thought that unlike I2C_CHARDEV, spidev needed
>>> dummy devices to exist in DT for spidev to work? If so, there's not much
>>> point adding the option to defconfig, since people can add it when they
>>> put the dummy devices into DT.
>
>> Yes, the Apalis T30 DT I sent actually contains two of them which we call
>> generic Apalis SPI1 and SPI2 out-of-the-box configured for exactly that.
>> Without the config enabled though it probably does not make much sense to
>> include it in the DT so I would consider removing it again.
>
> Your DT is broken if it's got a "spidev" node in it, you should be
> describing the hardware not the Linux implementation of the software.
> It would be really nice if we had a good way of handling this but we
> don't yet.

I strongly disagree, it almost perfectly describes the hardware. Unlike 
on I2c where modelling a bus is enough to allow generic user space 
access unfortunately on SPI this is not enough as it requires a specific 
chip-select as well. This is exactly what spidev does and maps to our 
hardware perfectly which has one dedicated chip-select per SPI bus on a 
dedicated header which allows our customers out-of-the-box spidev user 
space access to almost any SPI device connected to those buses just like 
with i2c-devs on I2C buses.
