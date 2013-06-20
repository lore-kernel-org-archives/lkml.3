Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376Ab3FTMc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:32:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44105 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab3FTMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:32:27 -0400
Message-ID: <51C2F641.9000803@ti.com>
Date: Thu, 20 Jun 2013 15:32:01 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-5-git-send-email-rogerq@ti.com> <87r4fy6lvm.fsf@linaro.org>
In-Reply-To: <87r4fy6lvm.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:39 PM, Kevin Hilman wrote:
> Hi Roger,
> 
> Roger Quadros <rogerq@ti.com> writes:
> 
>> Runtime suspend the controller during bus suspend and resume it
>> during bus resume. This will ensure that the USB Host power domain
>> enters lower power state and does not prevent the SoC from
>> endering deeper sleep states.
>>
>> Remote wakeup will come up as an interrupt while the controller
>> is suspended, so tackle it carefully using a workqueue.
> 
> I don't think you need a special workqueue here.  The workqueue of the PM
> core (pm_wq) will be used if you just use an asynchronous 'get' in the
> ISR.  Then, the driver's own runtime PM callbacks can be used instead of
> an additional workqueue.
> 
> Another thing to worry about here when using runtime PM to implement
> suspend/resume is that runtime PM can be disabled from userspace (e.g.
> echo disabled > /sys/devices/.../power/control.)  If that's the case,
> all the pm_runtime_suspended() checks will always fail becuase that
> call also checks if runtime PM is disabled.  You'll likely want to use
> the pm_runtime_status_suspended() check instead, which checks only the
> status, and doesn't matter if runtime PM is currently disabled.
> 
> Because of the corner issues here, please test system suspend/resume
> when runtime PM has been disabled.
> 

Good points. Thanks. I'll need to think about it some more.

cheers,
-roger
