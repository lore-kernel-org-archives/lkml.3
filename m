Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaLEXGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:06:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaLEXGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.10 20/45] powerpc/pseries: Honor the generic "no_64bit_msi" flag
Date: Fri,  5 Dec 2014 14:45:03 -0800
Message-Id: <20141205223319.921572039@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 415072a041bf50dbd6d56934ffc0cbbe14c97be8 upstream.

Instead of the arch specific quirk which we are deprecating

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -426,7 +426,7 @@ static int rtas_setup_msi_irqs(struct pc
 	 */
 again:
 	if (type == PCI_CAP_ID_MSI) {
-		if (pdn->force_32bit_msi) {
+		if (pdev->no_64bit_msi) {
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
 			if (rc < 0) {
 				/*


