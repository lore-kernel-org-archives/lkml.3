Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaABI2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:28:32 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38320 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaABI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:28:30 -0500
Date: Thu, 2 Jan 2014 09:28:23 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: Oleg Nesterov <oleg@redhat.com>, mtk.manpages@gmail.com,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
Message-ID: <20140102092823.2434c96f@mschwide>
In-Reply-To: <52C486BC.50603@landley.net>
References: <1388025009.1176.17@driftwood>
	<20131227144504.GA17192@redhat.com>
	<20131230095656.4c78dd98@mschwide>
	<20131230151110.GA29636@redhat.com>
	<20131230162617.1b013251@mschwide>
	<52C396E3.5080000@landley.net>
	<20140101134121.79787caf@mschwide>
	<52C486BC.50603@landley.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010208-1948-0000-0000-0000075CB10B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jan 2014 15:21:00 -0600
Rob Landley <rob@landley.net> wrote:

> On 01/01/14 06:41, Martin Schwidefsky wrote:
> > On Tue, 31 Dec 2013 22:17:39 -0600
> > Rob Landley <rob@landley.net> wrote:
> >
> >> On 12/30/13 09:26, Martin Schwidefsky wrote:
> >>> On Mon, 30 Dec 2013 16:11:10 +0100
> >>> Oleg Nesterov <oleg@redhat.com> wrote:
> >>>> Not sure I understand... except that timekeeping_resume() does
> >>>> __timekeeping_inject_sleeptime().
> >>>
> >>> Hmm, you are right. The sleeptime is added to the monotonic boottime.
> >>> So the first value of /proc/uptime is the wall-time since boot.
> >>> And the second value is combined idle time over all cpus.
> >>
> >> Is there an obvious way to query the non-suspend uptime from userspace?
> >
> > clock_gettime with CLOCK_MONOTONIC gives you the uptime minus without the
> > suspend time.
> 
> Given that the clock_gettime man page says:
> 
>    CLOCK_MONOTONIC
>      Clock that cannot be set and  represents  monotonic  time  since
>      some unspecified starting point.
> 
> Can I rely on it _continuing_ to do so in future, and if so should the 
> man page be clarified?

Good point. CLOCK_MONOTONIC is implemented in a specific way now and I
doubt that this will change any time soon, but you have no guarantee that
it will keep the property 'monotonic-time = uptime - suspend-time'.
You can not use the values in /proc/stat either as you can set any CPU
offline, which means that no CPU line contains all ticks since boot.

Without the CLOCK_MONOTONIC option I do not see a way how to get the
non-suspend uptime from user space.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

