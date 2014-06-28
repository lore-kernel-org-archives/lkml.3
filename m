Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaF1Sv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:51:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaF1RtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.14 035/110] s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall
Date: Sat, 28 Jun 2014 10:46:32 -0700
Message-Id: <20140628174547.264772982@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit b6f4296279ab3ada554d993d12844272fd86b36a upstream.

Analog to git commit 28b92e09e25bdc0ae864b22eacf195a74f861389
first cast tk->wall_to_monotonic.tv_nsec to u64 before doing
the shift with tk->shift to avoid loosing relevant bits on a
32-bit kernel.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -226,7 +226,7 @@ void update_vsyscall(struct timekeeper *
 	vdso_data->wtom_clock_sec =
 		tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = tk->xtime_nsec +
-		+ (tk->wall_to_monotonic.tv_nsec << tk->shift);
+		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->shift);
 	nsecps = (u64) NSEC_PER_SEC << tk->shift;
 	while (vdso_data->wtom_clock_nsec >= nsecps) {
 		vdso_data->wtom_clock_nsec -= nsecps;


