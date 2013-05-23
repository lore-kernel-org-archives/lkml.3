Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3EWH4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:56:48 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42595 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3EWH4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
	<1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
Date: Thu, 23 May 2013 09:56:46 +0200
Message-ID: <CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
From: Linus Walleij <linus.walleij@linaro.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@ardb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 3:35 PM, Oliver Schinagl
<oliver+list@schinagl.nl> wrote:

(...)
> While initially these fuses are used to somewhat determin the chipID, these
> appear to be writeable by the user and thus can be used for other purpouses.
> For example storing a 128 bit root key, a unique serial number, which could
> then even be used as a MAC address.
(...)
Then follows some code to read out the keys from sysfs I guess..
> +static int __init sid_probe(struct platform_device *pdev)

It's really simple to actually make the kernel use this to seed the
entropy pool.

#include <linux/random.h>
add_device_randomness(u8 *, num);

If you know after probe that you can read out a number of bytes
of device-unique data, I think you should add those bytes to the
entropy pool like this.

Yours,
Linus Walleij
