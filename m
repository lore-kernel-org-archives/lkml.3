Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaHFSxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:53:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49162 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752989AbaHFSxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:53:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: Re: [PATCH] ACPI/Processor: Add CPU_STARTING_FROZEN check in the acpi_cpu_soft_notify()
Date: Wed, 06 Aug 2014 21:11:59 +0200
Message-ID: <1764446.983W79QKlC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53E19AAD.4070308@intel.com>
References: <1406798426-16483-1-git-send-email-tianyu.lan@intel.com> <2440957.I2MrVyXYIg@vostro.rjw.lan> <53E19AAD.4070308@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 06, 2014 11:02:05 AM Lan Tianyu wrote:
> On 2014年08月06日 09:30, Rafael J. Wysocki wrote:
> > On Friday, August 01, 2014 10:51:46 AM Lan Tianyu wrote:
> >> On 2014年08月01日 05:20, Rafael J. Wysocki wrote:
> >>> On Thursday, July 31, 2014 05:20:26 PM Lan Tianyu wrote:
> >>>> The callback of CPU_STARTING event can't sleep and so acpi_cpu_soft_notify()
> >>>> return directly when CPU_STARTING event is triggered. But cpu hotplug also
> >>>> happens during S2RAM. The action will become CPU_STARTING_FROZEN. This
> >>>> patch is to fix missing check the frozen event.
> > 
> > OK
> > 
> > What's the impact of the bug you're fixing?  Do we sleep when we shouldn't?
> > 
> > In particular, are there any bugs reported that are related to it?
> 
> So far, there is such bug report. I found the issue when test my patch
> of parallel non-boot cpu up with resuming device for S2RAM. Because
> original code will wait all cpu up and then do other resume task, the
> semaphore of ACPICA can always be get in the cpu notify callback and it
> will not fall in the sleep. It's different situation for paralleling
> non-boot cpu. The lock will be held by other threads and fall into
> sleep. Further thinking, this may not cause bug in the old kernel and it
> isn't needed by stable tree but the code should consider cpu frozen event.

OK, so we don't need to propagate this to -stable I'd say.

I'll queue it up for the second 3.17 pull request.

Rafael

