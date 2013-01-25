Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3AYShH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:37:07 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63327 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3AYShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:37:02 -0500
Date: Fri, 25 Jan 2013 19:36:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jan Beulich <JBeulich@suse.com>, tglx@linutronix.de, mjg@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/debug] x86/EFI: Properly init-annotate BGRT code
Message-ID: <20130125183657.GB31022@gmail.com>
References: <50AFB29F02000078000AAE8E@nat28.tlf.novell.com>
 <tip-13f0e4d2b9e2209f13d5a4122478eb79e6136870@git.kernel.org>
 <20130124222820.GA11888@jtriplet-mobl1>
 <5102463602000078000B9761@nat28.tlf.novell.com>
 <20130125160309.GA15960@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125160309.GA15960@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Fri, Jan 25, 2013 at 07:45:42AM +0000, Jan Beulich wrote:
> > >>> On 24.01.13 at 23:28, Josh Triplett <josh@joshtriplett.org> wrote:
> > > On Thu, Jan 24, 2013 at 12:34:21PM -0800, tip-bot for Jan Beulich wrote:
> > >> Commit-ID:  13f0e4d2b9e2209f13d5a4122478eb79e6136870
> > >> Gitweb:     
> > > http://git.kernel.org/tip/13f0e4d2b9e2209f13d5a4122478eb79e6136870 
> > >> Author:     Jan Beulich <JBeulich@suse.com>
> > >> AuthorDate: Fri, 23 Nov 2012 16:30:07 +0000
> > >> Committer:  Ingo Molnar <mingo@kernel.org>
> > >> CommitDate: Thu, 24 Jan 2013 17:12:18 +0100
> > >> 
> > >> x86/EFI: Properly init-annotate BGRT code
> > >> 
> > >> These items are only ever referenced from initialization code.
> > > 
> > > Not true, and this patch will break the BGRT code.  bgrt_init, which
> > > does indeed have an __init annotation, stores bgrt_image and
> > > bgrt_image_size into the .private and .size fields of a sysfs
> > > bin_attribute, which does *not* have an __initdata annotation, and which
> > > will get read whenever the user reads the corresponding sysfs attribute.
> > 
> > Copying init-only data into a sysfs structure is no problem at all
> > - that structure obviously is non-__initdata and hence can be
> > read at any time. It was a different thing if .private and/or .size
> > stored _pointers_ to one of the two variables in question.
> 
> Ah, I see; the data itself gets kmalloc'd, and you just want 
> to discard the original pointer and size.  Fair enough.  Sorry 
> for the false alarm.

Ok - thanks for the clarification - I'll keep the commit as-is, 
agreed?

Thanks,

	Ingo
