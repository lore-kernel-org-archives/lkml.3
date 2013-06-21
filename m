Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423273Ab3FUQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:22:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64970 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423018Ab3FUQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:22:49 -0400
Message-ID: <51C47DD6.3000004@linaro.org>
Date: Fri, 21 Jun 2013 09:22:46 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:57 AM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, David Vrabel wrote:
>
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> The high resolution timer code gets notified of step changes to the
>> system time with clock_was_set() or clock_was_set_delayed() calls.  If
>> other parts of the kernel require similar notification there is no
>> clear place to hook into.
> You fail to explain why any other part of the kernel requires a
> notification.
>   
> We went great length to confine timekeeping inside the core code and
> now you add random notifiers along with totally ugly tasklet
> constructs. What for?
>
> Without a reasonable explanation of the problem you are trying to
> solve this is going nowhere near the tree.

It took awhile for me to get why it was needed as well.

My understanding is that on Xen, they want the hypervisor's virtual RTC 
needs to be aligned with Dom0s system time (so that DomN guests boot 
with the correct time). Thus changes to the system time need to cause 
Dom0 to update the virtual RTC.

Its not terribly unlike the timerfd notification we do to userspace, but 
instead is done for the Dom0 Xen management code.

I do agree we need to keep users of the notification on a short leash 
(hopefully keeping the interface behind some sort of internal.h header 
file) so its easy to see when folks start trying to use it.

thanks
-john


