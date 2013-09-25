Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3IYLWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:22:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44002 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3IYLWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:22:31 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-cc-5242c7755a8c
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 0/2] cpufreq: exynos: Fixes for v3.12
Date: Wed, 25 Sep 2013 13:22:16 +0200
Message-id: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2y405BBhNqLDbOWM9q0bvgKptF
	/+PXzBZvHnFbvHm4mdHi8q45bBafe48wWsw4v4/J4nbjCqCKhb1MFutnvGax2PjVw4HHY9Oq
	TjaPO9f2sHmsm/aW2aNvyypGj0eLWxg9Pm+SC2CL4rJJSc3JLEst0rdL4MqYfOkuY8E91oqj
	DyexNzDeYOli5OSQEDCRWLrjAJQtJnHh3nq2LkYuDiGB6YwSbTsnMEE4XUwSnS9mMINUsQno
	SXy++5QJxBYR8JVY+/gyI0gRs8ACZoklp7axgiSEBUwlfk54yQZiswioSqxrPwvWwCvgJnFu
	/V5GiHXyEk/v97FNYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4vJ5J7WBc2WBx
	iFGAg1GJh1fgqGOQEGtiWXFl7iFGCQ5mJRHe8MVOQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7RaBwoJpCeWpGanphakFsFkmTg4pRoYk2atXOEr96mn+YnvsdMu7spnpk7gNMvqEGd9PNPR
	ZP2L2C8WvSePz8ndv9Ms0OD4pMrdTcz3+vNW99yYn7umj/Hc2q0XOFZXdn/RMTjTX7dg2wHu
	1Rs59Drn9j9a9GBJxzOVwqUx6RbrtdMdvP4m/OON9awsbxJeGWkfVbGrmikjtl171ic3JZbi
	jERDLeai4kQAj9AaLisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached commits provide cpufreq regression fixes for Trats and Trats2
Exynos4 boards.
Since v3.12 Exynos4 uses common clock framework for clock manipulation.
Those patches restore correct output for cpuinfo_cur_freq [1] sysfs
attribute.
Without them, the [1] provides default frequency (800 MHz) set at driver
initialization.

Lukasz Majewski (2):
  cpufreq: exynos4x12: Use the common clock framework to set APLL clock
    rate
  cpufreq: exynos4210: Use the common clock framework to set APLL clock
    rate

 drivers/cpufreq/exynos4210-cpufreq.c |   20 ++++----------------
 drivers/cpufreq/exynos4x12-cpufreq.c |   23 ++++-------------------
 2 files changed, 8 insertions(+), 35 deletions(-)

-- 
1.7.10.4

