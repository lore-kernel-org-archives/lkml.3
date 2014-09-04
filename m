Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaIDTgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:36:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64971 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755166AbaIDTgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:36:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
Date: Thu, 04 Sep 2014 21:56:12 +0200
Message-ID: <2699050.43LHVsRP52@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomH=ODnDT1FxrGVLOiOpA9NecQR134tUKQk-bRXLGPRYw@mail.gmail.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <540838DB.1070202@linux.vnet.ibm.com> <CAKohpomH=ODnDT1FxrGVLOiOpA9NecQR134tUKQk-bRXLGPRYw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 04, 2014 04:07:28 PM Viresh Kumar wrote:
> On 4 September 2014 15:33, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> > I think Rafael's point was that since no driver that had implemented the
> > target_index callback was using it at the time that this patch was
> > proposed, it was be best to couple the check on existence of stop_cpu
> > callback with the the check on the kind of cpufreq driver. However
> > powerpc is also in need of this today and we implement the target_index
> > callback and find it convenient to use the stop CPU callback.
> 
> No, this is what he said..
> 
> "
> So to me, (1) the new ->stop() should *only* be called for ->setpolicy drivers,
> because the purpose of it should be to "allow ->setpolicy drivers to do what the
> GOV_STOP will do for regular drivers"
> "
> 
> > Rafael, in which case would it not make sense to remove the check on
> > driver->setpolicy above?
> >
> > Besides, I don't understand very well why we had this double check in
> > the first place. Only if the drivers are in need of the functionality
> > like stop_cpu, would they have implemented this callback right? If we
> > are to assume that the drivers which have implemented the target_index
> > callback should never be needing it, they would not have implemented the
> > stop CPU callback either. So what was that, which was blatantly wrong
> > with just having a check on stop_cpu? I did go through the discussion
> > but did not find a convincing answer to this.
> 
> The idea was to get something similar to GOV_STOP for setpolicy drivers.
> But in the end we didn't get to that. What we do in GOV_STOP is stop
> changing CPUs frequency, but here in stop_cpu() we can stop changing
> CPUs frequency OR take it to minimum, whatever we want..
> 
> As I said earlier, probably we should just do what you did in your patch +
> some documentation changes.

OK, if that works for everybody.  For one, I wouldn't like to end up with a
callback used for different things in every drvier implementing it.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
