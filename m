Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab3BMMLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821Ab3BMMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:11:15 -0500
Date: Wed, 13 Feb 2013 14:10:02 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andre Przywara <andre@andrep.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored
 MSRs
Message-ID: <20130213121002.GD9817@redhat.com>
References: <1360755761-725-1-git-send-email-bp@alien8.de>
 <20130213114747.GC9817@redhat.com>
 <20130213115526.GA15210@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213115526.GA15210@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:55:26PM +0100, Borislav Petkov wrote:
> On Wed, Feb 13, 2013 at 01:47:47PM +0200, Gleb Natapov wrote:
> > On Wed, Feb 13, 2013 at 12:42:41PM +0100, Borislav Petkov wrote:
> > > From: Borislav Petkov <bp@suse.de>
> > > 
> > > The "x86, AMD: Enable WC+ memory type on family 10 processors" patch
> > > currently in -tip added a workaround for AMD F10h CPUs which #GPs my
> > > guest when booted in kvm. This is because it accesses MSR_AMD64_BU_CFG2
> > > which is not currently ignored by kvm. Do that because this MSR is only
> > > baremetal-relevant anyway. While at it, move the ignored MSRs at the
> > > beginning of kvm_set_msr_common so that we exit then and there.
> > > 
> > Is your guest compiled without PV support? With PV Linux traps #GP for
> > all MSRs and it saves us in more than one places.
> 
> Yes, CONFIG_PARAVIRT_GUEST is not set on the guest kernel.
> 
Thanks. It does not mean that the patch should not be applied though.
I cannot seems to find the documentation for the MSR anywhere, do you
have a pointer?

--
			Gleb.
