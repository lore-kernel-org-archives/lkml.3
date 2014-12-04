Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaLDKCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:02:50 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:40784 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaLDKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:02:47 -0500
MIME-Version: 1.0
In-Reply-To: <547DFCD6.3000406@linaro.org>
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org>
 <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com> <547DFCD6.3000406@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 4 Dec 2014 10:02:25 +0000
Message-ID: <CAFEAcA_pSiMXX52xUhNBCwiNdZomspFhr_Y+9+F2yb7P_D26bg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: add init entry to VGIC KVM device
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 17:54, Eric Auger <eric.auger@linaro.org> wrote:
> as soon as VFIO signaling is set up (the device IRQ index is linked to
> an eventfd, the physical IRQ VFIO handler is installed and the physical
> IRQ is enabled at interrupt controller level), virtual IRQs are likely
> to be injected. With current QEMU code, we setup this VFIO signaling
> *before* the vgic readiness (either on machine init done or reset
> notifier) and we face that issue of early injection. QEMU related
> patches to follow ...

So can you describe in QEMU terms how the lifecycle of these
things works? How do we ensure that we don't start trying
to inject VFIO IRQs before we've even created the vgic, for
instance?

thanks
-- PMM
