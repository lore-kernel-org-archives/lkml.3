Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967966Ab3DSJ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:28:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60785 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967926Ab3DSJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:28:25 -0400
Date: Fri, 19 Apr 2013 10:27:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console
 devices.
Message-ID: <20130419092752.GB13283@mudshark.cambridge.arm.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
 <ede8ee08bb2616c2ed642200e3357367@localhost>
 <CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
 <bb1193983de3ea9f4df1a570441df34c@localhost>
 <CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
 <20130419090558.GA13283@mudshark.cambridge.arm.com>
 <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:25:35AM +0100, Pranavkumar Sawargaonkar wrote:
> On 19 April 2013 14:35, Will Deacon <will.deacon@arm.com> wrote:
> > On Thu, Apr 18, 2013 at 09:48:49AM +0100, Pranavkumar Sawargaonkar wrote:
> >> Actually i thought adding a config register will be easier to add a
> >> code than writing entire emulation as 8250 emulation will require to
> >> deal with dealing with more registers and more code.
> >
> > kvmtool already has an 8250 emulation! All we need to do is hack together
> > something which will allow us to instantiate those ioport devices in a more
> > flexible manner (namely, inside the MMIO space for ARM). For earlyprintk, I
> > suspect we can get away without an interrupt too, which should simplify
> > things a bit to start with.
> >
> > Regardless of the outcome of this discussion, I think getting the 8250
> > working on ARM is definitely something worth doing. If I get time, I'll take
> > a look.
> 
> I am not against using 8250 emulation (as far as it solves printk
> issues for kernel booting logs), but my point is why not to add early
> read-write support for virtio console, which also can be useful in
> emulation less mach-virt environment also ?

We can have both, but only one of those requires a change to the virtio
specification.

Will
