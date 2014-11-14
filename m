Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422917AbaKNWUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:20:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58482 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422682AbaKNWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:20:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled
Date: Fri, 14 Nov 2014 23:41:15 +0100
Message-ID: <5229811.LXthdvUIfI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7ha93t8z1q.fsf@deeprootsystems.com>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org> <CAMuHMdXB-7vBqGZ_iMaZdDWDnnzpHZa4ECkDnojbDw=ds5eTWg@mail.gmail.com> <7ha93t8z1q.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 09:36:17 AM Kevin Hilman wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> 
> > Hi Kevin,
> >
> > On Thu, Nov 13, 2014 at 11:28 PM, Kevin Hilman <khilman@kernel.org> wrote:
> >> It makes little sense to use generic power domains without runtime PM.
> >
> > Does it?
> > It still powers down the PM domains on system suspend (at least on my
> > boards ;-)
> 
> Sure, but your devices are also using runtime PM, so I'm not sure how
> does that change my statement above?

Questions here are (1) how many users will actually want to disable PM_RUNTIME
for systems using genpd (my sort of educated guess is "none") and (2) whether
or not we need to power up stuff dynamically during initialization on systems
using genpd (and several recent discussions indicate that the answer here is
"yes, we need to do that").

> >> Also, since the complexities of handling the !PM_RUNTIME case are
> >> causing more trouble and confusion than they're worth, let's simplify
> >> the world by making genpd always enable runtime PM.
> >
> > What do other people think?
> 
> Yes, I'm curious also.  This patch was supposed to be marked RFC.

I'm totally for making this change and I'm going to queue up this patch for
3.19, so if anyone sees a really good reason for not doing this, please let
me know what that reason is as soon as you can.

Rafael

