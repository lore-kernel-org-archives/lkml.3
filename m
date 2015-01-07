Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbbAGJMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:12:07 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:63821 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbbAGJMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:12:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH v2 4/5] clk: cygnus: add clock support for Broadcom Cygnus
Date: Wed, 07 Jan 2015 10:11:38 +0100
Message-ID: <2938966.fY2WjearG6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AC99F3.8040703@broadcom.com>
References: <1420500076-18302-5-git-send-email-rjui@broadcom.com> <2048376.BFrtW5tszK@wuerfel> <54AC99F3.8040703@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:IaKutGd4qvQ8R+Ff/mK7oMKJ1ImTC4vDTcCD9NyDmc7X4oaFPKM
 0lHsE65t1jap8wP4O1tM1YnXeG/YTd9c7fj1vTeYeZPXT2r3wP/LCUrwXXqsJfG1ywqSqEM
 RlgE++QShPA9/TXYEbIofY5Wj1UEQ799tY/t9ZlRLQgvSeRhwNhwMaENJVNLXahn51D9SFN
 4NJcgbReb+nE4VoFh1uvA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 18:29:07 Ray Jui wrote:
> On 1/6/2015 12:21 PM, Arnd Bergmann wrote:
> > On Monday 05 January 2015 15:21:15 Ray Jui wrote:
> > 
> > The tables look fairly regular. Is it possible that it's common
> > to all iproc variants with a standard way to derive all other
> > values from the channel index?
> > 
> Ah no. Not only it's different between different iproc variants, it's
> also different between plls on the same soc.

Ok, I see.
 
> >> +static const struct iproc_asiu_gate asiu_gate[BCM_CYGNUS_NUM_ASIU_CLKS] = {
> >> +	[BCM_CYGNUS_ASIU_KEYPAD_CLK] =
> >> +		asiu_gate_val(0x0, 7),
> >> +	[BCM_CYGNUS_ASIU_ADC_CLK] =
> >> +		asiu_gate_val(0x0, 9),
> >> +	[BCM_CYGNUS_ASIU_PWM_CLK] =
> >> +		asiu_gate_val(IPROC_CLK_INVALID_OFFSET, 0),
> >> +};
> > 
> > Here I think a better binding would be to pass the gate value in the
> > clock specifier, rather than an artificial index. That would let
> > you get rid of the BCM_CYGNUS_ASIU_KEYPAD_CLK/BCM_CYGNUS_ASIU_ADC_CLK
> > macros.
> > 
> You meant to pass in both the gate register offset and its bit shift
> through the clock specifier? But isn't the current ASIU clock code much
> more consistent with the rest of the iProc clock code?

For simple devices that don't need an index macro, I would always
prefer not defining them, because they are a pain to maintain.
For a simple gate clock controller, we could compute both the offset
and bit number from a single integer.

However, I now saw upon taking a closer look that the asiu has both
a gate and a divider, and the latter one is not as simple, so
my comment doesn't apply here.

	Arnd
