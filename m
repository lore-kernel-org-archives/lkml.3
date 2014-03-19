Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbaCSAiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:38:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60486 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757935AbaCSAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:38:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        patrick.marlier@gmail.com, viresh.kumar@linaro.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v3 0/2] Add stop callback to the cpufreq_driver interface.
Date: Wed, 19 Mar 2014 01:53:40 +0100
Message-ID: <5240506.FBRh89S9Lg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53289D9A.8070805@gmail.com>
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <532899B2.2060106@linux.vnet.ibm.com> <53289D9A.8070805@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2014 12:25:14 PM Dirk Brandewie wrote:
> On 03/18/2014 12:08 PM, Srivatsa S. Bhat wrote:
> > On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
> >> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> >>
> >
> > I don't mean to nitpick, but generally its easier to deal with
> > patchsets if you post the subsequent versions in fresh email threads.
> > Otherwise it can get a bit muddled along with too many other email
> > discussions in the same thread :-(
> >
> >> Changes:
> >> v2->v3
> >> Changed the calling of the ->stop() callback to be conditional on the
> >> core being the last core controlled by a given policy.
> >>
> >
> > Wait, why? I'm sorry if I am not catching up with the discussions on
> > this issue quickly enough, but I don't see why we should make it
> > conditional on _that_. I thought we agreed that we should make it
> > conditional in the sense that ->stop() should be invoked only for
> > ->setpolicy drivers, right?
> 
> This was done at Viresh's suggestion since thought there might be value
> for ->target drivers.
> 
> Any of the options work for me
>     called only for set_policy scaling drivers

And that's what we should do *today* in my opinion, unless we want to add
it to any ->target() drivers *right* now.  Do we want that?

Rafael

