Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab3BMPqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:46:33 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:59757 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab3BMPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:46:30 -0500
MIME-Version: 1.0
In-Reply-To: <511BAFDB.6050908@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <1358996820-23036-9-git-send-email-alex.shi@intel.com> <1360664874.4485.18.camel@laptop>
 <511BAFDB.6050908@intel.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 13 Feb 2013 07:45:54 -0800
Message-ID: <CAPM31RLi+e=2kmwxDOewe=+LHrHGiVTuo-+3WeAFEmsWmi1fnw@mail.gmail.com>
Subject: Re: [patch v4 08/18] Revert "sched: Introduce temporary
 FAIR_GROUP_SCHED dependency for load-tracking"
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 7:23 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 02/12/2013 06:27 PM, Peter Zijlstra wrote:
>> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>>> Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
>>> we can use runnable load variables.
>>>
>> It would be nice if we could quantify the performance hit of doing so.
>> Haven't yet looked at later patches to see if we remove anything to
>> off-set this.
>>
>
> In our rough testing, no much clear performance changes.
>

I'd personally like this to go with a series that actually does
something with it.

There's been a few proposals floating around on _how_ to do this; but
the challenge is in getting it stable enough that all of the wake-up
balancing does not totally perforate your stability gains into the
noise.  select_idle_sibling really is your nemesis here.

It's a small enough patch that it can go at the head of any such
series (and indeed; it was originally structured to make such a patch
rather explicit.)

> --
> Thanks
>     Alex
