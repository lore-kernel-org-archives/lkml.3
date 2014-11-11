Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaKKQXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:23:33 -0500
Received: from mout.gmx.net ([212.227.15.18]:57703 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaKKQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:23:32 -0500
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH] getrandom.2: treatment of interrupts
Date: Tue, 11 Nov 2014 17:19:58 +0100
Message-Id: <1415722798-4894-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <CAKgNAkj_Bs7d=YV_CFLNHuJacbp_+Kk_Jux_FdiBSuUAsObA=Q@mail.gmail.com>
References: <CAKgNAkj_Bs7d=YV_CFLNHuJacbp_+Kk_Jux_FdiBSuUAsObA=Q@mail.gmail.com>
X-Provags-ID: V03:K0:YvDZIS/ij/o+h+6kFLU+KloD0AXB/U8fdkgCINvbKiW0bG8F+5G
 7I3Gj9RklP18kU+lR4sVV4pEyqlFqAWRKZccVm7W6S+aVv9DJhLAUKPf6C34wJ1UBf/6IjB
 hleZo3A+0XLawaL77qKK4n6pmXnUbEIK/hrYVj02fYqwY7h+dP5oqPI2U82Cdu5iJMwFPsM
 SnHN9ZxLCMOIiB578cBuQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

|| pick 0ef180e getrandom.2: Add a sentence to clarify the default behavior...
|| pick 62342ef getrandom.2: Reword GRND_NONBLOCK description
|| pick 0c90d3d getrandom.2: Reword GRND_RANDOM description
These patches look ok.

|| FIXME is the following paragraph correct?
Paragraph is correct. FIXME removed.

The appended patch removed two FIXMEs.
The description of the treatment of interrupts is updated.

|| FIXME Here, I think there needs to be an opening paragraph ...
The description of the treatment of interupts has been reworked.
FIXME removed.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 man2/getrandom.2 | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/man2/getrandom.2 b/man2/getrandom.2
index 59ebbe0..5bf57b7 100644
--- a/man2/getrandom.2
+++ b/man2/getrandom.2
@@ -55,7 +55,6 @@ Therefore
 should not be used for Monte Carlo simulations or other
 programs/algorithms which are doing probabilistic sampling.
 
-.\" FIXME is the following paragraph correct?
 By default,
 .BR getrandom ()
 draws entropy from the
@@ -157,10 +156,14 @@ was introduced in version 3.17 of the Linux kernel.
 This system call is Linux-specific.
 .SH NOTES
 .SS Interruption by a signal handler
-.\" FIXME Here, I think there needs to be an opening paragraph that describes
-.\" the cases where getrandom() can block. This should cover the cases with
-.\" GRND_RANDOM and without GRND_RANDOM. Reading the existing page, I am
-.\" still not completely confident that I know what the cases are.
+If a blocking call is interrupted by a signal
+when reading from
+.I /dev/random
+.RB ( GRND_RANDOM
+is set),
+.B EINTR
+will be returned.
+.PP
 The reaction of
 .BR getrandom ()
 in case of an interruption of a blocking call by a signal
@@ -182,14 +185,6 @@ will not return
 .BR EINTR .
 Instead, it will return all of the bytes that have been requested.
 .PP
-When reading from
-.I /dev/random
-.RB ( GRND_RANDOM
-is set)
-these guarantees do
-.I not
-apply.
-.PP
 Calling
 .BR getrandom ()
 to read
-- 
2.1.1

