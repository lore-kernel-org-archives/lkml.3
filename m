Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaKHSzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:55:35 -0500
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:54240
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbaKHSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:55:33 -0500
X-WSS-ID: 0NEQHWG-07-RKJ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>, Ben Goz <ben.goz@amd.com>
Subject: [PATCH v5 24/24] amdkfd: Implement the Get Version IOCTL
Date: Sat, 8 Nov 2014 20:55:14 +0200
Message-ID: <1415472917-4401-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(46102003)(86362001)(36756003)(104166001)(50986999)(97736003)(31966008)(88136002)(87286001)(64706001)(87936001)(48376002)(89996001)(44976005)(47776003)(20776003)(93916002)(101416001)(21056001)(19580405001)(76176999)(92726001)(19580395003)(84676001)(92566001)(4396001)(106466001)(99396003)(50226001)(33646002)(50466002)(53416004)(77096003)(102836001)(68736004)(77156002)(120916001)(95666004)(62966003)(229853001)(105586002)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 3130265..64c73ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -123,7 +123,16 @@ static int kfd_open(struct inode *inode, struct file *filep)
 static long kfd_ioctl_get_version(struct file *filep, struct kfd_process *p,
 					void __user *arg)
 {
-	return -ENODEV;
+	struct kfd_ioctl_get_version_args args;
+	int err = 0;
+
+	args.major_version = KFD_IOCTL_MAJOR_VERSION;
+	args.minor_version = KFD_IOCTL_MINOR_VERSION;
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		err = -EFAULT;
+
+	return err;
 }
 
 static int set_queue_properties_from_user(struct queue_properties *q_properties,
-- 
2.1.0

