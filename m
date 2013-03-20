Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3CTCwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:52:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5156 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab3CTCwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:52:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 19:52:13 -0700
Message-ID: <1363748149.8815.16.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/1] clk: Add notifier support in
 clk_prepare/clk_unprepare
From: Bill Huang <bilhuang@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Tue, 19 Mar 2013 19:55:49 -0700
In-Reply-To: <20130319170140.8663.93388@quantum>
References: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com>
	 <20130319170140.8663.93388@quantum>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 01:01 +0800, Mike Turquette wrote:
> Quoting Bill Huang (2013-03-19 06:28:32)
> > Add notifier calls in clk_prepare and clk_unprepare so drivers which are
> > interested in knowing that clk_prepare/unprepare call can act accordingly.
> > 
> > The existing "clk_set_rate" notifier is not enough for normal DVFS
> > inplementation since clock might be enabled/disabled at runtime. Adding
> > these notifiers is useful on DVFS core which take clk_prepare as a hint
> > on that the notified clock might be enabled later so it can raise voltage
> > to a safe level before enabling the clock, and take clk_unprepare as a
> > hint that the clock has been disabled and is safe to lower the voltage.
> > 
> > The added notifier events are:
> > 
> > PRE_CLK_PREPARE
> > POST_CLK_PREPARE
> > ABORT_CLK_PREPARE
> > PRE_CLK_UNPREPARE
> > POST_CLK_UNPREPARE
> > 
> > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> 
> I'm still not sure about this approach.  Based on feedback I got from
> Linaro Connect I am not convinced that scaling voltage through clk
> rate-change notifiers is the right way to go.  As I understand it this
> patch only exists for that single purpose, so if the voltage-notifier
> idea gets dropped then I will not take this patch in.
> 
Thanks Mike, actually we won't use your "clk: notifier handler for
dynamic voltage scaling" patch instead we are trying to port our DVFS
into Non-CPU DVFS framework "devfreq" which will need to hook those
notifiers, without the clock notifiers been extended the framework is
useless for us since we cannot do polling due to the fact that polling
is not in real time. If it ended up extending the notifiers cannot
happen then the only choice for us I think would be giving up "devfreq"
and implement them in Tegra's "clk_hw".

