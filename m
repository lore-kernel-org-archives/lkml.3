Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaFEPa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:30:26 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:53558 "EHLO
	mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbaFEPaZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:30:25 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 11:30:24 EDT
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] usb: gadget: gadgetfs: correct dev state
From: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
In-Reply-To: <53907C23.5060404@cogentembedded.com>
Date: Thu, 5 Jun 2014 17:15:02 +0200
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <5A6C89E5-92AB-4908-8867-2BE783794E60@theobroma-systems.com>
References: <1401973680-18413-1-git-send-email-marcus.nutzinger@theobroma-systems.com> <53907C23.5060404@cogentembedded.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Jun 5, 2014, at 4:18 PM, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

>   Please also specify that commit's summary line in parens.

I'll resubmit the updated patch in a minute!

>> +	/* other endpoints were all decoupled from this device */
>> +	spin_lock_irq(&dev->lock);
>> +	dev->state = STATE_DEV_DISABLED;
>> +	spin_unlock_irq(&dev->lock);
> 
>   Not sure I understand why you need spinlock here... isn't the assignment atomic already?


Sure, an assignment might be atomic. However, following the policy of commit 7489d149
(USB: gadgetfs cleanups) all ep0 state changes shall be protected by spinlocks.

Thanks,
Marcus

