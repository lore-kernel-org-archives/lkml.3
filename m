Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3C0RGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:06:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52069 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab3C0RGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:06:24 -0400
Date: Wed, 27 Mar 2013 17:05:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
Message-ID: <20130327170555.GA20990@mudshark.cambridge.arm.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130327133811.GE18429@mudshark.cambridge.arm.com>
 <51531F76.2090200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51531F76.2090200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 04:33:58PM +0000, Rob Herring wrote:
> On 03/27/2013 08:38 AM, Will Deacon wrote:
> > On Wed, Mar 27, 2013 at 12:50:39PM +0000, Stefano Stabellini wrote:
> >> +struct smp_operations __initdata psci_smp_ops = {
> >> +	.smp_init_cpus		= psci_smp_init_cpus,
> >> +	.smp_prepare_cpus	= psci_smp_prepare_cpus,
> >> +	.smp_secondary_init	= psci_secondary_init,
> >> +	.smp_boot_secondary	= psci_boot_secondary,
> >> +};
> >> +#endif
> > 
> > As I said before, I don't agree with bolting these two interfaces together
> > like this and, as it stands, I'm afraid I have to NAK this patch.
> > 
> > A potential alternative is to have a set of virt_smp_ops, which have
> > wrappers around the psci functions, but that requires agreement from Xen and
> > KVM to implement the same PSCI interface, which feels unfair to me.
> 
> I need the same smp ops for highbank. By using mach-virt Xen is using
> the same interface as KVM. This patch does not change that, but rather
> allows other platforms to use the same smp ops as well.
> 
> Isn't the whole point of PSCI to have a common interface? No one is
> making Xen use PSCI at all. It is a choice and since they are making
> that choice, why would the PSCI interface be different?

The channel is common, sure, but I wouldn't expect the semantics of each
call to be identical between firmware implementations (going back to my
previous examples of CPU IDs and implementation-defined state parameters).

If a platform happens to have an id-mapping from smp_operations to psci,
then I still think there should be an indirection in there so that we have
the flexibility to change the smp_operations if we wish and not give
platforms the false impression that these two things are equivalent.

Will
