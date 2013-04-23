Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3DWGSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:18:48 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:61544 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3DWGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130422131101.GA17463@sirena.org.uk>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
 <1365886878.1089.5.camel@jlt4.sipsolutions.net> <20130415162652.GK15837@opensource.wolfsonmicro.com>
 <1366043632.8361.33.camel@jlt4.sipsolutions.net> <20130422131101.GA17463@sirena.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 22 Apr 2013 23:18:24 -0700
X-Google-Sender-Auth: 2F3-wFE98C69tH_SgopxaeLTl8U
Message-ID: <CAB=NE6WEQ3LmscwRAv=d1T8FpW3_cr3wxpbb_RBRqZgxFdiPcg@mail.gmail.com>
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
To: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 6:11 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 15, 2013 at 06:33:52PM +0200, Johannes Berg wrote:
>> On Mon, 2013-04-15 at 17:26 +0100, Mark Brown wrote:
>
>> > Please let's at least discuss the issues here, I'm not sure what this is
>> > supposed to do but the analysis of the subsystem didn't seem complete.
>
>> I wouldn't worry about it too much. For some reason (media drivers
>> related?) Luis decided that it was worth including this in the backports
>> project (see http://backports.wiki.kernel.org) and I am currently
>> maintaining the git tree for that, at least while I was doing some
>> refactoring.
>
>> I do notice that it doesn't quite work, there are a lot of unresolved
>> symbols :)
>
>> If you think you'd be impacted by this because users demand support from
>> you for the backport or whatever I can revert this (or probably just
>> remove it from the copy list for now.) I don't really have an opinion on
>> it, I'm doing this because I'm interested in one specific wireless
>> driver.
>
> Well, I'd much rather have a sane backport if we're going to have one -
> whatever problem is being solved here it seems likely that someone else
> will have the same need and if there's a general kernel project for this
> (which preusmably has some overlap with LTSI?) it seems bad to have one
> that people have to be warned away from using.

LTSI is for folks who stick to a kernel revision. backports project is
for folks who do not have control over what kernel they are on -- yet
or as a model. backports provides support for backporting new kernel
drivers down to any range of kernels. We strive for 802.11 down to
2.6.24, for BT 2.6.27, DRM to 3.2, regulator 3.2, Media 3.2. There are
both daily snapshots based on linux-next, and stable release snapshots
based on linux-stable. This enables Linux distributions, either
rolling or non-rolling, to embraces released bast on latest and
greatest drivers or based on stable releases.

The target here was not to make an assessment over quality of work on
the subsystem but instead more on the backportability nature of it. In
this case the regulator ends up using some data structures defined
upon late_initcall() and core_initcall() which implicates what you can
backport unless you can genuinely provide gaurantee a proper backport
of regulator as a module and forcing drivers to use a separate
namespace or somehow modifying the kernel's init calls with things
like ksplice. Neither of these two are possible today and as such what
is backported for regulator is things that do not depend on these
calls having fired off as is today. 3.2 as a target seemed reasonable
given that DRM was backported down to 3.2 and so was media.

> Given how big the misunderstandings in the cover letter for Luis' patch
> were I'd be really concerned about seeing this going into anything
> officialish without some discussion about what's going on.

Official? Huh?

  Luis
