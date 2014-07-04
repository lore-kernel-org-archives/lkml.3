Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031378AbaGDWVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031343AbaGDWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.10 18/46] IB/ipath: Translate legacy diagpkt into newer extended diagpkt
Date: Fri,  4 Jul 2014 15:19:22 -0700
Message-Id: <20140704221603.104809918@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

commit 7e6d3e5c70f13874fb06e6b67696ed90ce79bd48 upstream.

This patch addresses an issue where the legacy diagpacket is sent in
from the user, but the driver operates on only the extended
diagpkt. This patch specifically initializes the extended diagpkt
based on the legacy packet.

Reported-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/ipath/ipath_diag.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -346,6 +346,10 @@ static ssize_t ipath_diagpkt_write(struc
 			ret = -EFAULT;
 			goto bail;
 		}
+		dp.len = odp.len;
+		dp.unit = odp.unit;
+		dp.data = odp.data;
+		dp.pbc_wd = 0;
 	} else {
 		ret = -EINVAL;
 		goto bail;


