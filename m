Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3CABtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:49:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35490 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3CABtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:49:09 -0500
Message-ID: <1362102544.9158.35.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Thu, 28 Feb 2013 20:49:04 -0500
In-Reply-To: <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228213534.GF11360@redhat.com>
	 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030101-7182-0000-0000-0000059841AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 17:20 -0500, Eric Paris wrote:
> On Thu, Feb 28, 2013 at 4:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Feb 28, 2013 at 02:23:39PM -0500, Mimi Zohar wrote:
> 
> I think just a second for both of you to step back and see a slightly
> larger picture/problem might help.
> 
> This is a weird case where Vivek does not trust root to make the
> policy decision.  If the box is configured for secure boot, it needs
> to make these decisions no matter what the admin wants.  This is why
> he talks about trying to merge multiple competing policies.  The
> current IMA policy is controlled by whomever can first write to the
> ima policy file interface.  Vivek does not want an admin to be able to
> overwrite the secureboot policy.  So I get why he thinks changes may
> be needed to support this use case.

Nobody is saying that changes aren't necessary.

> The ima_tcb policy was meant to be larger than needed to determine a
> trusted computing base, but it is clearly not a superset of what he is
> hoping to accomplish.

The 'ima_tcb' policy is for measurement and attestation.  The policy
being discussed here is the 'ima_appraise_tcb' used for enforcing local
file integrity.

> So how do we take a system where the admin/software has some control
> over the integrity policy (as it is today?) and the kernel/system
> itself also has control (as Vivek wants it)?  

> It seems unsolved with what we have today....

Right, and merging policies won't work.  I see where you're going with
this...

thanks!

Mimi

