Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab3IXKHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:07:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62055 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab3IXKHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:07:10 -0400
Date: Tue, 24 Sep 2013 11:06:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20130924100620.GG15119@mudshark.cambridge.arm.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
 <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
 <20130917102904.GA27258@mudshark.cambridge.arm.com>
 <CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
 <20130924093450.GB1008@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924093450.GB1008@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 10:34:50AM +0100, Jiri Olsa wrote:
> On Tue, Sep 24, 2013 at 10:55:32AM +0200, Jean Pihet wrote:
> > Ping on the series. The two patches above (3/4 and 4/4) are generic
> > while the two others are impacting ARM only.
> > Is it possible to get an Ack for the generic ones?
> 
> I'm fine with those changes.. still I'm sort of worried about
> current DWARF unwind users (but not sure if there're any),
> who depends on packaged libunwind compiled without
> --enable-debug-frame option.

Since x86 is the only architecture using libunwind with perf at the moment,
and I'd expect it to use .eh_frame for unwinding, I'm also not sure there
are any existing users to worry about.

> I've seen your libunwind patch to make it default, but
> not sure if it was accepted.. if not, maybe we should
> detect this and build that code conditionaly.

It certainly defaults to "on" for ARM, but other architectures have to
enable it explicitly afaict.

Will
