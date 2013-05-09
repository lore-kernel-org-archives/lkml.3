Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3EIKjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:39:44 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52183 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3EIKjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130508141706.GF2703@arm.com>
References: <CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
 <C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de> <87sj27xxjr.fsf@rustcorp.com.au>
 <CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com>
 <87ip2wr8tp.fsf@rustcorp.com.au> <CAFEAcA_=BTXVdkN0WmajxVSjbDrmxc5z65hCbxr=7TqJVsE9EA@mail.gmail.com>
 <87txmfo0rl.fsf@rustcorp.com.au> <CAFEAcA9jBSpN2p9ZaU+_gX41Ke3nvpSKVrWV8Rioy_ioadKCgg@mail.gmail.com>
 <5189234D.3040208@codeaurora.org> <CAFEAcA-eSB=_UT0-L7o=2o6JGv0WkXZv5UPxPVqLRxjUZQegFA@mail.gmail.com>
 <20130508141706.GF2703@arm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 May 2013 11:39:22 +0100
X-Google-Sender-Auth: iM8WnLaWwubf3WBh3wU8hmg1r5o
Message-ID: <CACxGe6tP=mos_j6gphK6gY=xCHLN4xtNKUpkzG4UHDzv=+fFUQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Christopher Covington <cov@codeaurora.org>,
        Amit Shah <amit.shah@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:17 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, May 07, 2013 at 04:58:23PM +0100, Peter Maydell wrote:
>> On 7 May 2013 16:52, Christopher Covington <cov@codeaurora.org> wrote:
>> This mixes up "information that the user provides to the
>> kernel" (ie configuration) with "information that QEMU or
>> kvmtool should provide to the kernel" (ie hardware
>> description), and would require QEMU/kvmtool to parse
>> the user's commandline tool to figure out if they
>> needed to override it or edit it (or alternatively,
>> would require the user to know internal details of
>> QEMU/kvmtool's address map for the guest). I think it
>> would be nicer to keep them separate.
>
> I'm not sure it's worth it, the earlyprintk is meant for debugging the
> early kernel booting code, not for general use (you have the normal
> console for this). Someone doing platform port should know the address
> of the uart and pass the right information on the kernel command line to
> help debug early booting issues.
>
> But if someone comes up with some bindings, I won't reject the patch.

Nicolas and I have tossed back and forth the idea of having a trivial
binding in the DT which specifies a couple of physical addresses and a
mask; one write register, one status register, and the mask to say
which bit to care about in the status. Basically the bare minimum to
say "here is something that will output to an already set up serial
device" without any reference to what it actually is. Something like
that would theoretically work with any device that implements or
emulates a UART write register. The thinking is that if it is trivial
to parse then it becomes more useful as an early printk target and
usable by the zImage wrapper (arm32 bit of course). Neither of us ever
followed up on it though.

g.
