Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3BMPit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab3BMPis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:38:48 -0500
Date: Wed, 13 Feb 2013 17:37:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andre Przywara <andre@andrep.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored
 MSRs
Message-ID: <20130213153741.GE9817@redhat.com>
References: <1360755761-725-1-git-send-email-bp@alien8.de>
 <20130213114747.GC9817@redhat.com>
 <20130213115526.GA15210@pd.tnic>
 <20130213121002.GD9817@redhat.com>
 <20130213133549.GB15210@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213133549.GB15210@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 02:35:49PM +0100, Borislav Petkov wrote:
> On Wed, Feb 13, 2013 at 02:10:02PM +0200, Gleb Natapov wrote:
> > > > Is your guest compiled without PV support? With PV Linux traps #GP for
> > > > all MSRs and it saves us in more than one places.
> > > 
> > > Yes, CONFIG_PARAVIRT_GUEST is not set on the guest kernel.
> > > 
> > Thanks. It does not mean that the patch should not be applied though.
> 
> Right,
> 
> but, come to think of it, adding an MSR each time to those functions
> could turn out to be a PITA. The PV solution with trapping on the MSR
> accesses might be better so maybe CONFIG_KVM should do
> 
PV solution does not exists for some other guests.

> select KVM_GUEST
> 
> ?
I can easily imaging the situation where one whats to build different
kernels for host and guest and do not have PV in the host one.

> 
> This is even a good forward-looking solution.
> 
> > I cannot seems to find the documentation for the MSR anywhere, do you
> > have a pointer?
> 
> http://support.amd.com/us/Processor_TechDocs/31116.pdf, p.438
> 
Thanks,

--
			Gleb.
