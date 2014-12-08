Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaLHPtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:49:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47723 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaLHPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:49:20 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 0/4] drm/msm: YUV suppport addition for MDP4 & MDP5
Date: Mon,  8 Dec 2014 10:48:55 -0500
Message-Id: <1418053739-9386-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this set of patches adds YUV support for MDP4 and MDP5. This only concerns
the public planes (using ViG pipes).

The fun part was to rebase things on top of atomic but things worked out fine.
I was able to test this for MDP5 on a 8084 target. I cannot say the same for
MDP4 for which I don't have a build based on atomic yet. The change is pretty
similar to MDP5 though.

Rgds,
Stephane.


Beeresh Gopal (1):
  drm/msm/mdp4: add YUV format support

Stephane Viau (3):
  drm/msm/mdp: add register description for YUV support
  drm/msm/mdp: add common YUV information for MDP4/MDP5
  drm/msm/mdp5: add NV12 support for MDP5

 drivers/gpu/drm/msm/hdmi/hdmi.c           | 149 ++++++++++++++-------
 drivers/gpu/drm/msm/hdmi/hdmi.h           |   8 +-
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c |   1 -
 drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h   |  44 ++++++
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h   |  19 ++-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c | 104 +++++++++++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h   | 153 +++++++++++++++++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h   |  19 ++-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c | 215 +++++++++++++++++++++++++++---
 drivers/gpu/drm/msm/mdp/mdp_common.xml.h  |  30 +++--
 drivers/gpu/drm/msm/mdp/mdp_format.c      | 108 +++++++++++++--
 drivers/gpu/drm/msm/mdp/mdp_kms.h         |  24 +++-
 drivers/gpu/drm/msm/msm_fb.c              |   4 +-
 drivers/gpu/drm/msm/msm_kms.h             |   2 +
 14 files changed, 754 insertions(+), 126 deletions(-)

-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

