Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab3E3BU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:20:56 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:58279 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3E3BUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:20:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,767,1363100400";   d="scan'208";a="129005887"
Message-id: <51A6A96D.8080105@renesas.com>
Date: Thu, 30 May 2013 10:20:45 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-version: 1.0
To: balbi@ti.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb: gadget: r8a66597-udc: do not unlock unheld spinlock
 in r8a66597_sudmac_irq()
References: <1369860697-17362-1-git-send-email-khoroshilov@ispras.ru>
 <20130529235841.GB23190@arwen.pp.htv.fi>
In-reply-to: <20130529235841.GB23190@arwen.pp.htv.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2013/05/30 8:58), Felipe Balbi wrote:
> HI,
> 
> On Thu, May 30, 2013 at 12:51:37AM +0400, Alexey Khoroshilov wrote:
>> r8a66597_irq() processes sudmac part (r8a66597_sudmac_irq()) before locking r8a66597->lock.
>> But transfer_complete(), that is called inside (r8a66597_sudmac_irq()->sudmac_finish()->transfer_complete()),
>> expects r8a66597->lock is locked. As a result unheld spinlock can be unlocked.
>>
>> The patch just moves locking before calling r8a66597_sudmac_irq().
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> 
> should this go to stable ? Looks like this bug has been there since
> 2.6.32.
> 

Because non SMP CPUs have sudmac for now, this may not go to stable, I think.

Best regards,
Yoshihiro Shimoda
