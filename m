Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3ENJzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:55:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46954 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab3ENJzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:55:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,669,1363132800"; 
   d="scan'208";a="25062326"
Message-ID: <51920A15.6050605@citrix.com>
Date: Tue, 14 May 2013 10:55:33 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/3] x86/xen: sync the CMOS RTC as well as the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-4-git-send-email-david.vrabel@citrix.com> <51918ABB.5030501@linaro.org>
In-Reply-To: <51918ABB.5030501@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/13 01:52, John Stultz wrote:
> On 05/13/2013 10:56 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> If NTP is used in dom0 and it is synchronized to its clock source,
>> then the kernel will periodically synchronize the Xen wallclock with
>> the system time.  Updates to the Xen wallclock do not persist across
>> reboots, so also synchronize the CMOS RTC (as on bare metal).
> 
> Sorry again, not getting this one either.
> 
> So normally in this case we're using the Xen wallclock as the underlying 
> source for the persistent_clock here, my understanding is we use this 
> instead of the standard cmos, because we get benefits of using the 
> hypervisor's sense of time instead of the bare hardware, and allows for 
> virtualization of the persistent clock.
> 
> But the problem is that even if Dom0 tries to set the xen persistent 
> clock, it doesn't actually update anything in the underlying hardware?  
> So here you instead try to sync the underlying hardware cmos from the 
> same Xen dom0 environment?

Yes.

> Honestly, it seems a little strange to me. If you're running as dom0, 
> why does HYPERVISOR_dom0_op() not cause the hypervisor to set the cmos 
> its virtualizing? This seems to mess with the proper virtualization 
> layering.

As Jan says the hypervisor only drives a minimal set of hardware,
everything else is made accessible to dom0 for it to control.

I think this makes sense as it allows us to reuse the existing RTC
drivers etc. in the Linux kernel, instead of having to reimplement them
in the hypervisor.

David
