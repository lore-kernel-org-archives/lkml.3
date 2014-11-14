Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161679AbaKNR1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:27:46 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45556 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161108AbaKNR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:27:45 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<1415917702-6742-2-git-send-email-khilman@kernel.org>
	<CAPDyKFou5iwX2Oe9K6n=2u6xRAqUtVNRrDn736oo0kGf0GgaLQ@mail.gmail.com>
Date: Fri, 14 Nov 2014 09:27:41 -0800
In-Reply-To: <CAPDyKFou5iwX2Oe9K6n=2u6xRAqUtVNRrDn736oo0kGf0GgaLQ@mail.gmail.com>
	(Ulf Hansson's message of "Fri, 14 Nov 2014 08:26:58 +0100")
Message-ID: <7hk32x8zg2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On 13 November 2014 23:28, Kevin Hilman <khilman@kernel.org> wrote:
>> From: Kevin Hilman <khilman@linaro.org>
>>
>> It makes little sense to use generic power domains without runtime PM.
>> Also, since the complexities of handling the !PM_RUNTIME case are
>> causing more trouble and confusion than they're worth, let's simplify
>> the world by making genpd always enable runtime PM.
>
> I do agree that your above statement seems reasonable, even if can't
> really tell if that would break some SOCs use-cases.

Break in what way?

> My concern is though, that I fear we will be taking short-cuts in
> genpd that might bite us later on, but I might be wrong.
>
> The reason for my concern is that on every other place, like in the
> subsystem level, driver core, PM core and of course in drivers -  we
> need to cope with all the combinations of CONFIG_PM_SLEEP and
> CONFIG_PM_SLEEP.  So theoretically, why shouldn't genpd be able to do
> that as well?

Good question, and one we need to figure out.  (I meant to mark this
patch as RFC for that reason.)

I think the primary question is: why would one want to use genpd without
runtime PM?

I understand why one might want to use/test drivers with various
combinations of PM_SLEEP and PM_RUNTIME, but I'm not seeing why we
should need to support genpd without PM_RUNTIME enabled.

In fact, on all the SoCs I've worked closely with, power domains,
suspend/resume and runtime PM are all so closely intertwined that I
can't imagine a useful scenario where they they are not all used
together.  If you care about PM, you turn them all on.  If you don't,
you turn them all off and ensure everything is enabled at boot.

IMO, we're spending a lot of cycles supporting these various
combinations and permutations and as a result are not really able to
solve the real problems people are raising.

Seems like most of the time a new feature/fixup/cleanup is proposed, the
discussion always ends up around how to support things when this or that
option is disabled, or some combination of kconfig options that weren't
considered.

I think we should simplify the config space permuations so we can focus
on improving the frameworks.

Kevin
