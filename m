Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3E0QN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:13:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40790 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3E0QN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:13:26 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] dma-unmap: allow to only unmap completed DMA buffer
Date: Tue, 28 May 2013 00:13:05 +0800
Message-Id: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset tries to loose the check on DMA buffer size in check_unmap()
of dma-debug first, then only unmap the actual completed DMA buffer in USB
unmap path.

Considered that DMA unmapping often runs in hard irq context, the patch set
may save irq handling time. And the improvement can be observed on
ARMv7(Pandaboard) with the chage, at average ~25us is saved about ehci irq
handling under usbnet ping test case.

Thanks,
--
Ming Lei


