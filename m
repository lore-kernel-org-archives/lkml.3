Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaIJO6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:58:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59122 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:58:18 -0400
Message-ID: <54106707.4010006@codeaurora.org>
Date: Wed, 10 Sep 2014 10:58:15 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org> <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com> <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com> <53FE5B09.2020403@codeaurora.org> <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com> <53FE7E3B.1010500@codeaurora.org> <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com> <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com> <20140828093505.GC14650@leverpostej> <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
In-Reply-To: <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 06:11 PM, Doug Anderson wrote:
> Mark,
> 
> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> Not if you boot Linux at hyp, as we've recommended for this precise
>> reason. That doesn't fix other things like CNTFRQ if the secure
>> initialisation doesn't poke that, however.
> 
> I'll freely admit that I'm out of my league and out of my comfort zone
> here, but...
> 
> In the theory that firmware ought to be as minimal as possible
> (because it's hard to update and hard to keep in sync with kernel
> versions), it seems like firmware ought to start the kernel out in as
> permissive mode as it's willing to provide, right?
> 
> If the kernel is started out as permissive as possible then it can do
> anything it needs to.  Future versions of the kernel can be
> implemented to do any way-cool things that they want to do without an
> update to firmware, right?  ...and current versions of the kernel can
> just shed permissions if they don't want them.
> 
> ...so if I understand correctly, "Secure SVC" mode is more permissive
> than "Non Secure HYP" mode, right?  It looks to me as if we currently
> start the kernel in "Secure SVC" mode.  What do you think about the
> kernel detecting Secure SVC and then dropping down permission levels
> (to Non Secure HYP).  Once it did this, it could update things like
> the virtual offset and then transition down further into non-secure
> SVC mode.
> 
> ...or maybe this has been discussed millions of times already and I'm
> just clueless.  ...or maybe this is just too hard for the kernel to do
> in a generic way?

I think this is a great idea. When running on simulators, it would make (the
non-DTB parts of) the bootwrapper and QEMU's built-in bootloader unnecessary.

Implementing it on AArch64 should be trivial as you can just read CurrentEL
and work from whatever EL/PL you're at. Is there an easy way to check whether
you're in secure or nonsecure mode in AArch32? I seem to recall discussion
about putting this information into the DTB, which makes me think there isn't.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
