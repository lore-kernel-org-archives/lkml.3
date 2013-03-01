Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3CAVdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:33:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3CAVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:33:33 -0500
Date: Fri, 1 Mar 2013 16:33:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130301213329.GC3457@redhat.com>
References: <20130228151333.GB11360@redhat.com>
 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
 <20130228213534.GF11360@redhat.com>
 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
 <1362102544.9158.35.camel@falcor1>
 <1362140107.9158.101.camel@falcor1>
 <20130301152839.GA3457@redhat.com>
 <20130301184027.GB3457@redhat.com>
 <1362166753.9158.169.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362166753.9158.169.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 02:39:13PM -0500, Mimi Zohar wrote:

[..]
> I was suggesting that a builtin appraise rule chain and everything else
> on the other chain.  Userspace could replace the other chain with
> whatever they wanted, including additional appraisal rules.
> 
> > > Given the fact that policy file ABI is still in testing we should be
> > > able to change semantics. (As currently user's appraise rules override
> > > kernel's appraisal rules).
> 
> The userspace policy could only extend the appraisal rules.  We OR the
> result of both chains, and use the more restrictive rule.


So secureboot rules will go in builtin policy. tcb appraise rules and
others will go in other policy. This other policy is replacable by
user.

We OR the results of both chains and instead of using first matching
rule, we choose a rule which is more restrictive and use that.

Is there always a clear relationship between rules. I mean one is more
restrictive than other. There can not be part-overlapping rules?

[..]
> We've already spoken about needing an additional hook or moving the
> existing bprm hook.  Can we defer the memory caching requirements for
> now?

Sure, additional hook is not a concern.

I can defer caching discussion but I think it is important to discuss
it now. Because it might very well affect how do we decide to handle
multiple appraise rules/policies. So please, if possible, let us not
defer the caching requirement discussion.

My biggest concern is what if we decide to rule based caching option
and rule gets skipped because of more restrictive rule present.

appraise func=bprm_check cache_status=no
appraise fowner=root 

In above case second rule will override first one and that's not what
we want.

Thanks
Vivek
