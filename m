Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaEGT7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:59:03 -0400
Received: from mout.gmx.net ([212.227.17.20]:56338 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaEGTw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:52:59 -0400
Date: Wed, 7 May 2014 21:24:00 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, chad@dahc.us, tulinizer@gmail.com,
        lorenz@badgers.com, michael.banken@mathe.stud.uni-erlangen.de,
        rashika.kheria@gmail.com, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: silicom: Remove needless calls of
 get_status_port_fn()
Message-ID: <20140507212400.569bde1c@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:8HIw9yBF5Fp557NVJR1yCadU3X/x0bvsS/xBNNb23J0eliw2zDL
 q3/sjDqFMQj5GBZ5j79tXwbcVX2/q0oM4JDXHdNGRWgMn7cFs9gRWW8e7SuUHga2ewetDCs
 /SGqZf+NR6nf55BxRpmwtp5QzrrJ6NQdJU/rE2JOR1FJPWjweb2scb0mNayG7veTqdD1WiD
 k2xXUPuAXJalDriPhidxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a needless pointer initialisation and call to get_status_port_fn()
in functions remove_bypass_tpl_auto() and set_tpl_fn(). Variable
'pbpctl_dev_b' is set correctly later in the function before first use.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/silicom/bpctl_mod.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 7f3d884..bbc183f 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -4735,10 +4735,9 @@ static void bp_tpl_timer_fn(unsigned long param)
 
 static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
-	struct bpctl_dev *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b;
 	if (!pbpctl_dev)
 		return;
-	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		del_timer_sync(&pbpctl_dev->bp_tpl_timer);
@@ -4785,12 +4784,10 @@ static int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
 
-	struct bpctl_dev *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b;
 	if (!pbpctl_dev)
 		return -1;
 
-	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
-
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		if (tpl_mode) {
 			pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
-- 
1.9.1

