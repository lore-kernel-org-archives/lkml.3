Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912Ab3JPRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:55:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114Ab3JPRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 28/50] drm/radeon/dpm: off by one in si_set_mc_special_registers()
Date: Wed, 16 Oct 2013 10:45:14 -0700
Message-Id: <20131016174401.750553420@linuxfoundation.org>
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

commit 5fd9c581862a4874c0bdaf16231d8873832bbb99 upstream.

These checks should be ">=" instead of ">".  j is used as an offset into
the table->mc_reg_address[] array and that has
SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE (16) elements.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -5174,7 +5174,7 @@ static int si_set_mc_special_registers(s
 					table->mc_reg_table_entry[k].mc_data[j] |= 0x100;
 			}
 			j++;
-			if (j > SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 
 			if (!pi->mem_gddr5) {
@@ -5184,7 +5184,7 @@ static int si_set_mc_special_registers(s
 					table->mc_reg_table_entry[k].mc_data[j] =
 						(table->mc_reg_table_entry[k].mc_data[i] & 0xffff0000) >> 16;
 				j++;
-				if (j > SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
+				if (j >= SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
 					return -EINVAL;
 			}
 			break;
@@ -5197,7 +5197,7 @@ static int si_set_mc_special_registers(s
 					(temp_reg & 0xffff0000) |
 					(table->mc_reg_table_entry[k].mc_data[i] & 0x0000ffff);
 			j++;
-			if (j > SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 			break;
 		default:


