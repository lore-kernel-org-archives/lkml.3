Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaLDMIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:08:23 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:50163 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaLDMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:08:21 -0500
MIME-Version: 1.0
In-Reply-To: <54804D27.1020901@linaro.org>
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org>
 <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com>
 <547DFCD6.3000406@linaro.org> <CAFEAcA_pSiMXX52xUhNBCwiNdZomspFhr_Y+9+F2yb7P_D26bg@mail.gmail.com>
 <54804D27.1020901@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 4 Dec 2014 12:07:59 +0000
Message-ID: <CAFEAcA_moz=PBJX23Ghj53oYTObNN-Hh8DGZ1Oa=mMKWgM7Emw@mail.gmail.com>
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

On 4 December 2014 at 12:01, Eric Auger <eric.auger@linaro.org> wrote:
> Here is the sequence:
> 1) The VGIC early initialization is initiated in a machine init done
> notifier. This notifier is registered in kvm_arm_gic_realize
> (http://lists.gnu.org/archive/html/qemu-devel/2014-12/msg00220.html). It
> executes after vcpu instantiations + dist/cpu interface base address
> setting + nb irq setting.
> 2) the VFIO signaling and irqfd setup is done in a reset notifier
> http://lists.gnu.org/archive/html/qemu-devel/2014-11/msg04365.html

OK. And on x86 VFIO how does this work? Obviously x86's GIC just
initializes as soon as it's created, but do we do the irqfd setup
in a reset notifier there too?

thanks
-- PMM
