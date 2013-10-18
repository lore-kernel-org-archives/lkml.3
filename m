Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3JRMjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab3JRMjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:39:10 -0400
Date: Fri, 18 Oct 2013 08:38:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131018123837.GB2277@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
 <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
 <20131015144810.GI31215@redhat.com>
 <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 08:50:07PM -0700, Yinghai Lu wrote:

[..]
> > Previously high reservation (reservation above 896M) will anyway fail. So
> > instead of failing, if we try reservation in higher memory areas why that
> > would break old kexec-tools?
> 
> If thel old kexec-tools would fail, we should let them fail early as possible,
> do not reserve at first point.

A user does not care if they get the message "memory nor reserved" or if
they get the message that "could not find a suitable memory hole at
address X".

> 
> >
> > IOW, previously anyway kexec-tools will not work as no memory will be
> > reserved in higher memory area. Now memory will be reserved but old
> > kexec-tools should fail as it can't load in that area.
> >
> > If that works, then one would use crashkernel=X,high only if he is
> > particualr that memory reservation comes from area above 4G (despite
> > the fact that same memory could have been reserved below 4G too).
> 
> My point:
> Push user to use ",high" as more as possible, so we only to handle one
> path eventually.
> for old kernel, leave them to use old grammer. do not need to change it.

I don't understand this. Why we should push users to use ",high" syntax.
That is an option. Those who want to use it, should use it.

We have been using crashkernel=XM for a long time now. And it makes sense
to extend this option to be able to reserve memory at higher addresses
if asked memory is not available at lower addresses.

You are not thinking about ease of use here for existing users.

> 
> Also boot loader should always have different entry for old kernel and
> new kernel.

What does memory reservation location has to do with kernel entry point?
If it is a 64bit bzImage, we will use 64bit entry point by default, isn't
it? Does not matter whether memory is reserved above 4G or not.

I think it makes sense that existing crashkernel=XM usres be able to
reserve memory in higher memory area if sufficient memory is not available
below 896M or below 4G. Those who always want memory reservation above 4G
they should use ",high" syntax and enforce memory allocation above 4G.

Thanks
Vivek
