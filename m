Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840AbaE3Xp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:45:27 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:52591 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3Xp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:45:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "David S. Miller" <davem@davemloft.net>,
        Mathias Krause <minipli@googlemail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: connector: ucon.c:  Cleaning up file resource leak
Date: Sat, 31 May 2014 01:46:18 +0200
Message-Id: <1401493578-20392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up a file resource leak

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 Documentation/connector/ucon.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/connector/ucon.c b/Documentation/connector/ucon.c
index 8a4da64..f09c6de 100644
--- a/Documentation/connector/ucon.c
+++ b/Documentation/connector/ucon.c
@@ -246,5 +246,7 @@ int main(int argc, char *argv[])
 	}
 
 	close(s);
+	if (stdout != out)
+		fclose(out);
 	return 0;
 }
-- 
1.7.10.4

