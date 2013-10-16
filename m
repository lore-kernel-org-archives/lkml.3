Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690Ab3JPR6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:58:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934581Ab3JPRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 22/50] drm/radeon/dpm/btc: off by one in btc_set_mc_special_registers()
Date: Wed, 16 Oct 2013 10:45:08 -0700
Message-Id: <20131016174401.070475541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 96d8df846f52a720c8ae1fadadfad7c9e733e336 upstream.

It should be ">=" instead of ">" here.  The table->mc_reg_address[]
array has SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE (16) elements.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/btc_dpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -1913,7 +1913,7 @@ static int btc_set_mc_special_registers(
 			}
 			j++;
 
-			if (j > SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 
 			tmp = RREG32(MC_PMG_CMD_MRS);
@@ -1928,7 +1928,7 @@ static int btc_set_mc_special_registers(
 			}
 			j++;
 
-			if (j > SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 			break;
 		case MC_SEQ_RESERVE_M >> 2:
@@ -1942,7 +1942,7 @@ static int btc_set_mc_special_registers(
 			}
 			j++;
 
-			if (j > SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMC_EVERGREEN_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 			break;
 		default:


