Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3GUMtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 08:49:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58496 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab3GUMta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 08:49:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: viresh.kumar@linaro.org,
        Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com,
        stern@rowland.harvard.edu, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
Date: Sun, 21 Jul 2013 14:59:26 +0200
Message-ID: <1534467.dElB1LkqvC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51EB9F3E.70608@linux.vnet.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51E6BD0E.1020101@linux.vnet.ibm.com> <51EB9F3E.70608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 21, 2013 02:13:42 PM Srivatsa S. Bhat wrote:
> On 07/17/2013 09:19 PM, Srivatsa S. Bhat wrote:
> > On 07/17/2013 08:57 PM, Toralf Förster wrote:
> >> On 07/16/2013 11:32 PM, Rafael J. Wysocki wrote:
> >>> On Tuesday, July 16, 2013 05:15:14 PM Toralf Förster wrote:
> [...]
> >>>> sry - here again with full quote of the email :
> >>>>
> >>>> I applied patch [1/8] on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup
> >>>> cycles fine and crashed the system at the 3rd attempt / one times just at
> >>>> the 4th (blinking power led, no sysrq, ...).
> >>>>
> >>>> Applying patch 1-8 on top of that tree differs in that way that it
> >>>> crashes now the system even at the 1st attempt or at least at the 2nd
> >>>>
> >>>> My hardware is a ThinkPad T420 with latest BIOS and a 32 bit stable
> >>>> Gentoo Linux - FWIW .config attached.
> >>>
> >>> I think you'll need the fixes first, basically [1/8] from this series and
> >>> this: https://patchwork.kernel.org/patch/2827512/ .
> >>>
> >>> Please try to run with these two things applied only and see how that goes.
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>>
> >> That was it.
> >>
> >> Applying https://patchwork.kernel.org/patch/2827512/ and then patch
> >> [1/8] on top of v3.11-rc1-8-g47188d3 works fine and solved the reported
> >> issue.
> >>
> >> Furthermore applying patches 2-8 works too - suspend/wakeup works fine
> >> and frequencies are scaled right after wakeup at the T420.
> >>
> > 
> > Phew! Finally :-)
> > 
> > Thank you for all your testing efforts!
> > 
> 
> Rafael, Viresh, any thoughts on picking up patches 2-8 from this series
> for 3.12?
> 
> From the discussions on this thread so far, there are no pending issues:
> Toralf verified that these patches work fine on his system, as he mentioned
> above, and Tianyu Lan independently tested this patchset and found no
> issues with them. Also, Viresh analyzed the refcounting used in the patches
> and we came to the conclusion that there is no problem with them either.

Yes, I'm going to queue up that series for 3.12.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
