Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3H3Fy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:54:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52215 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3H3Fy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:54:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1844wO7YIHutG60mB04U3ZB
Date: Thu, 29 Aug 2013 22:54:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
Message-ID: <20130830055422.GS7656@atomide.com>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
 <1377150793-27864-4-git-send-email-mturquette@linaro.org>
 <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org>
 <20130829011425.8231.78802@quantum>
 <521EF109.3010500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521EF109.3010500@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tero Kristo <t-kristo@ti.com> [130829 00:06]:
> On 08/29/2013 04:14 AM, Mike Turquette wrote:
> >
> >The mux-clock binding covers a quite a few platforms that have similar
> >mux-clock programming requirements. If the DT binding is verbose enough
> >then the basic mux clock driver is sufficient to initialize all of the
> >mux clocks from DT: no new platform-specific clock driver with a bunch
> >of data is necessary.
> >
> >On the other hand if we rely on tables in C to define how mux-clock
> >parents are selected then every platform will have to write their own
> >clock driver just to define their clock data.
> >
> >Having drivers written for the sole purpose of listing out a bunch of
> >data sounds like something that DT was meant to solve, even if this
> >isn't at the board level and is at the SoC level.
> 
> +1. For my work this helps quite a bit at least.

Yes this is the way to do it. Please don't do drivers where the index
to some data table is passed in device tree. That's going to be a
nightmare in the long run.

The binding should describe a type of hardware like a dpll or a mux,
and then you just define as many instances of those as needed in the
.dts files.

Regards,

Tony
