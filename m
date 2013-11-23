Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3KWRpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 12:45:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59305 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3KWRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 12:45:38 -0500
Message-ID: <5290F815.10102@kernel.org>
Date: Sat, 23 Nov 2013 18:46:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Mark Rutland <mark.rutland@arm.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] itg3200: add dt support.
References: <20131101154854.2d7d1432@notabene.brown>	<20131118115742.GG30853@e106331-lin.cambridge.arm.com> <20131119095625.1fc4f66f@notabene.brown>
In-Reply-To: <20131119095625.1fc4f66f@notabene.brown>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/13 22:56, NeilBrown wrote:
> On Mon, 18 Nov 2013 11:57:42 +0000 Mark Rutland <mark.rutland@arm.com> wrote:
> 
>> On Fri, Nov 01, 2013 at 04:48:54AM +0000, NeilBrown wrote:
>>> 
>>> 
>>> No new configuration, just a 'compatible' string and documentation.
>>> 
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>> 
>>> diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
>>> b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt new file mode 100644 index 000000000000..4581620632df 
>>> --- /dev/null +++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt @@ -0,0 +1,20 @@ +* InvenSense
>>> ITG3200 3-axis gyroscope + +Required properties: + +  - compatible : "invensense,itg3200" +  - reg : I2C
>>> address, typically 0x68 + +Optional properties: + +  - interrupt-parent : should be the phandle for the
>>> interrupt controller +  - interrupts : interrupt mapping for GPIO IRQ
>> 
>> Why is this a "GPIO IRQ"? This device das no GPIO. The fact that it might be wired to a GPIO controller has
>> nothing to do with the ITG3200, and shouldn't be a concern of its binding.
>> 
> 
> You are of course correct.  I'll resubmit with that word removed.
> 
> I probably copied it from bma180.txt without thinking.
> 
> /home/git/linux$ git grep 'GPIO IRQ' Documentation/devicetree/bindings/ 
> Documentation/devicetree/bindings/gpio/8xxx_gpio.txt: - interrupts : Interrupt mapping for GPIO IRQ. 
> Documentation/devicetree/bindings/gpio/gpio-xilinx.txt:- interrupts : Interrupt mapping for GPIO IRQ. 
> Documentation/devicetree/bindings/gpio/pl061-gpio.txt:- interrupts : Interrupt mapping for GPIO IRQ. 
> Documentation/devicetree/bindings/iio/accel/bma180.txt:  - interrupts : interrupt mapping for GPIO IRQ, it should
> by configured wi Documentation/devicetree/bindings/iio/light/apds9300.txt:  - interrupts : interrupt mapping for
> GPIO IRQ
> 
> Both bma180.txt and apds9300.txt seem to use the phrase "GPIO IRQ" inappropriately.
Fixes are always welcome ;)

Jonathan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSkPgVAAoJEFSFNJnE9BaI2HwQALgU62ckBDUiDCxImT7vfdRC
ey6YP5REWO+J8igW6pvjq+mElj2QjQcnbKbuGbEsEFM5f1tZ8+udjsJ0teZyyO30
+P42S6UsGuGEru3KBwU/m46aASYOtKiTeRcYsOq+DGM8DixTDDtRU7tlIwCA11tJ
49SH4aK0T8ktV2Cu4184TkoWNOhHdd1Qwbc8K2xQqxO94t/xgXXCLJe6trKZFC7A
5jQwex+wZnJcxEduSN5LJgi1BqgXIUzoImVZyyZ2nxaVhHPJld5a4VCAGTcaBYLf
jZQYOp1LstS3/Rx1KcKRMyPt0y9j58ZpmP/rGbX3jrKmg0WL5hq9HP53BXdXTpOu
fXilORCDqdf4g2n2pRO+UONE3foVfXPlYfxYQ1KxIVIZNptYEUE5cvKQA7Oafl42
kUpQPbgdnq8Jlnh2+HalxN8Wn0oav3Iljugya+HSjJnnt/TLUxM3bwn84rA3qae7
kbmvzA2ag8CS01dLVu7tGOGthFiV2DAosIVbdFiyPBdS0rFM8QVa2s/oVJr5UyBt
2d/VYOPwSYJbWwMSRM/zdrpRKiXBtpiYsR6aqFWu9vuploaW7i29P6YB7h69+CYw
lLVw8uIYuH+6FIlD/tbhmmKLPo6gMPCVrS7/qQWmzoyT6eKnX5Ys+N8kH6NVA2iS
UeJ82ZYn2sWcuriM17W1
=msEy
-----END PGP SIGNATURE-----
