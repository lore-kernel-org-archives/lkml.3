Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3B1U5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:57:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab3B1U5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:57:41 -0500
Date: Thu, 28 Feb 2013 15:57:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130228205735.GE11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
 <20130228185155.GC11360@redhat.com>
 <1362083401.2908.412.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362083401.2908.412.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 03:30:01PM -0500, Mimi Zohar wrote:

[..]
> > So we need few more things from IMA for it to support the case of user
> > space signing.
> > 
> > - Ability to make sure kernel specified rules can not be overridden.
> 
> Our posts must have crossed -
> http://marc.info/?l=linux-security-module&m=136207944823661&w=2
> 
> > - Ability to not cache results so that direct writes to disk could
> >   be detected.
> 
> I'm not going to argue the futility of this argument.  I'll leave that
> to others more qualified.  If you really are concerned, then be my guest
> and define a general 'nocaching' option, not rule specific.  Replacing
> the policy won't affect the option.
> 
> > Till then I can't see how can I use IMA to implement process signing.
> 
> Vivek, you continue to imply that IMA doesn't cut it for your use case,
> yet ignore my suggestions.

Hi Mimi,

You asked me to not come up with new signing scheme and look into IMA
and make use of it. And that's what I am trying to do. As I continue
to do implementation, new concerns crop up and I am raising these.

I have not ignored any of your suggestions. This mail I sent before you
responded back with above mail where you seem to have suggested that
that disable "policy" interface based on kconfig option. I don't think
it was suggested in any of the mail threads before.

I have concerns w.r.t to disabling "policy" interface. This is like
choosing one feature over other. And I am concerned that somebody
will come back later that why did you disable "policy" interface and
broke my use case.

I would also like to understand that why "caching results" is not a
concern (or why argument is futile) w.r.t what I am trying to do. On
a system where whole of the user space is not signed, a root process
can go and directly write to disk and IMA will never detect it.

If remote attestation is happening, it probably is fine because no
known process is supposed to do that. And if unknown process runs, it
will be detected.

But without remote, attestation, to me it is a very valid concern
and is not addressed by current IMA implementation.

So no, I am not trying to ignore your suggestions. Just that there
are many concerns and I don't think all of my concerns have been
addressed yet.

Also if I define a separate "nocaching" option, again it will impact
the performance of other use cases IMA might have. You are saying
that choose one functionality over other and I think that probably
is not the best idea.

So to me, IMA should be beefed up to support all the use cases, instead
of hardcoding things using kconfig option and choose one functionality
over other.

Thanks
Vivek
