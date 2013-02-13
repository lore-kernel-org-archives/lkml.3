Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab3BMLzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:55:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42138 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3BMLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:55:34 -0500
Date: Wed, 13 Feb 2013 12:55:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andre Przywara <andre@andrep.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored
 MSRs
Message-ID: <20130213115526.GA15210@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>,
	Andre Przywara <andre@andrep.de>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <1360755761-725-1-git-send-email-bp@alien8.de>
 <20130213114747.GC9817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130213114747.GC9817@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 01:47:47PM +0200, Gleb Natapov wrote:
> On Wed, Feb 13, 2013 at 12:42:41PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > The "x86, AMD: Enable WC+ memory type on family 10 processors" patch
> > currently in -tip added a workaround for AMD F10h CPUs which #GPs my
> > guest when booted in kvm. This is because it accesses MSR_AMD64_BU_CFG2
> > which is not currently ignored by kvm. Do that because this MSR is only
> > baremetal-relevant anyway. While at it, move the ignored MSRs at the
> > beginning of kvm_set_msr_common so that we exit then and there.
> > 
> Is your guest compiled without PV support? With PV Linux traps #GP for
> all MSRs and it saves us in more than one places.

Yes, CONFIG_PARAVIRT_GUEST is not set on the guest kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
