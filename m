Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaJHQM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:12:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52530 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaJHQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:12:24 -0400
Date: Wed, 8 Oct 2014 11:06:31 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
Message-ID: <20141008160631.GT868@joshc.qualcomm.com>
References: <cover.1412182773.git.joshc@codeaurora.org>
 <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
 <20141001172855.GL10233@codeaurora.org>
 <20141001181557.GQ868@joshc.qualcomm.com>
 <542DA2B6.3020201@codeaurora.org>
 <20141007221044.GR868@joshc.qualcomm.com>
 <5434723F.70800@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5434723F.70800@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:07:43PM -0700, Stephen Boyd wrote:
> On 10/07/2014 03:10 PM, Josh Cartwright wrote:
> >On Thu, Oct 02, 2014 at 12:08:38PM -0700, Stephen Boyd wrote:
[..]
> >>I'm thinking:
> >>
> >>                 timer@200a000 {
> >>                         compatible = "qcom,kpss-timer", "qcom,msm-timer";
> >>                         interrupts = <1 1 0x301>,
> >>                                      <1 2 0x301>,
> >>                                      <1 3 0x301>,
> >>                                      <1 4 0x301>,
> >>                                      <1 5 0x301>;
> >>                         reg = <0x0200a000 0x100>;
> >>                         clock-frequency = <27000000>,
> >>                                           <32768>;
> >>                         clocks = <&cxo>, <&sleep_clk>;
> >>                         clock-names = "ref", "sleep";
> >>                         cpu-offset = <0x80000>;
> >>                 };
> >Where'd the default timeout configuration go?  Or, should we have one
> >timeout-sec property and not allow setting the default timeouts per WDT
> >instance?  Or no configurable timeout at all?
> 
> Ah sorry. How about a timeout-sec-0, timeout-sec-1 property that is per-cpu
> and maps to the first and second watchdog timer? Something like:
> 
> timeout-sec-wdt0 = <10 8>;
> timeout-sec-wdt1 = <20 15>;

Okay, yeah, this is much more concise.  I'll take a stab at implementing
it.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
