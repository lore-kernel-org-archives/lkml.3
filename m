Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab3CYUzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab3CYUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:55:48 -0400
From: Paul Moore <pmoore@redhat.com>
To: "H.J. Lu" <hjl.tools@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org,
        coreyb@linux.vnet.ibm.com, wad@chromium.org
Subject: Re: [PATCH] x86: remove the x32 syscall bitmask from syscall_get_nr()
Date: Mon, 25 Mar 2013 16:55:17 -0400
Message-ID: <1729301.D1jGz2qpIc@sifl>
Organization: Red Hat
User-Agent: KMail/4.10.1 (Linux/3.7.9-gentoo; KDE/4.10.1; x86_64; ; )
In-Reply-To: <CAMe9rOriYUYVmef36PVuZn5LWtthryj3n7vRzXRObC_ZkcVuqQ@mail.gmail.com>
References: <20130215172143.12549.10292.stgit@localhost> <5143990B.9000007@zytor.com> <CAMe9rOriYUYVmef36PVuZn5LWtthryj3n7vRzXRObC_ZkcVuqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 03:18:12 PM H.J. Lu wrote:
> On Fri, Mar 15, 2013 at 2:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 03/15/2013 02:15 PM, Paul Moore wrote:
> >> On Tuesday, February 26, 2013 03:58:23 PM Paul Moore wrote:
> >>> On Friday, February 15, 2013 12:21:43 PM Paul Moore wrote:
> >>>> Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
> >>>> implementation by creating a syscall bitmask, equal to 0x40000000, that
> >>>> could be applied to x32 syscalls such that the masked syscall number
> >>>> would be the same as a x86_64 syscall.  While that patch was a nice
> >>>> way to simplify the code, it went a bit too far by adding the mask to
> >>>> syscall_get_nr(); returning the masked syscall numbers can cause
> >>>> confusion with callers that expect syscall numbers matching the x32
> >>>> ABI, e.g. unmasked syscall numbers.
> >>>> 
> >>>> This patch fixes this by simply removing the mask from syscall_get_nr()
> >>>> while preserving the other changes from the original commit.  While
> >>>> there are several syscall_get_nr() callers in the kernel, most simply
> >>>> check that the syscall number is greater than zero, in this case this
> >>>> patch will have no effect.  Of those remaining callers, they appear
> >>>> to be few, seccomp and ftrace, and from my testing of seccomp without
> >>>> this patch the original commit definitely breaks things; the seccomp
> >>>> filter does not correctly filter the syscalls due to the difference in
> >>>> syscall numbers in the BPF filter and the value from syscall_get_nr().
> >>>> Applying this patch restores the seccomp BPF filter functionality on
> >>>> x32.
> >>>> 
> >>>> I've tested this patch with the seccomp BPF filters as well as ftrace
> >>>> and everything looks reasonable to me; needless to say general usage
> >>>> seemed fine as well.
> >>> 
> >>> I just wanted to check and see where things stood with this patch.  I'm
> >>> not
> >>> overly concerned about how this problem is solved, just that it is
> >>> solved.
> >>> If someone else has a better approach that is fine with me; I'll even
> >>> make
> >>> the offer to do additional testing if needed.
> >> 
> >> Anyone?  The seccomp filter bits are completely broken on x32 and I'd
> >> like to get this fixed, if not with this patch then something else - I'm
> >> more than happy to test/verify/etc whatever solution is deemed best ...
> > 
> > Seems good to me -- H.J., do you seen any problem with this?
> 
> It looks OK to me.

Great, any chance of getting this fix merged for 3.9?

-- 
paul moore
security and virtualization @ redhat

