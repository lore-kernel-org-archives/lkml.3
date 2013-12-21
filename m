Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3LUBZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:25:36 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:34659 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3LUBZc (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 20 Dec 2013 20:25:32 -0500
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
In-Reply-To: <52B4B0ED.7030600@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>
	 <20131220103755.GA14784@pd.tnic> <1387552463.17961.2.camel@x230>
	 <52B4B0ED.7030600@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Dec 2013 09:24:02 +0800
Message-ID: <1387589042.3539.4901.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2013-12-20 於 13:04 -0800，H. Peter Anvin 提到：
> On 12/20/2013 07:14 AM, Matthew Garrett wrote:
> > On Fri, 2013-12-20 at 11:37 +0100, Borislav Petkov wrote:
> >> On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
> >>> On 12/19/2013 08:24 PM, joeyli wrote:
> >>>> I agreed, but userspace application should not be too often to access
> >>>> RTC. Maybe only when system boot and set timezone.
> >>>
> >>> This is, quite frankly, an idiotic argument.
> >>
> >> TBH, I've been struggling with the question too - and it might even be a
> >> stupid question - but what is that absolute need to be able to get the
> >> TZ in userspace? Why should I care?
> >>
> >> Can we get some use cases for stupid people like me please?
> > 
> > Dual-boot environments will tend to have the RTC in local time, not UTC.
> > That means that userspace has to reprogram the clock over daylight
> > savings changes, and to do that it must know whether another OS has
> > already done so.
> > 
> 
> Actually, it doesn't have to reprogram the clock ... it just needs to
> know if another OS has already done so.  All Linux needs to do is to be
> able to derive UTC from whatever the RTC is set to and to be able to
> keep it consistent.
> 
> 	-hpa
> 
> 

It's dependent on a right boot initial priority of distribution.
Here have a discussion of adjusting system clock by TZ (from ACPI or
UEFI):
Discussion on BIOS/CMOS/UEFI clock in local time
	http://www.spinics.net/lists/util-linux-ng/msg07639.html

and,
from Ted Ts'o in the mail thread
     https://lkml.org/lkml/2008/1/8/195


If kernel use the TZ field from ACPI TAD or EFI to adjust system
clock when booting, then it can avoid buggy distributions adjust
system clock AFTER e2fsck is run.

Using ACPI TAD should after DSDT parsing in subsystem initial stage,
so I choice EFI time services before we can move DSDT parser to
start_kernel().


Thanks a lot!
Joey Lee

