Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3JKLFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:05:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34017 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab3JKLFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:05:44 -0400
Date: Fri, 11 Oct 2013 13:04:55 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: ebiederm@xmission.com
Cc: hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
 <877gdkce6s.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gdkce6s.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:08:43AM -0700, ebiederm@xmission.com wrote:
> Daniel Kiper <daniel.kiper@oracle.com> writes:
>
> > Hi,
> >
> > Could you explain why do you clear all registers just before jumping
> > into purgatory (please look into arch/x86/kernel/relocate_kernel_64.S
> > for more details)? There is no any single word about that. I do not
> > count comment which states what is going on. purgatory on entry does
> > not assume any value in registers. Are you going to use that feature
> > for something in the future (e.g. to differentiate between callers
> > and/or Linux versions if it be needed)?
>
> It has been a long time now, but as I recall the reason was to just
> have things well defined and to make certain that we were not
> accidentially exporting anything except the stack pointer for
> applications to depend upon.
>
> 0/NULL is a good choice because if you are expecting pointer for some
> strange reason interesting things happen.

This covers more or less with my expectations.

> purgatory is definitely not the only target and the C version of
> purgatory was actually written well after kexec came into existence.
>
> Is there any particular reason why you are asking?

Yes, we (Xen guys) are discussing is it worth to do it or not in our
kexec implementation. I think that yes because we used Linux Kernel
kexec implementation as a base for our work and we use kexec-tools too.
So we should be aligined to what currently is in the wild. David do not
agree with me. You could find more here:

http://lists.xen.org/archives/html/xen-devel/2013-10/msg00710.html
http://lists.xen.org/archives/html/xen-devel/2013-10/msg00296.html

What is your opinion in that case?

> > By the way, interestingly it is not done if preserve_context is in
> > force.
>
> Something different is done, and all of the registers should be
> preserved from the when the return to Linux.

I expected that but purgatory does nothing with them.
However, maybe I missed something.

> In theory you can swap between to kernels with the preserve_context
> case.  Technically I like the ability but I don't know that it has ever
> achieved much uptake.

I think that this is nice idea too. However, I have not seen its usage in real.
Even once there was an idea to remove that stuff from Linux Kernel.

Daniel
