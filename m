Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3IXJfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3IXJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:35:29 -0400
Date: Tue, 24 Sep 2013 11:34:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20130924093450.GB1008@krava.brq.redhat.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
 <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
 <20130917102904.GA27258@mudshark.cambridge.arm.com>
 <CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 10:55:32AM +0200, Jean Pihet wrote:
> Hin
> 
> On 17 September 2013 12:29, Will Deacon <will.deacon@arm.com> wrote:
> > Arnaldo, Ingo,
> >
> > On Mon, Sep 16, 2013 at 10:17:32AM +0100, Jean Pihet wrote:
> >> The newly added dwarf unwinding feature [1] requires:
> >> . a recent version (>= 1.1) of libunwind,
> >> . libunwind to be configured with --enable-debug-frame.
> >>
> >> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> >>
> >> Add the corresponding API test in the feature check list.
> >>
> >> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> >> ---
> >>  tools/perf/config/Makefile          |  2 +-
> >>  tools/perf/config/feature-tests.mak | 11 ++++++++++-
> >>  2 files changed, 11 insertions(+), 2 deletions(-)
> >
> > Can I have an ack for this and the following patch please?
> >
> > (http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198531.html)
> >
> > Then I can stick these into -next for some more exposure before I queue them
> > for 3.13.
> >
> > Cheers,
> >
> > Will
> 
> Ping on the series. The two patches above (3/4 and 4/4) are generic
> while the two others are impacting ARM only.
> Is it possible to get an Ack for the generic ones?

I'm fine with those changes.. still I'm sort of worried about
current DWARF unwind users (but not sure if there're any),
who depends on packaged libunwind compiled without
--enable-debug-frame option.

I've seen your libunwind patch to make it default, but
not sure if it was accepted.. if not, maybe we should
detect this and build that code conditionaly.

thoughts anyone?
jirka
