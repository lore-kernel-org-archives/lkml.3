Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbaGOXce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:32:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079AbaGOXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Sacren <sakiwit@gmail.com>,
        Kavindya Deegala <kavindya.s.deegala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3.15 66/84] i40e: fix passing wrong error code to i40e_open()
Date: Tue, 15 Jul 2014 16:18:03 -0700
Message-Id: <20140715231715.167952839@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Sacren <sakiwit@gmail.com>

commit ce9ccb17ef5b5088172f46dd246c92523fd3a524 upstream.

The commit 6c167f582ea9 ("i40e: Refactor and cleanup i40e_open(),
adding i40e_vsi_open()") introduced a new function i40e_vsi_open()
with the regression by a typo. Due to the commit, the wrong error
code would be passed to i40e_open(). Fix this error in
i40e_vsi_open() by turning the macro into a negative value so that
i40e_open() could return the pertinent error code correctly.

Fixes: 6c167f582ea9 ("i40e: Refactor and cleanup i40e_open(), adding i40e_vsi_open()")
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Tested-by: Kavindya Deegala <kavindya.s.deegala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4310,7 +4310,7 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 		goto err_setup_rx;
 
 	if (!vsi->netdev) {
-		err = EINVAL;
+		err = -EINVAL;
 		goto err_setup_rx;
 	}
 	snprintf(int_name, sizeof(int_name) - 1, "%s-%s",


