Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaKRPaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:30:04 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:61024 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbaKRPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411180115420.3909@nanos>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
	<1416251225-17721-14-git-send-email-eranian@google.com>
	<20141117230232.GC25157@pd.tnic>
	<alpine.DEB.2.11.1411180025270.3909@nanos>
	<20141117235841.GD25157@pd.tnic>
	<alpine.DEB.2.11.1411180115420.3909@nanos>
Date: Tue, 18 Nov 2014 16:29:59 +0100
Message-ID: <CABPqkBQp36s=cKgy0e9hpARgY=z1AucXyToBVtykOvyuAr8AyQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 18, 2014 at 1:31 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, 18 Nov 2014, Borislav Petkov wrote:
> > On Tue, Nov 18, 2014 at 12:38:14AM +0100, Thomas Gleixner wrote:
> > > Well a bitmask is a pretty indescriptive item as well. Putting my user
> > > hat on: Where is the documentation for the bits?
> >
> > $ cat /sys/devices/system/cpu/bugs
> > 0xXXXXXX - currently enabled workarounds are the set bits.
> > bit 0: workaround for bug#blabla
> > bit 1: workaround for bug#1
> > bit 2: workaround for bug#2; remember to do <bla> before disabling workaround
> > ...
> > bits n-63 are reserved, cannot be set and RAZ.
>
> You sure that 64 are enough?
>
> You need to create stable but numbers, i.e. each bug gets a fixed but
> number whethr it affects the machine or not. Otherwise you will drive
> admins completely nuts.
>
> > This will be issued when user cats the sysfs file.
>
> That might work as well, though you want that to be:
>
>   /sys/devices/system/cpu/bugs/
>
>   /sys/devices/system/cpu/bugs/status
>
>   /sys/devices/system/cpu/bugs/enable_workaround
>
>   /sys/devices/system/cpu/bugs/disable_workaround
>
>   The latter two take a bit number rather than a magic mask.
>
I am trying to get a better understanding of this scheme.

status:
  - a summary of what is enabled/disabled?
  - With description (as suggested by Boris)?
  - File is readonly
  - is that printing a variable length bitmask?

enable_workaround:
   - provide the bit number (of the workaround) to enable the workaround
   - File is write-only

disable_workaround:
   - provide the bit number (of the workaround) to disable the workaround
   - File is write-only

The split enable/disable is to avoid the read-modify-write issue.

Am I getting this right?

I understand the value of this proposition. But, I feel,  it is beyond the scope
of the patch series to workaround the PMU bug. Initially, we had
talked about not
even providing the sysfs file. Now, the series adjusts the workaround
on boot. The series is restructured so that the sysfs patch is the last
one and is totally optional. I think we should implement the proposed scheme
but we should not delay the review and merge of the rest of the patch series
for this. But I can propose a separate patch series to implement the proposed
scheme.

> So while it looks less effort to implement and extend in the first
> place I think, that a bit of infrastructure work will make the
> explicit scheme I proposed before a no brainer to maintain and extend,
> but I cannot judge what's more intuitive to use.
>
> Thanks,
>
>         tglx
>
>
>
