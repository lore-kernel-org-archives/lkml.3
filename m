Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab3EOSKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:10:46 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63627 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3EOSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:10:45 -0400
Message-ID: <5193CFA2.8010008@linaro.org>
Date: Wed, 15 May 2013 11:10:42 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock and
 RTC on system time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com> <5191880F.3030308@linaro.org> <5192082D.4020400@citrix.com> <5192711B.1070607@linaro.org> <5193606502000078000D64E2@nat28.tlf.novell.com>
In-Reply-To: <5193606502000078000D64E2@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 01:16 AM, Jan Beulich wrote:
>>>> On 14.05.13 at 19:15, John Stultz <john.stultz@linaro.org> wrote:
>> On 05/14/2013 02:47 AM, David Vrabel wrote:
>>> On 14/05/13 01:40, John Stultz wrote:
>>>> I'm sorry, this isn't quite making sense to me. Could you further
>>>> describe the exact problematic behavior you're seeing here, and why its
>>>> a problem?
>>> The Xen wallclock is used as the persistent clock for Xen guests.  This
>>> is initialized (by Xen) with the CMOS RTC at the start of day.
>> Start of the day? I assume you mean on dom0 bootup? Or is it done
>> pre-dom0 bootup by Xen itself?
> It is, indeed - Xen reads the CMOS clock (or consults EFI) once
> when it starts up, but leaves those alone as soon as it launched
> Dom0.
>
>>>     If the
>>> RTC is incorrect then guests will see an incorrect wallclock time until
>>> dom0 has corrected it.
>>
>> Sorry, just a bit more clarifying context here: So there is a 1:1
>> relationship between xen_wall_clock and the RTC for all domN guests? And
>> even if dom0 has set its system time properly, domN guests will
>> initialize (in effect) from the hardware RTC and not from dom0's system
>> time?
> No, (PV) DomU-s will get their time from the software clock that
> Xen maintains, which Dom0 is helping keep in good shape when
> NTP-synced.

Ok, so really, as soon as the Dom0 time is set by NTP, all guests will 
see the right time? That makes more sense, and means the window for 
these sorts of issues is reasonably quite small.

David: So I'm less inclined to merge this individual change, but if you 
still feel strongly about it, let me know and we can circle around on it 
after you've addressed the specific issues I pointed out earlier.

thanks
-john


