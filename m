Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaKLLil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:41 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46258 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:40 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 v3.18-rc4 0/4] drm: prime: Allow exported dma-bufs to be mapped
Date: Wed, 12 Nov 2014 11:38:11 +0000
Message-Id: <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set started out as a single patch with a trivial bit of
boilerplate to add dmabuf mmap support to the msm driver. Each of the
change remains fairly trivial but I've split it out by topic.

Patches 1, 2 and 3 in this series should be good to go but please don't
take patch 4 (which has a small effect on userspace) without an explicit
ack from Benjamin Gaignard.

I've tested this both with a rather hacked about Android userspace
and with a fairly small test case run from debian. Both bits of code
currently use dumb buffers.

Thanks to Benjamin for his help in finding this bit of code.

v2:

* Modified DRM_PRIME_HANDLE_TO_FD to honour the O_RDRW from the user
  and removed code to workaround this from the sti driver (Rob Clark).

* Added a patch to (rather spartanly) document gem_prime_mmap. Only
  tacked into this series 'cos I spotted it was missing when I was
  checking whether I needed to describe DRM_RDRWR anywhere.


Daniel Thompson (4):
  drm: prime: Honour O_RDWR during prime-handle-to-fd
  drm: prime: Document gem_prime_mmap
  drm: msm: Allow exported dma-bufs to be mapped
  drm: sti: Honour O_RDWR during prime-handle-to-fd

 drivers/gpu/drm/drm_prime.c         | 13 ++++++-------
 drivers/gpu/drm/msm/msm_drv.c       |  1 +
 drivers/gpu/drm/msm/msm_drv.h       |  3 +++
 drivers/gpu/drm/msm/msm_gem_prime.c | 13 +++++++++++++
 drivers/gpu/drm/sti/sti_drm_drv.c   | 11 +----------
 include/uapi/drm/drm.h              |  1 +
 6 files changed, 25 insertions(+), 17 deletions(-)

--
1.9.3

