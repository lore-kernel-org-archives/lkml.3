Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab3JOFXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:23:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3JOFWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:55 -0400
Date: Mon, 14 Oct 2013 22:22:42 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-1ba6e01782fd2a94481e18b91b363636f8171565@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1372941691-14684-2-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Don'
 t dictate perf install location
Git-Commit-ID: 1ba6e01782fd2a94481e18b91b363636f8171565
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ba6e01782fd2a94481e18b91b363636f8171565
Gitweb:     http://git.kernel.org/tip/1ba6e01782fd2a94481e18b91b363636f8171565
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 4 Jul 2013 18:11:25 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:40 -0300

perf completion: Don't dictate perf install location

The statement

  have perf

limits the locations in which to look for the perf program.  Moreover,
it depends on the bash-completion package to be installed.  Replace it
with a call to `type perf`.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 56e6a12..50540cf 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -19,7 +19,7 @@ __ltrim_colon_completions()
 	fi
 }
 
-have perf &&
+type perf &>/dev/null &&
 _perf()
 {
 	local cur prev cmd
