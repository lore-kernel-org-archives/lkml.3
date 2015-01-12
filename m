Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbbALLav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:30:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12155 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbALLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:30:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,743,1413244800"; 
   d="scan'208";a="215409854"
Message-ID: <54B3B067.4060002@citrix.com>
Date: Mon, 12 Jan 2015 11:30:47 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Imre Palik <imrep.amz@gmail.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: "Palik, Imre" <imrep@amazon.de>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH RFC] xen-time: decreasing the rating of the
 xen clocksource below that of the tsc clocksource for dom0's
References: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>	<1420648234.18631.117.camel@citrix.com> <54AE9CF0.8060907@gmail.com>
In-Reply-To: <54AE9CF0.8060907@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 15:06, Imre Palik wrote:
> On 01/07/15 17:30, Ian Campbell wrote:
>> On Wed, 2015-01-07 at 17:16 +0100, Imre Palik wrote:
>>> From: "Palik, Imre" <imrep@amazon.de>
>>>
>>> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
>>> be used) instead of the Xen clocksource should not cause any issues, as
>>> Dom0 VMs never live-migrated.
>>
>> Is this still true given that dom0's vcpus are migrated amongst pcpus on
>> the host? The tsc are not synchronised on some generations of hardware
>> so the result there would be the TSC appearing to do very odd things
>> under dom0's feet. Does Linux cope with that or does it not matter for
>> some other reason?
> 
> First of all, if the initial pcpus are not synchronised, linux won't consider
> TSC as a viable clocksource.
> 
> If the initial pcpus are synchronised, but then the dom0 vcpus are migrated to
> unsynchronised pcpus, then hopefully the tsc watchdog catches the issue, and
> the kernel falls back to the xen clocksource.  The issue here is that the
> watchdog can only detect clock skews bigger than 0.0625s/0.5s.  Hopefully this
> is enough to avoid the weirdest things.

I don't think any such hardware exists.  Either TSC is synchronized
across all CPUs or none.

> Also, some parts of the kernel (e.g., scheduling) will always use the paravirt
> clock.  No matter what priorities are set.
> 
> So it should be safe for some definition of safe.
> But I was unable to test it on a hardware platform that would hit the problematic
> case described above.

Ok.  Can you list the various time sources and their ratings in the
commit message for clarity.  i.e, to justify 275 (below TSC = 300. above
hpet = 250).

David
