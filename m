Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaGHTg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:36:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbaGHTeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Marciniszyn" <mike.marciniszyn@intel.com>,
        "Dennis Dalessandro" <dennis.dalessandro@intel.com>,
        "Roland Dreier" <roland@purestorage.com>,
        "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.885545140@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 023/125] IB/ipath: Translate legacy diagpkt into newer
 extended diagpkt
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/ipath/ipath_diag.c | 4 ++++
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

