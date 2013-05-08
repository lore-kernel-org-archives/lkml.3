Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3EHOSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:18:20 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54199 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755548Ab3EHOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:18:17 -0400
Date: Wed, 8 May 2013 15:17:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Message-ID: <20130508141706.GF2703@arm.com>
References: <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
 <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de>
 <87sj27xxjr.fsf@rustcorp.com.au>
 <CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com>
 <87ip2wr8tp.fsf@rustcorp.com.au>
 <CAFEAcA_=BTXVdkN0WmajxVSjbDrmxc5z65hCbxr=7TqJVsE9EA@mail.gmail.com>
 <87txmfo0rl.fsf@rustcorp.com.au>
 <CAFEAcA9jBSpN2p9ZaU+_gX41Ke3nvpSKVrWV8Rioy_ioadKCgg@mail.gmail.com>
 <5189234D.3040208@codeaurora.org>
 <CAFEAcA-eSB=_UT0-L7o=2o6JGv0WkXZv5UPxPVqLRxjUZQegFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA-eSB=_UT0-L7o=2o6JGv0WkXZv5UPxPVqLRxjUZQegFA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:58:23PM +0100, Peter Maydell wrote:
> On 7 May 2013 16:52, Christopher Covington <cov@codeaurora.org> wrote:
> > On 05/07/2013 08:19 AM, Peter Maydell wrote:
> >> Well, at the moment EARLY_PRINTK is hardcoded to
> >> "use some specific UART or equivalent selected at
> >> compile time". So the equivalent presumably would
> >> be to hard-compile "use virtio-console", but then
> >> how does that code know where the virtio-console
> >> is in the address space?
> >
> > arm64 uses a kernel argument.
> 
> This mixes up "information that the user provides to the
> kernel" (ie configuration) with "information that QEMU or
> kvmtool should provide to the kernel" (ie hardware
> description), and would require QEMU/kvmtool to parse
> the user's commandline tool to figure out if they
> needed to override it or edit it (or alternatively,
> would require the user to know internal details of
> QEMU/kvmtool's address map for the guest). I think it
> would be nicer to keep them separate.

I'm not sure it's worth it, the earlyprintk is meant for debugging the
early kernel booting code, not for general use (you have the normal
console for this). Someone doing platform port should know the address
of the uart and pass the right information on the kernel command line to
help debug early booting issues.

But if someone comes up with some bindings, I won't reject the patch.

-- 
Catalin
