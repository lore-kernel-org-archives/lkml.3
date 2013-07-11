Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3GKHbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:31:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38001 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab3GKHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:31:03 -0400
Message-ID: <51DE5F1B.8080201@ti.com>
Date: Thu, 11 Jul 2013 10:30:35 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] USB: Support wakeup IRQ for suspended controllers
References: <Pine.LNX.4.44L0.1307101504220.1215-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307101504220.1215-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 10:08 PM, Alan Stern wrote:
> On Wed, 10 Jul 2013, Roger Quadros wrote:
> 
>> Some platforms e.g. ehci-omap can generate an interrupt
>> (i.e. remote wakeup) even when the controller is suspended i.e.
>> HW_ACCESSIBLE is cleared.
>>
>> Introduce a flag "has_wakeup_irq" in struct usb_hcd to indicate
>> such cases.
>>
>> We tackle this case by disabling the IRQ, scheduling a
>> hub resume and enabling back the IRQ after the controller has
>> resumed. This ensures that the IRQ handler runs only after the
>> controller is accessible.
> 
> Oh yes, one more thing...
> 
>> @@ -132,6 +134,7 @@ struct usb_hcd {
>>  	unsigned		wireless:1;	/* Wireless USB HCD */
>>  	unsigned		authorized_default:1;
>>  	unsigned		has_tt:1;	/* Integrated TT in root hub */
>> +	unsigned		has_wakeup_irq:1; /* Can IRQ when suspended */
> 
> Please add a highly visible comment here, warning that has_wakeup_irq
> should never be set on systems with shared IRQs.  Having both would ...
> well, it would indicate a really bad system design.
> 
OK, will do.

cheers,
-roger
