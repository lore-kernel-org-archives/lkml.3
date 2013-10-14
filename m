Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3JNSZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:25:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38062 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3JNSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:25:34 -0400
Date: Mon, 14 Oct 2013 20:24:15 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: ebiederm@xmission.com
Cc: hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131014182415.GF3626@debian70-amd64.local.net-space.pl>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
 <877gdkce6s.fsf@tw-ebiederman.twitter.com>
 <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
 <877gdjbgj9.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gdjbgj9.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:15:38PM -0700, ebiederm@xmission.com wrote:
> Daniel Kiper <daniel.kiper@oracle.com> writes:
>
> > On Fri, Oct 11, 2013 at 03:08:43AM -0700, ebiederm@xmission.com wrote:
> >> Daniel Kiper <daniel.kiper@oracle.com> writes:

[...]

> > What is your opinion in that case?
>
> I can see documenting the registers other than the stack pointer
> as undefined.  (A stack pointer is needed to implement PIC code).
>
> For the implementation I recommend setting these registers to known
> values.  The issue is that your implementation will not change much and
> if you don't set the registers to known values someone may develop a
> dependency on what you happen to have those registers set to.
>
> It is easier to force a fixed value into a register that isn't hard to
> maintain into your registers than to discover when you make a change
> that there is some odd client that depends on some value that just
> happened to be in your register, and that your necessary change is now
> made 10x harder by a client you can't afford to break that depends on a
> bug in the previous implementation.
>
> So yes I strongly recommend setting the registers to a 0 in this case.

Thank you for this explanation. I think that it is worth to add relevant
comment to arch/x86/kernel/relocate_kernel_*.S and purgatory entry.
I will try to prepare something when we work out nice thing for Xen.

Daniel
