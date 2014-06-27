Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaF0LeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaF0Ld6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:33:58 -0400
Date: Fri, 27 Jun 2014 07:33:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com
Subject: Re: [PATCH 00/15][V4] kexec: A new system call to allow in kernel
 loading
Message-ID: <20140627113313.GB13337@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <20140626135811.37c10ff327bea8a9d2e3894e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626135811.37c10ff327bea8a9d2e3894e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 01:58:11PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2014 16:33:29 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > This patch series does not do kernel signature verification yet. I plan
> > to post another patch series for that. Now distributions are already signing
> > PE/COFF bzImage with PKCS7 signature I plan to parse and verify those
> > signatures.
> > 
> > Primary goal of this patchset is to prepare groundwork so that kernel
> > image can be signed and signatures be verified during kexec load. This
> > should help with two things.
> > 
> > - It should allow kexec/kdump on secureboot enabled machines.
> > 
> > - In general it can help even without secureboot. By being able to verify
> >   kernel image signature in kexec, it should help with avoiding module
> >   signing restrictions. Matthew Garret showed how to boot into a custom
> >   kernel, modify first kernel's memory and then jump back to old kernel and
> >   bypass any policy one wants to.
> > 
> > I hope these patches can be queued up for 3.17. Even without signature
> > verification support, they provide new syscall functionality. But I
> > wil leave it to maintainers to decide if they want signature verification
> > support also be ready to merge before they merge this patchset.
> 
> Well, this is an absolute ton of new code, much of it pretty complex. 
> And I believe the entire point of this work is to enable image
> signature checking, but that hasn't been implemented yet?

I have a patchset which works. But it requires more work. I will do
remaining work and clean it up and post for review.

> 
> In which case I'm thinking it would be unwise to merge these parts into
> mainline - if signature checking doesn't work or fails review or if you
> get hit by a bus then we'd be left with a large lump of rather useless
> code?
> 
> In which case I'm inclined to put this series into -next and keep it
> there pending completion of the signature checking part.

Agreed. Primary purpose of this patch series is to be able to do signature
verification of kernel during kexec. So it will make sense to first have
some sort of consensus on signature verification patches. Otherwise we
might be stuck with this 3.5K lines of code if things go south w.r.t
signature verification.

Thanks
Vivek
