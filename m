Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaLBRuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:50:23 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65088 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaLBRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <1417541251-20761-1-git-send-email-eric.auger@linaro.org>
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 2 Dec 2014 17:50:00 +0000
Message-ID: <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com>
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

On 2 December 2014 at 17:27, Eric Auger <eric.auger@linaro.org> wrote:
> Since the advent of dynamic initialization of VGIC, this latter is
> initialized very late, on the first vcpu run. This initialization
> could be initiated much earlier by the user, as soon as it has
> provided the requested dimensioning parameters:
> - number of IRQs and number of vCPUs,
> - DIST and CPU interface base address.
>
> One motivation behind being able to initialize the VGIC sooner is
> related to the setup of IRQ injection in VFIO use case. The VFIO
> signaling, especially when used along with irqfd must be set *after*
> vgic initialization to prevent any virtual IRQ injection before
> VGIC initialization. If virtual IRQ injection occurs before the VGIC
> init, the IRQ cannot be injected and subsequent injection is blocked
> due to VFIO completion mechanism (unmask/mask or forward/unforward).

This implies that you're potentially injecting virtual IRQs
(and changing the state of the VGIC) before we actually
start running the VM (ie before userspace calls KVM_RUN).
Is that right? It seems odd, but maybe vfio works that way?

-- PMM
