Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbaBDVJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:09:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbaBDVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3.12 085/133] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
Date: Tue,  4 Feb 2014 13:08:06 -0800
Message-Id: <20140204210739.433593790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <PeterHuewe@gmx.de>

commit 747d35bd9bb4ae6bd74b19baa5bbe32f3e0cee11 upstream.

Depending on the implementation strcmp might return the difference between
two strings not only -1,0,1 consequently
 if (strcmp (a,b) == -1)
might lead to taking the wrong branch

-> compare with < 0  instead,
which in any case is more canonical.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_ppi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -172,7 +172,7 @@ static ssize_t tpm_store_ppi_request(str
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(version, "1.1") == -1)
+	if (strcmp(version, "1.1") < 0)
 		params[2].integer.value = TPM_PPI_FN_SUBREQ;
 	else
 		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
@@ -182,7 +182,7 @@ static ssize_t tpm_store_ppi_request(str
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length = sizeof(req);
 		sscanf(buf, "%d", &req);
@@ -248,7 +248,7 @@ static ssize_t tpm_show_ppi_transition_a
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length =  0;
 		params[3].buffer.pointer = NULL;
@@ -390,7 +390,7 @@ static ssize_t show_ppi_operations(char
 	kfree(output.pointer);
 	output.length = ACPI_ALLOCATE_BUFFER;
 	output.pointer = NULL;
-	if (strcmp(version, "1.2") == -1)
+	if (strcmp(version, "1.2") < 0)
 		return -EPERM;
 
 	params[2].integer.value = TPM_PPI_FN_GETOPR;


