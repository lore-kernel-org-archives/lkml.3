Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaGKQVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaGKQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:21:22 -0400
From: Paul Moore <pmoore@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
Date: Fri, 11 Jul 2014 12:21:19 -0400
Message-ID: <14055169.hesOIjNJgN@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1405095407.2357.1.camel@flatline.rdu.redhat.com>
References: <cover.1405023592.git.rgb@redhat.com> <1458762.ra4TnS54ZN@sifl> <1405095407.2357.1.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 12:16:47 PM Eric Paris wrote:
> On Fri, 2014-07-11 at 12:11 -0400, Paul Moore wrote:
> > On Thursday, July 10, 2014 09:06:02 PM H. Peter Anvin wrote:
> > > Incidentally: do seccomp users know that on an x86-64 system you can
> > > recevie system calls from any of the x86 architectures, regardless of
> > > how the program is invoked?  (This is unusual, so normally denying those
> > > "alien" calls is the right thing to do.)
> > 
> > I obviously can't speak for all seccomp users, but libseccomp handles this
> > by checking the seccomp_data->arch value at the start of the filter and
> > killing (by default) any non-native architectures.  If you want, you can
> > change this default behavior or add support for other architectures (e.g.
> > create a filter that allows both x86-64 and x32 but disallows x86, or any
> > combination of the three for that matter).
> 
> Maybe libseccomp does some HORRIFIC contortions under the hood, but the
> interface is crap...  Since seccomp_data->arch can't distinguish between
> X32 and X86_64.  If I write a seccomp filter which says
> 
> KILL arch != x86_64
> KILL init_module
> ALLOW everything else
> 
> I can still call init_module, I just have to use the X32 variant.
> 
> If libseccomp is translating:
> 
> KILL arch != x86_64 into:
> 
> KILL arch != x86_64
> KILL syscall_nr >= 2000
> 
> That's just showing how dumb the kernel interface is...   Good for you
> guys, but the kernel is just being dumb   :)

You're not going to hear me ever say that I like how the x32 ABI was done, it 
is a real mess from a seccomp filter point of view and we have to do some 
nasty stuff in libseccomp to make it all work correctly (see my comments on 
the libseccomp-devel list regarding my severe displeasure over x32), but 
what's done is done.

I think it's too late to change the x32 seccomp filter ABI.

-- 
paul moore
security and virtualization @ redhat

