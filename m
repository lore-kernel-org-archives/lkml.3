Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaLVN7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:59:43 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39850 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaLVN7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:59:42 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org
Subject: System automatically wakes up because of Intel Rapid Start Technology
Date: Mon, 22 Dec 2014 14:59:38 +0100
Message-ID: <9927036.n7iZq92iLW@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to ask those of you who own a system that supports Intel Rapid 
Start Technology (IRST) to perform a simple test to determine whether my 
laptop (XPS13 9333) is the only system affected by a bug related to IRST 
that I recently found or not.

In the past months I noticed random transitions from S3 to S0 with no 
apparent reason.
After some recent tests I found a way to trigger those automatic state 
transitions. It seems that the timer in charge of the resume of the 
system for the transition to S4 is not re-initialized on resume/suspend. 
Exactly "wakeup_time" minutes after the transition from S0 to S3, the 
system will automatically transition from S3 to S0 instead of S4 if
within that interval it transitioned to S0 at least once.
Everything works as expected if the system is never resumed or if the 
system is suspended after "wakeup_time" minutes have passed since the
first suspension to ram.

In addition to that, changing the values of wakeup_time and 
wakeup_events seems to have no effect until the timer has expired.

According to the Implementation Guide [1] there are no special 
requirements other than the standard S3 ACPI support. Still, IRST works 
as intended only on Windows. This makes me wonder whether the problem is 
due to some vendor specific change or not.

To quickly replicate the problem, follow the following steps: set the 
timer to 1 minute and suspend the system. Immediately after that, resume 
and suspend the system again. If it automatically wakes up after 1 
minute has passed since the first suspension, then the system is
affected by the bug. If this is the case, I'd suggest to default
wakeup_events to 0 or 2 to prevent issues and add some sort of warning
somewhere to let users know about this problem.

Regards,
Gabriele

[1] http://downloadmirror.intel.com/22647/eng/Intel%20Rapid%20Start%20Technology%20Deployment%20Guide%20v1.0.pdf
