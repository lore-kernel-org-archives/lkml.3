Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaK2QVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:21:12 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44702 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaK2QVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:21:08 -0500
Date: Sat, 29 Nov 2014 17:21:46 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>,
        jan.kiszka@siemens.com,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com,
        Catalin Marinas <catalin.marinas@arm.com>, r65777@freescale.com,
        pbonzini@redhat.com, bp@suse.de
Subject: Re: [PATCH 4/7] KVM: arm64: guest debug, add SW break point support
Message-ID: <20141129162146.GG23653@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-5-git-send-email-alex.bennee@linaro.org>
 <20141126160720.GD3245@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141126160720.GD3245@hawk.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:07:20PM +0100, Andrew Jones wrote:
> On Tue, Nov 25, 2014 at 04:10:02PM +0000, Alex Bennée wrote:
> > This adds support for SW breakpoints inserted by userspace.
> > 
> > First we need to trap all BKPT exceptions in the hypervisor (ELS). This
> > in controlled through the MDCR_EL2 register. I've added a new field to
> > the vcpu structure to hold this value. There should be scope to
> > rationlise this with the VCPU_DEBUG_FLAGS/KVM_ARM64_DEBUG_DIRTY_SHIFT
> > manipulation in later patches.
> 
> I think we should start using the new mdcr_el2 field everywhere we plan
> to within the same series that it is introduced. Otherwise it's hard
> to tell if we need an mdcr_el2 field, or if a more generic field would
> suffice. We can always translate bits of a more generic field to
> mdcr_el2 bits when necessary, but not the reverse.
> 
Agreed, this is getting messy already with this patch.

-Christoffer
