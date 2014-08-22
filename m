Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaHVPnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:43:21 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37103 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaHVPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:43:19 -0400
X-AuditID: cbfec372-b7f2f6d0000052b3-41-53f76515ef5e
Date: Fri, 22 Aug 2014 10:43:08 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Autoselecting SPI for MEDIA_SUBDRV_AUTOSELECT?
Message-id: <20140822104308.63767b6a.m.chehab@samsung.com>
In-reply-to: <53F75F02.2030300@iki.fi>
References: <53F75B26.2020101@suse.com> <53F75F02.2030300@iki.fi>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/hYF3R1O/BBj9nGll8b37PZnFnzWdW
	i8u75rBZ9GzYyurA4nH460IWj/VbrrJ4fN4kF8AcxWWTkpqTWZZapG+XwJWx8rd4QTNPxYe9
	N5kaGLdxdjFyckgImEjs+HKTHcIWk7hwbz1bFyMXh5DAEkaJtXsfMUM4zUwSq7f2AFVxcLAI
	qEq039cCaWATMJJ41djCCmKLCChJLNiwkwmknlmgiVHiz6NLzCAJYQFriZ0PVjKC2LwCVhJL
	D60G28YpoCZxuHcPWFxIwFHi5LKnjBBXOEv8nDkJql5Q4sfkeywgNrOAlsTmbU2sELa8xOY1
	b5knMArMQlI2C0nZLCRlCxiZVzGKlhYnFxQnpeca6hUn5haX5qXrJefnbmKEhGzRDsZnG6wO
	MQpwMCrx8Bp4fA8WYk0sK67MPcQowcGsJMI71wYoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHu
	w2enP6vCrrus8rngqqJZnDVfyXCLyRv5M/cC7/DOS8/fp2C41JKj6fe8DxffL0r/sPLVa9uA
	Un7DoolZ3I+TWjLs5gUbtfZ9KXXJP7TRN1cn69DE/w4+93s5NiQqz5vx/ZxVrvDPPFa2xvN1
	y65pMM1/oFzHmHt9+aJ56720HSu7l56Z8UaJpTgj0VCLuag4EQBt2g1CNwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 Aug 2014 18:17:22 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka!
> 
> On 08/22/2014 06:00 PM, Jeff Mahoney wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Hi Antti -
> >
> > Commit e4462ffc160 ([media] Kconfig: sub-driver auto-select SPI bus)
> > enables CONFIG_SPI globally for a driver that won't even be enabled in
> > many cases.
> >
> > Is there a reason USB_MSI2500 doesn't select SPI instead of
> > MEDIA_SUBDRV_AUTOSELECT?
> 
> Nothing but I decided to set it similarly as I2C, another more common 
> bus. IIRC same was for I2C_MUX too.
> 
> You could still disable media subdriver autoselect and then disable SPI 
> and select all the media drivers (excluding MSSi2500) manually.
> 
> I have feeling that media auto-select was added to select everything 
> needed for media.

No. Actually, it is meant to be used to select the features that are
needed for the devices that got selected.

Selecting I2C there is already a hack, as there are a couple of devices
that don't need it (like as102). Still, we're doing that, as there are
so few exceptions that, for the sake of cleaner Kconfig setup, it is
the best solution.

I2C_MUX is also a little of abuse today, as there are also few devices
that use it, but we should change it, as there are some good reasons
to stop using the current I2C gate control by an i2c_mux.

I don't think that selecting SPI belongs there. The best is to move it
to the very few drivers that use it.

Regards,
Mauro
