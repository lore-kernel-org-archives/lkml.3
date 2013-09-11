Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3IKNR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:17:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44913 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab3IKNRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:17:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Greg KH <greg@kroah.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers" breaks cpufreq too
Date: Wed, 11 Sep 2013 15:28:26 +0200
Message-ID: <11617025.s66NV700Er@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1309111015190.26942@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange> <CAKohpokaHU0V86DPB7nEQ8ndwu_mJ_x_Uz47XPHZeyAW3hcP_w@mail.gmail.com> <Pine.LNX.4.64.1309111015190.26942@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 11, 2013 10:15:53 AM Guennadi Liakhovetski wrote:
> On Wed, 11 Sep 2013, Viresh Kumar wrote:
> 
> > On 10 September 2013 22:37, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > On Tue, 10 Sep 2013, Viresh Kumar wrote:
> > >> Quite straight forward actually..
> > >
> > > Apparently, not quite.
> > 
> > I overlooked the situation where we return early from ->target() routines.. :(
> > 
> > Please try attached patches, I will repost them later (once I am able to
> > convince Rafael that these are really important :) )
> 
> I'd rather wait until Rafael is convinced, then we'll see.

I'm going to revert the commit that was the source of these issues, but that
doesn't mean that everything is now rosy.  We need to fix the concurrency
problems that Viresh was trying to fix in that commit, so it would be nice if
you could verify whether or not he is on the right track.

Thanks,
Rafael

