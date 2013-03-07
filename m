Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab3CGNit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:38:49 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52091 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab3CGNil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:38:41 -0500
Message-ID: <1362663507.4392.422.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Thu, 07 Mar 2013 08:38:27 -0500
In-Reply-To: <20130306233837.GA29229@redhat.com>
References: <20130301213329.GC3457@redhat.com>
	 <1362346944.18325.1.camel@falcor1> <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
	 <1362446491.4392.133.camel@falcor1> <20130305151829.GB4519@redhat.com>
	 <1362516018.4392.233.camel@falcor1> <20130306155452.GB18337@redhat.com>
	 <1362610081.4392.364.camel@falcor1> <20130306233837.GA29229@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030713-7182-0000-0000-000005AE4145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 18:38 -0500, Vivek Goyal wrote:
> On Wed, Mar 06, 2013 at 05:48:01PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-03-06 at 10:54 -0500, Vivek Goyal wrote:

[...]
> > > - Because policy can be replaced easily, some of the functionality
> > >   will automatically be disabled. (because associated policy is not
> > >   there any more). And this can be very unintutive.
> > 
> > Limiting the additional functionality to a single policy, is wrong. A
> > new policy option (eg. memlock) or even action primitive (eg.
> > appraise_memlock) should be defined, allowing any policy to achieve the
> > same results.
> 
> Sorry I did not get this part. How does any policy achieve the same
> results.

This discussion has gone through many twists and turns - original direct
crypto calls to verify appended signature, 'optional' policy flag,
locking memory, fixing appraisal results, differentiating ima vs. evm
appraisal results, iint caching, merging policies vs. either/or policy, 
new policy memory lock option/action, separating policy from locking
memory, and now exporting integrity calls.

Once you resolve the 'special' processing (eg. memory locking issue)
being tied to the policy, either by removing the requirement or by
defining a new policy option/action primitive, you'll be able to resolve
your policy requirements, without merging rules or limiting
functionality for other policies.

Limiting functionality (eg. kexec) to a single builtin policy is
unacceptable.  The same mechanism, that the builtin kmem_lock policy
uses to make kexec permissible, should be available to all policies.  It
is then up to the system administrator to define an appropriate policy.

thanks,

Mimi

