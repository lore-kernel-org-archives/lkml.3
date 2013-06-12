Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3FLRzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:55:39 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40688 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3FLRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130612174500.26381.95767@quantum>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
	<1369056507-32521-6-git-send-email-james.hogan@imgtec.com>
	<519AFBB6.90700@codeaurora.org>
	<CAD=FV=VFqTzqLc3+UOHD21NiTqtu84DzwYD1Qag-RxiD0qcFDA@mail.gmail.com>
	<20130612174500.26381.95767@quantum>
Date: Wed, 12 Jun 2013 10:55:36 -0700
X-Google-Sender-Auth: hapa-a32dm1SP4Xp5yvD8ziCqJ8
Message-ID: <CAD=FV=WvDFQhXMV7PiaMoDN41vcLC3nRL2B8_v=B6h1mCq0Saw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Wed, Jun 12, 2013 at 10:45 AM, Mike Turquette <mturquette@linaro.org> wrote:

>> * It seems like we can't make muxing decisions on the SoC level.
>> * Your automatic muxing patches don't hurt me and could be useful for
>> _some_ of the muxing options, just not the top PLL ones.
>
> For the time being you won't be affected by this until you start using
> .determine_rate.  Even then we have the flag which disables this
> behavior.

Yup, exactly!  :)  So I have no objections to the auto remuxing, it
just doesn't solve all of my problems.


>> ...but the only place that leaves me for my muxing needs is the device
>> tree.  ...and as Mike pointed out on IRC the device tree should
>> describe hardware, not policy.  Ick.
>
> This sounds like another vote for configtree ;-)

Yes.  It sounds like for now we're just going to carry some patches to
setup our clocks, but a configtree seems like it would solve this type
of problem.

One question to raise: if we're going to need to come up with a
solution for defining parents for things like PLLs, does it decrease
the need for the auto-remuxing patches?  AKA: if we use some type of
mechanism like configtree to specify muxing, would that be enough?  I
don't know the answer, but just thought I'd raise the question...

-Doug
