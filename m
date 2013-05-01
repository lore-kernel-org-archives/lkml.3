Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419Ab3EAOrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:47:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42053 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab3EAOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:47:11 -0400
Date: Wed, 1 May 2013 15:46:22 +0100
From: Will Deacon <will.deacon@arm.com>
To: Anup Patel <anup@brainfault.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Message-ID: <20130501144622.GA24055@mudshark.cambridge.arm.com>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
 <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
 <87obcyc9sh.fsf@rustcorp.com.au>
 <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
 <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
 <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de>
 <87sj27xxjr.fsf@rustcorp.com.au>
 <CAAhSdy14ofVEdrfc2r3PqLFrTA9kvM+oBVWmXNSWBq2xTxMLiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy14ofVEdrfc2r3PqLFrTA9kvM+oBVWmXNSWBq2xTxMLiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 07:53:49AM +0100, Anup Patel wrote:
> On Wed, May 1, 2013 at 7:37 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Alexander Graf <agraf@suse.de> writes:
> >> There are not device specific registers in
> >> virtio-console. Virtio-console lives behind a virtio bus which doesn't
> >> know what these registers are.
> >
> > You're not going to make coherent arguments without reading that actual
> > patch we're discussing.  And you're going to just waste everyone else's
> > time.
> >
> >> Even if you shove it into config space,
> >
> > Which is what the patch does...
> >
> >> it'd be broken because config access happens without intercepts on
> >> some platforms.
> >
> > But people keep assuming it, which is one reason virtio_ccw switched
> > from passive lguest-style config to active.  Only lguest and the old kvm
> > virtio use it, and lguest can change.
> >
> > An emergency output is a reasonable idea, and this is a reasonable
> > implementation.  The question is practical: will it be used?  Because we
> > don't implement reasonable ideas which aren't going to be used.
> 
> We are already using it for Guest bring-up on APM ARM64 board using
> KVMTOOL and so far it has been really helpful in debugging KVM ARM64
> guest issues.
> 
> Also, this is a very useful debugging method for Guest bring-up on
> other architectures supported by KVM and other Hypervisors that
> support VirtIO.

FWIW: I've hacked together a small set of patches allowing us to use the
x86 ioport peripherals on arm/arm64 in kvmtool. This means you can use the
8250 for earlyprintk on the latter, and even as the main console if you
like since it has a device-tree binding.

I'll post the patches as an RFC to the kvm list.

Will
