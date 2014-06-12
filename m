Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaFLH31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:29:27 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60728 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaFLH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140611165027.6562.64928@quantum>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-2-git-send-email-tushar.b@samsung.com>
	<20140611165027.6562.64928@quantum>
Date: Thu, 12 Jun 2014 12:59:23 +0530
X-Google-Sender-Auth: Jn3EZFuGuZfb2hUdZx79pQspV40
Message-ID: <CAC5m3BwR9WhiiDqUw1A6FjmzAnQ02xCBxOeAaY2nt3CRqTz+oQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss
 always enabled
From: Tushar Behera <tushar.b@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        ML Devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ML Arch-Arm <linux-arm-kernel@lists.infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, Doug Anderson <dianders@google.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:20 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Tushar Behera (2014-06-10 22:32:17)
>> When the output clock of AUDSS mux is disabled, we are getting kernel
>> oops while doing a clk_get() on other clocks provided by AUDSS. Though
>> user manual doesn't specify this dependency, we came across this issue
>> while disabling the parent of AUDSS mux clocks.
>
> Hi Tushar,
>
> Can you help me understand better what the actual problem is? What is
> the root cause of the kernel oops?

Currently AUDSS mux has two parents, XXTI crystal and MAU_EPLL clock.
As per observation, when the output of AUDSS mux is gated, we are not
able to do any operation on the clocks provided by MAU block (mostly
the clocks used by ADMA and audio blocks).

>
> You mention calling clk_get on child clocks of the AUDSS mux fails, but
> I cannot imagine why. How can the enable/disable state of a clock affect
> the ability to clk_get other clocks?
>

I might have a little vogue while updating the commit message
(mentioning about clk_get which surely is only a s/w operation), but
there is definitely some issue with handling those clocks under given
scenario.

I am on leave till end of this week, so I will update you more with
the logs on Monday.

Thanks,
--
Tushar
