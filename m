Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3BYLcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:32:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3BYLcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:32:22 -0500
Date: Mon, 25 Feb 2013 12:32:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: fix sign check of an unsigned variable in cpufreq-cpu0
Message-ID: <Pine.LNX.4.64.1302251227140.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:lwH7kwtk8UOftyI4QHx+qFTytmz//9+iK5plIihBnjf
 RtdWhYrxj4ARJxtujrdlg8cYrpWtohyqiseAPpqVurP8j09Bvq
 uwPQ9Zq6ObJlUY7b8aSZkkwcZAn9R95So5/l77eqZHbOYJ8pR6
 y+28bgpJEfpsLg/WO3KyPnH73yUu9oLW5nGv+BmCzdzZt1G2Z7
 dWggys+A/HVK42ngN0dw1XfgjZzE9jlRD/lCgJptMULfTDH2IJ
 zYuTspU8ruDKyjaheKYv+LQR09VPgu6fJqZko09BJk1cWYdeIf
 Gdi/HrZTbbfgyFJ34fEWQnhq/i70jSbPNMrZ2o5DZYc7d2Od5v
 h8DaMpiY5+5qDtg9/XyD9YByRDnSyao3RmRGFx54azz/qnGUPJ
 qLrW8eJ/eXuwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A "< 0" test for an unsigned variable is meaningless, change the variable
to signed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

stable?

 drivers/cpufreq/cpufreq-cpu0.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 52bf36d..e7bad3c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -44,7 +44,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
-	unsigned long freq_Hz, volt = 0, volt_old = 0, tol = 0;
+	unsigned long volt = 0, volt_old = 0, tol = 0;
+	long freq_Hz;
 	unsigned int index, cpu;
 	int ret;
 
-- 
1.7.2.5

