Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaIXR3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:29:33 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:55148 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaIXR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:29:32 -0400
Date: Wed, 24 Sep 2014 17:28:36 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] usb: core: log more general message on malformed
 LANGID descriptor
In-Reply-To: <20140924052759.GB20986@kroah.com>
Message-ID: <alpine.DEB.2.11.1409241632160.2600@localhost.localdomain>
References: <alpine.DEB.2.11.1409232013320.2145@localhost.localdomain> <20140924052759.GB20986@kroah.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Greg Kroah-Hartman wrote:

> On Tue, Sep 23, 2014 at 10:28:49PM +0000, Scot Doyle wrote:
>> I'd like to change this error message:
>> [    3.325837] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409
>>
>> into an error message followed by a debug message:
>> [    3.324726] usb 1-4: malformed string descriptor; unknown language, defaulting to English
>> [    3.327514] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409
>>
>> in order to communicate more information from the log itself. Are there
>> any problems with this approach? Would it be better to put all the
>> information on a single line? Something else?
>
> How about just one line, why two?
>
> And something like "device not implementing langid specifier, defaulting
> to English", but cleaned up to sound a bit better?

That sounds good, I plan to submit this patch tomorrow unless anyone 
prefers different wording.

---
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 0c8a7fc..5317081 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -770,9 +770,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
 		dev->string_langid = 0x0409;
 		dev->have_langid = 1;
 		dev_err(&dev->dev,
-			"string descriptor 0 malformed (err = %d), "
-			"defaulting to 0x%04x\n",
-				err, dev->string_langid);
+			"language id specifier not provided by device, defaulting to English");
 		return 0;
 	}

