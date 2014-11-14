Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaKNWOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:14:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52147 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754365AbaKNWOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:14:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled
Date: Fri, 14 Nov 2014 23:35:15 +0100
Message-ID: <4140203.PSBUkRm4dz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7hk32x8zg2.fsf@deeprootsystems.com>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org> <CAPDyKFou5iwX2Oe9K6n=2u6xRAqUtVNRrDn736oo0kGf0GgaLQ@mail.gmail.com> <7hk32x8zg2.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 09:27:41 AM Kevin Hilman wrote:
> Hi Ulf,
> 
> Ulf Hansson <ulf.hansson@linaro.org> writes:
> 
> > On 13 November 2014 23:28, Kevin Hilman <khilman@kernel.org> wrote:
> >> From: Kevin Hilman <khilman@linaro.org>
> >>
> >> It makes little sense to use generic power domains without runtime PM.
> >> Also, since the complexities of handling the !PM_RUNTIME case are
> >> causing more trouble and confusion than they're worth, let's simplify
> >> the world by making genpd always enable runtime PM.
> >
> > I do agree that your above statement seems reasonable, even if can't
> > really tell if that would break some SOCs use-cases.
> 
> Break in what way?
> 
> > My concern is though, that I fear we will be taking short-cuts in
> > genpd that might bite us later on, but I might be wrong.
> >
> > The reason for my concern is that on every other place, like in the
> > subsystem level, driver core, PM core and of course in drivers -  we
> > need to cope with all the combinations of CONFIG_PM_SLEEP and
> > CONFIG_PM_SLEEP.  So theoretically, why shouldn't genpd be able to do
> > that as well?
> 
> Good question, and one we need to figure out.  (I meant to mark this
> patch as RFC for that reason.)
> 
> I think the primary question is: why would one want to use genpd without
> runtime PM?
> 
> I understand why one might want to use/test drivers with various
> combinations of PM_SLEEP and PM_RUNTIME, but I'm not seeing why we
> should need to support genpd without PM_RUNTIME enabled.
> 
> In fact, on all the SoCs I've worked closely with, power domains,
> suspend/resume and runtime PM are all so closely intertwined that I
> can't imagine a useful scenario where they they are not all used
> together.  If you care about PM, you turn them all on.  If you don't,
> you turn them all off and ensure everything is enabled at boot.
> 
> IMO, we're spending a lot of cycles supporting these various
> combinations and permutations and as a result are not really able to
> solve the real problems people are raising.
> 
> Seems like most of the time a new feature/fixup/cleanup is proposed, the
> discussion always ends up around how to support things when this or that
> option is disabled, or some combination of kconfig options that weren't
> considered.
> 
> I think we should simplify the config space permuations so we can focus
> on improving the frameworks.

Moreover, recently we've spend quite some time on discussing pretty much
how to do runtime PM for CONFIG_PM_RUNTIME unset and really the conclusion
to me is "Don't do that".

There evidently are systems that require runtime PM (in some form) for basic
functionality and it looks like all systems using genpd will fall into that
category, more or less.  Now, the runtime PM framework is what we have for
handling this kind of stuff and I don't see a reason to pretend that it may
be unnecessary.

Rafael

