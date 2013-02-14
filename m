Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054Ab3BNVpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935014Ab3BNVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:52 -0500
Date: Thu, 14 Feb 2013 16:44:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com
Subject: Re: [RFC PATCH 0/6][v3] ima: Support a mode to appraise signed files
 only
Message-ID: <20130214214445.GI16671@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
 <1360875084.3524.695.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360875084.3524.695.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 03:51:24PM -0500, Mimi Zohar wrote:
> On Thu, 2013-02-14 at 14:55 -0500, Vivek Goyal wrote:
> > Hi,
> > 
> > Currently ima appraises all the files as specified by the rule.
> 
> Currently IMA appraises files based on policy.

And policy is composed of multiple rules. Ok, will change it.

> 
> >  So
> > if one wants to create a system where only few executables are
> > signed, that system will not work with IMA.
> 
> This statement misrepresents the IMA policy.  You can definitely define
> a policy that only measures/appraises a few specific files. In your
> usecase scenario, you are not willing to rely on LSM labels.  Policy
> rules can also be based on file owner.  We could also add support for
> gid.

Ok, will change it. How about following.

We want to create a system where only few executables are signed. This
patch extends IMA policy syntax so that one can specify that signatures
are optional.

> 
> > With secureboot, one needs to disable kexec so that unsigned kernels
> > can't be booted. To avoid this problem, it was proposed that sign
> > /sbin/kexec binary and if signatures are verified successfully, give
> > an special capability to the /sbin/kexec process. And in secureboot
> > mode processes with that special capability can invoke sys_kexec()
> > system call.
> 
> Please add here that you then rely on /sbin/kexec to verify the
> integrity of the kernel image.

Ok, will do that. This is infact a grey area. Yet to be figured out
how /sbin/kexec will ensure a signed kernel is being loaded.

Thanks
Vivek
