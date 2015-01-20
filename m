Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbbATMLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:11:31 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:51932 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbATMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:11:30 -0500
Subject: [PATCH RESEND] um,ethertap: use strncpy
From: Alan <gnomes@lxorguk.ukuu.org.uk>
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Tue, 20 Jan 2015 12:11:12 +0000
Message-ID: <20150120121100.28406.95201.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't prove the case pointed out in
https://bugzilla.kernel.org/show_bug.cgi?id=82341
is correct so let us play safe.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/um/os-Linux/drivers/ethertap_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index b39b669..6d49182 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -105,7 +105,7 @@ static int etap_tramp(char *dev, char *gate, int control_me,
 	sprintf(data_fd_buf, "%d", data_remote);
 	sprintf(version_buf, "%d", UML_NET_VERSION);
 	if (gate != NULL) {
-		strcpy(gate_buf, gate);
+		strncpy(gate_buf, gate, 15);
 		args = setup_args;
 	}
 	else args = nosetup_args;

