Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3FERdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:33:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41797 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3FERdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1306051924190.19739@axis700.grange>
References: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<Pine.LNX.4.64.1305242353210.7187@axis700.grange>
	<1369638667.29283.197.camel@smile>
	<20130605171001.GC26663@mudshark.cambridge.arm.com>
	<Pine.LNX.4.64.1306051924190.19739@axis700.grange>
Date: Wed, 5 Jun 2013 20:33:51 +0300
Message-ID: <CAHp75Vdv=ybs7jJ1k6rfPoxAyEmhtMr8CSaSrdU+1dMDSr5x+A@mail.gmail.com>
Subject: Re: [PATCH] dmatest: do not allow to interrupt ongoing tests
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Will Deacon <will.deacon@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "djbw@fb.com" <djbw@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 8:25 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 5 Jun 2013, Will Deacon wrote:
>> On Mon, May 27, 2013 at 08:11:07AM +0100, Andy Shevchenko wrote:
>> > On Fri, 2013-05-24 at 23:55 +0200, Guennadi Liakhovetski wrote:
>> > > On Thu, 23 May 2013, Andy Shevchenko wrote:
>> > >
>> > > > When user interrupts ongoing transfers the dmatest may end up with console
>> > > > lockup, oops, or data mismatch. This patch prevents user to abort any ongoing
>> > > > test.
>> > >
>> > > Personally I would be against such a change. What about interrupting the
>> > > test with rmmod?
>> > >  Is it still possible after this your patch or not? If not
>> > > - this doesn't seem like a good idea to me. Why don't we just fix those
>> > > bugs, that you're describing?
>> >
>> > The behaviour of the module is returned to the same page by this patch
>> > as it was before (w/o debugfs).
>> >
>> > The user can interrupt tests by rmmod, but it will take time up to
>> > timeout.
>> >
>> > I appreciate if you can do a deeper analysis of what happened in
>> > case Will reported.
>>
>> Did this query hold up the application of this patch? I'd really like to see
>> *something* in 3.10, otherwise dmatest will be broken.

Will, Vinod is the slave DMA subsystem maintainer, I hope he could
shed a light on your concerns.
Actually, does it work as expected if you didn't run modprobe -r ?

> Not from me, no. I just expressed a doubt, the author thinks there is no
> problem, and I have no capacity atm to try to verify it, so, my query
> shouldn't be considered a nak.

Guennadi, anyway, thanks for your opinion.

Vinod, have you chance to try last patch?

--
With Best Regards,
Andy Shevchenko
