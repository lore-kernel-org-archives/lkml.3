Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3FDGA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:00:58 -0400
Received: from ozlabs.org ([203.10.76.45]:55057 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab3FDGAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Greear <greearb@candelatech.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <51ACC60B.8090504@candelatech.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 04 Jun 2013 14:07:29 +0930
Message-ID: <87k3matrsm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:
> On 06/03/2013 08:59 AM, Ben Greear wrote:
>> On 06/03/2013 07:17 AM, Joe Lawrence wrote:
>>
>>>>> Hi Rusty,
>>>>>
>>>>> I had pointed Ben (offlist) to that bugzilla entry without realizing
>>>>> there were other earlier related fixes in this space.  Re-viewing bz-
>>>>> 58011, it looks like it was opened against 3.8.12, while Ben and myself
>>>>> had encountered module loading problems in versions 3.9 and
>>>>> 3.9.[1-3].  I can update the bugzilla entry to add a comment noting commit
>>>>> a49b7e82 "kobject: fix kset_find_obj() race with concurrent last
>>>>> kobject_put()".
>>>>>
>>>>> That said, it doesn't appear that commit 944a1fa "module: don't unlink the
>>>>> module until we've removed all exposure" has not made it into any stable
>>>>> kernel.  On my system, applying this on top of 3.9 resolved a module
>>>>> unload/load race that would occasionally occur on boot (two video adapters
>>>>> of the same make, the module unloads for whatever reason and I see "module
>>>>> is already loaded" and "sysfs: cannot create duplicate filename
>>>>> '/module/mgag200'" messages every 5-10% instances.)  I have logs if you
>>>>> were interested in these warnings/crashes.
>>
>> It at least works around the problem for me as well.  But, a more rare
>> migration/[0-3] (I think) related lockup still exists in 3.9.4 for me,
>> so I will also try applying that other kobject patch and continue testing
>> today...
>
> Well, that other kobject patch is already in 3.9.4, so I think it's still
> a good idea to include the
> "module: don't unlink the module until we've removed all exposure."
> patch in stable.  I have a decent test case to reproduce the crash, so if someone
> wants me to test other patches instead, then I will do so.

I understand your eagerness to have this resolved, but we need to
understand the problem.  The fix you asked for in stable was supposed to
be cosmetic, to avoid the sysfs warning.  But it did serve to stress the
cleanup path, which may still have lurking bugs!

I reproduced the oops myself on 3.8.  I will chase it on 3.9.4, too.

Thanks,
Rusty.
