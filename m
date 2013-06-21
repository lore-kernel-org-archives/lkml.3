Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382Ab3FUMlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:41:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64565 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196Ab3FUMls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,913,1363132800"; 
   d="scan'208";a="32641686"
Message-ID: <51C44A09.9010402@citrix.com>
Date: Fri, 21 Jun 2013 13:41:45 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 08:57, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, David Vrabel wrote:
> 
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> The high resolution timer code gets notified of step changes to the
>> system time with clock_was_set() or clock_was_set_delayed() calls.  If
>> other parts of the kernel require similar notification there is no
>> clear place to hook into.
> 
> You fail to explain why any other part of the kernel requires a
> notification.

This is needed by patch 3 in this series.

"The Xen wallclock is a software only clock within the Xen hypervisor
that is used by: a) PV guests as the equivalent of a hardware RTC; and
b) the hypervisor as the clock source for the emulated RTC provided to
HVM guests.

Currently the Xen wallclock is only updated every 11 minutes if NTP is
synchronized to its clock source.  If a guest is started before NTP is
synchronized it may see an incorrect wallclock time.

Use the clock_was_set notifier chain to receive a notification when
the system time is stepped and update the wallclock to match the
current system time."

> We went great length to confine timekeeping inside the core code and
> now you add random notifiers along with totally ugly tasklet
> constructs.

I'm not sure I understand your objection to the use of a tasklet.  Using
the hrtimer softirq for something that is no longer hrtimer-specific did
not seem like the correct thing to do.

David
