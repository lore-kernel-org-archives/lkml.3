Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3DZLTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:19:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3DZLTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:19:52 -0400
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
Date: Fri, 26 Apr 2013 13:19:50 +0200
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, Peter Maydell <peter.maydell@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.04.2013, at 13:04, Pranavkumar Sawargaonkar wrote:

> This patch-set implements early printk support for virtio console devices without using any hypercalls.
> 
> The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch-set does not break existing hypercall based early print support.
> 
> This implementation adds:
> 1. Early writeonly register named early_wr in virtio console's config space.
> 2. Host feature flags namely VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-write capability in console device.
> 
> Early write mechanism:
> 1. When a guest wants to out some character, it has to simply write the character to early_wr register in config space of virtio console device.

I won't nack this patch set, but I'll definitely express that I'm not happy with it.

MMIO registers are handled by a different layer than the virtio console itself. After the virtio refactoring in QEMU, they will be completely separate drivers. So we'll be in a similar mess with early printk as we are on the s390-virtio machine, where early printk is done through hypercalls and thus we can't directly link it to the console output.

I still don't see what the issue is with just implementing a small irq-less virtio driver for early printk.


Alex

