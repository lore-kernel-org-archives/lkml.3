Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaIVROG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:14:06 -0400
Received: from mout.web.de ([212.227.17.12]:53361 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbaIVROC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:14:02 -0400
From: Martin Walch <walch.martin@web.de>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Walch <walch.martin@web.de>
Subject: [Resending PATCH v2 0/2] kconfig: fix bad syntactic transformation
Date: Mon, 22 Sep 2014 19:13:17 +0200
Message-Id: <1411405999-20212-1-git-send-email-walch.martin@web.de>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <3491939.FtiyjGE4Of@tacticalops>
References: <3491939.FtiyjGE4Of@tacticalops>
X-Provags-ID: V03:K0:GRrqIvXrSDjZCn091/bvSrcKeXTh5htMoPVAEbATszETA7QPJzO
 HDt1bCRvQFlvWyzJE4CS6O7LMcRWpkfvlRFTlyr5wSZp79p+Uetn2kvjjyofGhi+O7Sztb3
 HRqcKpul9WxNir+BIRJcbNf1raV6I3vaU93I3/SorSfkjvTo18Nam8L2QEV2XlnxToty+GY
 bO8R7ayyv9dHggQsvCW6Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1: Remove these two not semantics preserving inference rules:

(FOO || BAR) && (!FOO && !BAR) -> n
(FOO && BAR) || (!FOO || !BAR) -> y

When applied, they silently alter the meaning of symbol dependencies.

PATCH 2: When touching expr.c anyway, fix some comments and convert C99 style
comments to traditional ones.

Martin Walch (2):
  kconfig: fix bad syntactic transformation in expr.c
  kconfig: trivial - adjust comments

 scripts/kconfig/expr.c | 146 +++++++------------------------------------------
 scripts/kconfig/expr.h |   3 -
 2 files changed, 19 insertions(+), 130 deletions(-)

-- 
1.8.5.5

