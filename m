Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaA3HCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 02:02:16 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55843 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaA3HCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 02:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140129183204.GA22808@redhat.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
	<20140129145535.GA12562@redhat.com>
	<CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
	<20140129183204.GA22808@redhat.com>
Date: Thu, 30 Jan 2014 13:02:11 +0600
Message-ID: <CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/29, Rakib Mullick wrote:

>> Are you thinking that , since things are not broken, then we shouldn't
>> try to do anything?
>
> Hmm. No.
>
> I am thinking that, since you misunderstood the purpose of ->curr_target,
> I should probably try to argue with your patch which blindly removes this
> optimization ?
>
Since the optimization (usages of ->curr_target) isn't perfect, so there's
chance of being misunderstood. This optimization is misleading too (I think),
cause curr_target don't have anything to do with wants_signal() and
 ->curr_target is used only for this optimization and to get this optimization
needs to maintain it properly, and this maintenance does have cost and if
we don't get benefited too much, then it doesn't worth it (my pov).

> I also think that this logic doesn't look perfect, but this is another
> story.

Yes, this logic seems need to improve.

Thanks,
Rakib
