Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3E0RMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:12:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3E0RMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:12:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to PWM framework
Date: Mon, 27 May 2013 19:12:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
References: <201305241619.52328.hartleys@visionengravers.com> <201305271720.08146.arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F0021DA666D43D@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DA666D43D@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271912.08882.arnd@arndb.de>
X-Provags-ID: V02:K0:koCNs7LOeuKBfKNJFMfV7yj2OuhJm3yQQxFYLbaf7XL
 LadKAKnGlF7CTQE42XsrnqPLdpqiuUW9d4HLfQav5SGrmEOyR5
 PLcXKUKp26+demC0wew+0Ut/Tkdet8MOtTOsCbfnETr8NG6XFT
 VQ9qg/AWAWqDTXV7maEYXYijOHfw5+fx4keE3TWazjUmYxV0Zy
 o25zuUDWoDmSAsyFHEQF77iqWSI6YdZntQ+Wzf2xGACqYX2Jhc
 HfYN+HFl8tny3PR2vzaXpDLsHSADqMd0yr+K0blUVx9Nyd/LR7
 hMt8JZo2x3t3mL1ESVlGVry9uTKxygIHLkYO25Wi7gMxPEaXjh
 h7GYQYS18n1p+GQm+vCY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, H Hartley Sweeten wrote:
> Ryan Mallon has also provided a Reviewed-by for this series.
> 
> Will you be the one that merges this? I would like it to be in linux-next
> before I convert it to the PWM framework.

While Greg and I are both maintainers for drivers/misc, he is the one who
actually has a git tree for it, so he would merge it.

However, I think it would be better to just merge it all through the pwm
tree. Your current series is good, and with my Ack I see no problem to
just do the conversion to pwm on top and send a pull request for all of
it to Thierry.

> Also, I have a question about the conversion.
> 
> If I strip the sysfs support out of this driver the conversion is quite simple.
> But, my use for this driver requires user space control of the PWM.
> 
> Should I:
> 1) convert the driver to the PWM framework and leave the sysfs stuff in it
> 2) work out a generic sysfs support for the PWM framework and then
>     convert the driver
> 3) other...
>
> I've been looking at 2) by doing something like how gpiolib does it. Do
> you think that would be acceptable?

That would be for Thierry to decide. It does sound better to me than the 1)
and I don't have a better idea for 3).

I wonder how the arbitration between in-kernel and user-space consumers
of the pwm lines would work though.

	Arnd
