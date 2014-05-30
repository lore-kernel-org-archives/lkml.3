Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbaE3NeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:34:15 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:50542 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbaE3NeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:34:11 -0400
Date: Fri, 30 May 2014 14:34:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
Message-ID: <20140530133405.GB29731@lee--X1>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
 <1401452797-29521-2-git-send-email-lee.jones@linaro.org>
 <20140530123656.GC2742@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140530123656.GC2742@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Currently the I2C framework insists on devices supplying an I2C ID
> > table.  Many of the devices which do so unnecessarily adding quite a
> > few wasted lines to kernel code.  This patch allows drivers a means
> > to 'not' supply the aforementioned table and match on either DT
> > and/or ACPI match tables instead.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Sadly, it is not that easy...
> 
> > +	/*
> > +	 * An I2C ID table is not madatory, if and only if, a suitable Device
> > +	 * Tree and/or ACPI match table entry is supplied for the probing
> > +	 * device.
> > +	 */
> 
> That means we end up with drivers which cannot be used for run-time
> instantiation via the 'new_device'-file in sysfs. I don't like that.

I've found the code and taken a quick look at it.  I'm still not sure
I understand your point.  The semantics for any device attempting to
register with an I2C ID table should be unchanged.  The only intended
difference would be for drivers which do not wish to supply one due
to the fact that they have other means of matching, namely DT and
ACPI.

Would you mind telling me what I have changed that affects drivers
registering via Sysfs?
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
