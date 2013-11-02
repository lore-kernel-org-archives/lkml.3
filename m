Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3KBTk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:40:57 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:36152 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3KBTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:40:54 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-7b-527555451820
Date: Sat, 02 Nov 2013 17:40:47 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [kconfig] update: results of some syntactical checks
Message-id: <20131102174047.70c24ed8@samsung.com>
In-reply-to: <1383420054.4378.3.camel@x220.thuisdomein>
References: <3513955.N5RNgL3hPx@tacticalops>
 <1383420054.4378.3.camel@x220.thuisdomein>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/hEF3X0NIggz+zhS32nPnFbtG8eD2b
	xe6f81gtLu+aw2bRs2Erq8WiW2eYLRqeOTmwe9zbd5jFY//cNewe02YdZfTYuP0Jk8fnTXIe
	t59tYwlgi+KySUnNySxLLdK3S+DKeNr5j6VgM1fFpXevGRsY53N0MXJySAiYSKx79psVwhaT
	uHBvPVsXIxeHkMASRolD2/ezQjg9TBKfOi6xdzFycLAIqEq8vV8N0sAmYCTxqrEFrFlEQFmi
	dfM9dhCbWeAeo8T1SfYgtrCAo8SN7ZeZQWxeAUOJ2csfsoHYnALmEiuWTQOLCwlESly7PpsV
	ZLyEgJPE7gNSEOWCEj8m32OBGKklsXlbEyuELS+xec1b5gmMArOQlM1CUjYLSdkCRuZVjKKl
	xckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGhXryD8cUGq0OMAhyMSjy8H3hKgoRYE8uKK3MPMUpw
	MCuJ8Mr5lQYJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYJxTWC5V/W+vwWItXmHTua/Ta6XXicyY
	4HWwjrV3oU/eBlOFCf5T/nEe3zlrSpL0FiWB7fLRIj01ciZTdb63bowXYds0I9TI2kN3zpqn
	L46/KDI7JtddLntrOYvRL7u7HVOf12zOUDCa7hVQ7Mvl9uK0EI/cy27TvsIUzwtlW2sOXsq4
	xfzCVYmlOCPRUIu5qDgRAE73lv5TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 02 Nov 2013 20:20:54 +0100
Paul Bolle <pebolle@tiscali.nl> escreveu:

> On Sun, 2013-10-20 at 00:03 +0200, Martin Walch wrote:
> > drivers/media/common/siano/Kconfig:21-26
> > > config SMS_SIANO_DEBUGFS
> > >	bool "Enable debugfs for smsdvb"
> > >	depends on SMS_SIANO_MDTV
> > >	depends on DEBUG_FS
> > >	depends on SMS_USB_DRV
> > >	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
> > 
> > The last line adds the dependency CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV.
> > This expression does not look sound as those two symbols are not declared
> > anywhere. So, the two strings CONFIG_SMS_USB_DRV and CONFIG_SMS_SDIO_DRV
> > are compared, yielding always 'n'. As a result, SMS_SIANO_DEBUGFS will never
> > be enabled.
> 
> Those are obvious typos. Still present in v3.12-rc7. Perhaps you'd like
> to send the trivial patch to fix this?

Yes, it is a typo...

> 
> > Probably, it was meant to say something like
> > >	depends on SMS_USB_DRV = SMS_SDIO_DRV

But this is not the right thing to do. The Kconfig logic here is that it
should depends on !SMS_SDIO_DRV or SMS_USB_DRV = SMS_SDIO_DRV.

I remember I made a patch like that while testing some things with this
driver, but it seems that I forgot to push. I might have it somewhere on
my test machine.



-- 

Cheers,
Mauro
