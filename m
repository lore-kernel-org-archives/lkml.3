Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3EOIQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:16:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47209 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3EOIQL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 15 May 2013 04:16:11 -0400
Message-Id: <5193606502000078000D64E2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 15 May 2013 09:16:05 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "John Stultz" <john.stultz@linaro.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock
 and RTC on system time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
 <1368467768-2316-3-git-send-email-david.vrabel@citrix.com>
 <5191880F.3030308@linaro.org> <5192082D.4020400@citrix.com>
 <5192711B.1070607@linaro.org>
In-Reply-To: <5192711B.1070607@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.05.13 at 19:15, John Stultz <john.stultz@linaro.org> wrote:
> On 05/14/2013 02:47 AM, David Vrabel wrote:
>> On 14/05/13 01:40, John Stultz wrote:
>>> I'm sorry, this isn't quite making sense to me. Could you further
>>> describe the exact problematic behavior you're seeing here, and why its
>>> a problem?
>> The Xen wallclock is used as the persistent clock for Xen guests.  This
>> is initialized (by Xen) with the CMOS RTC at the start of day.
> 
> Start of the day? I assume you mean on dom0 bootup? Or is it done 
> pre-dom0 bootup by Xen itself?

It is, indeed - Xen reads the CMOS clock (or consults EFI) once
when it starts up, but leaves those alone as soon as it launched
Dom0.

>>    If the
>> RTC is incorrect then guests will see an incorrect wallclock time until
>> dom0 has corrected it.
> 
> 
> Sorry, just a bit more clarifying context here: So there is a 1:1 
> relationship between xen_wall_clock and the RTC for all domN guests? And 
> even if dom0 has set its system time properly, domN guests will 
> initialize (in effect) from the hardware RTC and not from dom0's system 
> time?

No, (PV) DomU-s will get their time from the software clock that
Xen maintains, which Dom0 is helping keep in good shape when
NTP-synced.

So the hypervisor really doesn't care about the actual RTC getting
updated in hardware, all it needs is for Dom0 to notify it of wall
clock corrections.

Jan

