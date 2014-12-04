Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaLDKyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:54:09 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57257 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaLDKyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:54:07 -0500
Date: Thu, 4 Dec 2014 11:54:52 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: Re: [PATCH v2 0/4] VGIC early initialization initiated by user-space
Message-ID: <20141204105452.GB4526@cbox>
References: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:48:00AM +0100, Eric Auger wrote:
> Since the advent of dynamic initialization of VGIC, this latter is
> initialized very late, on the first vcpu run. This initialization
> could be initiated much earlier by the user-space, as soon as it has
> set the requested dimensioning parameters: number of IRQs, number of
> vCPUs, base addresses.
> 
> One motivation behind being able to initialize the VGIC sooner is
> related to the setup of IRQ injection in VFIO use case. The VFIO
> signaling, especially when used along with irqfd must be set *after*
> vgic initialization to prevent any virtual IRQ injection before
> vgic initialization. If virtual IRQ injection occurs before the VGIC
> init, the IRQ cannot be injected and subsequent injection is blocked
> due to VFIO completion mechanism (unmask/mask or forward/unforward).
> 
The series looks overall pretty good to me.

-Christoffer
