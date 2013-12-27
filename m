Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3L0KRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:17:39 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38841 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3L0KRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:17:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131227063843.GA3310@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
	<20131227051843.GA840@kroah.com>
	<CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
	<20131227063843.GA3310@kroah.com>
Date: Fri, 27 Dec 2013 15:47:31 +0530
Message-ID: <CAHbNUh0NBVEBJbSG7UWgnHbORgbKCrA_74=jiArSvv5jaFk1SQ@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Remove hard-coded major/minor numbers
From: Tushar Behera <tushar.behera@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-serial <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, jslaby <jslaby@suse.cz>,
        Patch Tracking <patches@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ben@simtec.co.uk, Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, heiko <heiko@sntech.de>,
        Kgene Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 December 2013 12:08, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 27, 2013 at 12:00:20PM +0530, Tushar Behera wrote:
>> On 27 December 2013 10:48, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:

[ ... ]

>> >> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
>> >>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
>> >>       .cons           = S3C24XX_SERIAL_CONSOLE,
>> >>       .dev_name       = S3C24XX_SERIAL_NAME,
>> >> -     .major          = S3C24XX_SERIAL_MAJOR,
>> >> -     .minor          = S3C24XX_SERIAL_MINOR,
>> >
>> > Doesn't this break existing systems and configurations that are
>> > expecting 204:64 as the location of this serial port?
>> >
>>
>> I tested this on Exynos4210-Origen, Exynos5250-Arndale board, it works
>> fine there. I haven't tested on any older boards.
>
> How did it work?  You are relying on some userspace tools to do this
> properly, right?  What about systems without those specific tools?
>

Enabling CONFIG_DEVTMPFS, all the /dev/ttySAC<n> nodes are generated
and the appropriate console is specified through command line
argument.

>> > Why change this one and not the amba-pl011 driver?
>> >
>>
>> I could only test this driver, so thought of changing this rather than
>> modifying amba-pl011 driver. I don't have any other reason.
>
> Please get the samsung driver maintainer to agree with this and sign off
> on it before trying to get it merged again.
>
> greg k-h

Adding a few other developers who have contributed to this file or are
working on different Samsung platforms to get an ack/sign-off.

-- 
Tushar Behera
