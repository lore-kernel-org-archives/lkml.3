Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaLSBzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:55:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58586 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751211AbaLSBzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:55:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        amit daniel kachhap <amit.daniel@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API pm_genpd_dev_need_restore to use restore types
Date: Fri, 19 Dec 2014 03:17:32 +0100
Message-ID: <4455852.nsjCIYrEMg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5492A6DE.5020704@samsung.com>
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com> <5418986.E58ik2Q1Hm@vostro.rjw.lan> <5492A6DE.5020704@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 11:05:18 AM Sylwester Nawrocki wrote:
> On 18/12/14 01:58, Rafael J. Wysocki wrote:
> >>>> What's needed to solve this problem is a generalized way to have runtime
> >>>> > >> PM dependencies between devices.  Runtime PM already automatically
> >>>> > >> handles parent devices as one type of dependent device (e.g. a parent
> >>>> > >> device needs to be runtime PM resumed before its child.)  So what's
> >>>> > >> needed is a generic way to other PM dependencies with the runtime PM
> >>>> > >> core (not the genpd core.)
> >>> > >
> >>> > > Considering the example above with three devices, device D1 and D2 are
> >>> > > passive components in this power domain. These devices only need to
> >>> > > know the state changes of the power domains but would not control the
> >>> > > power domain themselves nor put forth constraints in the power domain
> >>> > > state changes. So I did not clearly understand as to how this example
> >>> > > could be solved by introducing changes in runtime PM core.
> >> > 
> >> > Your solution only solves the problems for devices managed by genpd.
> >> > 
> >> > If I understood your example correctly, what you really want to solve
> >> > this problem more generically is to be able to tell the runtime PM core
> >> > that D3 has a dependency on D1 and D2.  Then, whenver the runtime PM
> >> > core is doing get/put operations for D3, it needs to also do them for D1
> >> > and D2.
> 
> Indeed, I think it would solve most of the problems if we were able to
> model the PM dependencies between devices which would then be handled
> in the PM core.  I recall something like this has been proposed a while
> ago [1].

Exactly.

And I'm going to revive it in a slightly simplified form.

> >> > This will accomplish the same as your proposed approach, but work for
> >> > any devices in any PM domains.
> >
> > Plus, it is not limited to runtime PM, really.  It affects system suspend
> > too.
> 
> [1] https://lkml.org/lkml/2009/8/26/485
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
