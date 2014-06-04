Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaFDXW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaFDXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sibai Li <sibai.li@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3.14 118/228] i40e: potential array underflow in i40e_vc_process_vf_msg()
Date: Wed,  4 Jun 2014 16:22:27 -0700
Message-Id: <20140604232351.831301901@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c243e96335c56e56dcf6a00593104554fb06b689 upstream.

If "vf_id" is smaller than hw->func_caps.vf_base_id then it leads to
an array underflow of the pf->vf[] array.  This is unlikely to happen
unless the hardware is bad, but it's a small change and it silences a
static checker warning.

Fixes: 7efa84b7abc1 ('i40e: support VFs on PFs other than 0')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Sibai Li <sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1776,7 +1776,7 @@ int i40e_vc_process_vf_msg(struct i40e_p
 			   u32 v_retval, u8 *msg, u16 msglen)
 {
 	struct i40e_hw *hw = &pf->hw;
-	int local_vf_id = vf_id - hw->func_caps.vf_base_id;
+	unsigned int local_vf_id = vf_id - hw->func_caps.vf_base_id;
 	struct i40e_vf *vf;
 	int ret;
 


