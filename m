Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3DZLGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:06:16 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51419 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3DZLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:06:15 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [PATCH 0/2] Early printk support for virtio console devices.
Date: Fri, 26 Apr 2013 16:34:54 +0530
Message-Id: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set implements early printk support for virtio console devices without using any hypercalls.

The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch-set does not break existing hypercall based early print support.

This implementation adds:
1. Early writeonly register named early_wr in virtio console's config space.
2. Host feature flags namely VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-write capability in console device.

Early write mechanism:
1. When a guest wants to out some character, it has to simply write the character to early_wr register in config space of virtio console device.

Pranavkumar Sawargaonkar (2):
  virtio: console: Add early writeonly register to config space
  arm64: earlyprintk support for virtio-mmio console

 Documentation/virtual/virtio-spec.txt |   13 ++++++++++--
 arch/arm64/kernel/early_printk.c      |   35 +++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_console.h   |    3 +++
 3 files changed, 49 insertions(+), 2 deletions(-)

-- 
1.7.9.5

