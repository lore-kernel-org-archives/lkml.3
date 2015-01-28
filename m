Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbbA1Vqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:46:48 -0500
Received: from smtp3.ore.mailhop.org ([54.149.88.251]:54202 "EHLO
	smtp3.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbbA1UfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:05 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1+P5y+BXwI4ri8G1ZX5OJ79
Date: Wed, 28 Jan 2015 09:09:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        george.cherian@ti.com, nsekhar@ti.com,
        devicetree <devicetree@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] extcon: usb-gpio: Introduce gpio usb extcon driver
Message-ID: <20150128170954.GQ28663@atomide.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
 <1422274532-9488-2-git-send-email-rogerq@ti.com>
 <CAGTfZH3nmpUGgFJ6RU+xH8tuDkGBFA-NbXWa0CSXZXR+DXrbkQ@mail.gmail.com>
 <54C66B0D.9040109@ti.com>
 <54C6EFC8.1090601@samsung.com>
 <54C7B0E5.20101@ti.com>
 <54C8472B.6070302@samsung.com>
 <54C8D238.4080001@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C8D238.4080001@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [150128 04:15]:
> On 28/01/15 04:19, Chanwoo Choi wrote:
> >>
> >> I still fail to understand that we need to call disable_irq() in .suspend() and
> >> enable_irq() in .resume()
> >>
> >> can you point me to any other drivers doing so?
> > 
> > You can refer the suspend function in drivers/mfd/max14577.c or drivers/mfd/max77693.c.
> > The max14577_suspend() includes the detailed comment for why using disable_irq() in suspend function.
> > 
> > In max14577 case, max14577_suspend() use disable_irq() function because of i2c dependency.
> > If max14577 device is wake-up from suspend state before completing the resume sequence
> > of i2c, max14577 may fail to read/write i2c communication.
> 
> Thanks for this information. I will add disable/enable_irq() in suspend/resume().

Are the .dts changes safe for me to apply already?

Regards,

Tony
