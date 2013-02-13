Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3BMNf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:35:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53066 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3BMNf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:35:57 -0500
Date: Wed, 13 Feb 2013 14:35:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andre Przywara <andre@andrep.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored
 MSRs
Message-ID: <20130213133549.GB15210@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>,
	Andre Przywara <andre@andrep.de>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <1360755761-725-1-git-send-email-bp@alien8.de>
 <20130213114747.GC9817@redhat.com>
 <20130213115526.GA15210@pd.tnic>
 <20130213121002.GD9817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130213121002.GD9817@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 02:10:02PM +0200, Gleb Natapov wrote:
> > > Is your guest compiled without PV support? With PV Linux traps #GP for
> > > all MSRs and it saves us in more than one places.
> > 
> > Yes, CONFIG_PARAVIRT_GUEST is not set on the guest kernel.
> > 
> Thanks. It does not mean that the patch should not be applied though.

Right,

but, come to think of it, adding an MSR each time to those functions
could turn out to be a PITA. The PV solution with trapping on the MSR
accesses might be better so maybe CONFIG_KVM should do

select KVM_GUEST

?

This is even a good forward-looking solution.

> I cannot seems to find the documentation for the MSR anywhere, do you
> have a pointer?

http://support.amd.com/us/Processor_TechDocs/31116.pdf, p.438

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
