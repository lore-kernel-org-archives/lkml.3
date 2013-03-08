Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab3CHPlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:41:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934263Ab3CHPkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:40:46 -0500
Date: Fri, 8 Mar 2013 10:40:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130308154033.GA8219@redhat.com>
References: <20130305215300.GE4519@redhat.com>
 <1362584551.4392.291.camel@falcor1>
 <20130306235525.GB29229@redhat.com>
 <1362620348.4392.408.camel@falcor1>
 <20130307143643.GA2790@redhat.com>
 <1362670833.4392.438.camel@falcor1>
 <20130307155343.GD2790@redhat.com>
 <CALLzPKYTmD2AUm1k7JEzXupRjOUPgkQ0LRpuT7b5P1yNpLQOxg@mail.gmail.com>
 <20130307215620.GA2159@redhat.com>
 <CALLzPKYrn-vTLnEfQLO6PWQVB+DV=r3Ri9ruQ3gem3ppeJLU4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKYrn-vTLnEfQLO6PWQVB+DV=r3Ri9ruQ3gem3ppeJLU4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 10:09:48AM +0200, Kasatkin, Dmitry wrote:

[..]
> > - File could have invalid signature still iint->DIGSIG could be set and
> >   security hook will return success.
> >         - Assume system has booted with ima_appraise_tcb policy.
> >         - A binary executes. bprm_check() is called and it will
> >           set iint->DIGSIG.
> >         - User goes ahead and replaces appraise policy with some
> >           other policy so no appraisal rule will match for same file.
> 
> Policy can only be replaced once. So if policy has been initialized at
> early-user-space,
> then it cannot be replaced...

Sure, but early user space does not have to initialize the "policy",
isn't. Atleast currently kernel can not enforce it. So root always
can decide to load the policy some time late. assume ima_appraise_tcb is
enabled at kernel command line.

Given that in secureboot environment we are not trusting root, it atleast
gives root a way to deceive IMA due to caching.
 
[..]
> > In summary, we can still solve the problem we can do few things.
> >
> > - Provide a reliable way to disable caching of iint->DIGSIG, digest
> >   and appraisal results.
> >
> > - Provide functions to access iint->DIGSIG after every file execution.

Actually if we have to disbale caching to make it work reliably, then
means we are not storing iint->DIGSIG and that means we can't access it
later with a helper function. So status of iint->DIGSIG has to be returned
with the hook itself and current security hooks don't have any extra
fields to do that.

Thanks
Vivek
