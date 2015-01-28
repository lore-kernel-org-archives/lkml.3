Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbbA1Bk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:40:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392AbbA1Bik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 24/77] x86/tsc: Change Fast TSC calibration failed from error to info
Date: Tue, 27 Jan 2015 17:27:02 -0800
Message-Id: <20150128012746.690387470@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Demers <alexandre.f.demers@gmail.com>

commit 520452172e6b318f3a8bd9d4fe1e25066393de25 upstream.

Many users see this message when booting without knowning that it is
of no importance and that TSC calibration may have succeeded by
another way.

As explained by Paul Bolle in
http://lkml.kernel.org/r/1348488259.1436.22.camel@x61.thuisdomein

  "Fast TSC calibration failed" should not be considered as an error
  since other calibration methods are being tried afterward. At most,
  those send a warning if they fail (not an error). So let's change
  the message from error to warning.

[ tglx: Make if pr_info. It's really not important at all ]

Fixes: c767a54ba065 x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Link: http://lkml.kernel.org/r/1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -618,7 +618,7 @@ static unsigned long quick_pit_calibrate
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:


