Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaHYDqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:46:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:22781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaHYDqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,394,1406617200"; 
   d="scan'208";a="472188834"
Message-ID: <53FAB0C9.3070907@intel.com>
Date: Mon, 25 Aug 2014 11:43:05 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Knut Petersen <Knut_Petersen@t-online.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 3.14.17] inconsistent lock state
References: <53F9CC77.70009@t-online.de>	<CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>	<53FAA544.4030401@intel.com> <CA+55aFzaHF=S3QQ6M-+JBdWVRCSHKs-jjKo==8OS7q90cUyHBw@mail.gmail.com>
In-Reply-To: <CA+55aFzaHF=S3QQ6M-+JBdWVRCSHKs-jjKo==8OS7q90cUyHBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月25日 11:13, Linus Torvalds wrote:
> On Sun, Aug 24, 2014 at 7:53 PM, Lan Tianyu <tianyu.lan@intel.com> wrote:
>>
>> Sorry about this. We are resolving the issue in the other bug
>> report(https://lkml.org/lkml/2014/8/21/606) and I have proposed a fix
>> patch(http://marc.info/?l=linux-acpi&m=140869309231199&w=2).
> 
> Ahh. Good. That patch looks fine to me, and while it makes me worry a
> bit that some codepath expects the power/sleep button to be handled
> immediately in interrupt context, I guess the actual callbacks have
> never actually done anything but schedule other things to happen (ie
> add events to some queue), and making the context be the same as the
> other notify callbacks would seem to be a good thing regardless of
> this particular bug.

Yes, I have the same opinion and the callback just reports power/sleep
button event to user space via input layer or ACPI netlink routines.

The button devices enumerated from ACPI namespace and FADT table share
the same notify callback and do the same things while they are running
different context. This seems not make sense.

> 
> Knut - can you please test the patch Lan pointed at? I realize it
> doesn't seem to be entirely consistent for you (which is a bit
> surprising, I wonder why lockdep doesn't trigger it consistently), but
> it would be good to have more testing. Even if that patch looks
> "obviously good" (tm) at a quick glance.

BTW, this bug only takes place on the machines with fixed button device.
This can be identified via check whether there are LNXPWRBN:00 or
LNXSLPBN:00 device nodes under /sys/bus/acpi/devices.

> 
>                   Linus
> 


-- 
Best regards
Tianyu Lan
