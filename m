Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3A1HKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:10:40 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:36519 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3A1HKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:10:38 -0500
Message-ID: <51062460.9060902@synopsys.com>
Date: Mon, 28 Jan 2013 12:40:24 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <5102BB38.3050207@imgtec.com> <201301260025.10020.arnd@arndb.de>
In-Reply-To: <201301260025.10020.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd / Stephen,

On Saturday 26 January 2013 05:55 AM, Arnd Bergmann wrote:
> On Friday 25 January 2013, James Hogan wrote:
>> Hi Arnd,
>>
>> On 10/01/13 15:30, James Hogan wrote:
>>> This patchset adds core architecture support to Linux for Imagination's
>>> Meta ATP (Meta 1) and HTP (Meta 2) processor cores. Most of the feedback
>>> from the RFC and v2 patchsets has now been addressed. All further
>>> feedback is most welcome.
>>>
>>> The patches are based on next-20130110, and can also be found in the
>>> following git tree:
>>>   git://github.com/jahogan/metag-linux.git metag-core
>>
>> Review seems to have gone quiet. I'm fairly happy with this core
>> patchset in it's currently form (only trivial alterations required since
>> the v3 patches, e.g. some review comments and rebasing on linus/master),
>> and would like to get it into the v3.9 merge window. What's the best way
>> forward? I presume I need to get acks on each individual patch?
> 
> 
> I've just looked through the entire series once more and could not find
> any show-stoppers. I consider this ready for 3.9, and I'm also quite happy
> with Vineet's ARC port, although I think he is still integrating some
> feedback comments.

AFAIKS, I've already addressed all the comments in v1 and v2 except moving the
clocksources/clockevent code to drivers. If that is a must, I can do that,
although personally I think it is too arch specific (tied to ARC specific RTSC
insn and such) to be moved out of arch code. Can you please skim thru the latest
v3 series, or just part #1 (changes since v2) if that's too big to reconfirm.

> I'd suggest that you both ask Stephen to add the trees to linux-next
> now (I thought you had done that already, but I don't see them there
> at the moment).

Stephen, can you please add the following branch (rebased off 3.8-rc5) to linux-next

git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git  arc-next

With next-20130125, there's a trivial conflict in init/Kconfig - fixable by
accepting both the hunks.

> You don't need Acked-by statements on every single patch, but having
> more of those is certainly benefitial. When it comes to the merge
> window, please send a pull request to Linus, and keep me on Cc,
> so I can weigh in with an additional Ack to the series.

While the first pull request can go directly from github, I presume the logistics
for setting up accounts on kernel.org will only kick start after the first batch
of code has been accepted. I can't seem to find any discussions on lists to that
effect.

> Until then, maybe you can have another look at each other's architecture
> trees (ARC and Meta). Since you are in exactly the same situation with
> upstream integration now, you are probably the best people to review
> the code, and you providing ACKs and constructive feedback to the other
> tree will helps others see that you are up to the job as an arch
> maintainer.

I'm certain we've both been looking at each other's patches in last few months - I
certainly have for say DeviceTree support so it makes sense to formalize it.
Although "Reviewed-by" will probably be better off that "Ack" in this case.

> I have also given a few comments to one of you that
> may actually apply to the other one just as well, but I can't remember
> now what I discussed with whom ;-)

OK, will re-skim thru all such discussions, although ARC comments are likely to be
superset of metag :-)

BTW I went back to hexagon submission patches in 2011 and it seems every new arch
makes the exact same mistakes:
-idle sleep race
-faltering in TIF_WORK_RESUME and in fixing that breaking the syscall restarting
-redundant symbols in module.c
...

Will it make sense to have a checklist-for-new-arches with concrete examples of
broken and fixed code so that you, Al and other reviewers don't have to repeat the
same thing over and over again.

Thx,
-Vineet

