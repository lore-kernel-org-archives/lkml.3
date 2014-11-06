Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaKFMDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:03:34 -0500
Received: from mout.gmx.net ([212.227.17.22]:55311 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaKFMDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:03:30 -0500
From: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
Subject: [PATCH] xconfig: Don't move focus when clicking on the search button
Date: Thu,  6 Nov 2014 13:03:01 +0100
Message-Id: <1415275383-15301-2-git-send-email-syntheticpp@gmx.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
References: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:5tqACOA5+PVpJmpVe4/zowsn4GJbrJjGuRHCjXX2/bHXLPis8I7
 oTHrvl8G6u50vOAj1cLvGgFrRW/yKBd+j6JpYBS/3Cy3btf84m62gj3vr1IS4reVjMU3Upq
 WUA9bb+GsGUS+mSuGeJKtT/9VcACFJFMdvaOP5R8HRDg5jcsaJ9Kwg35FDVvbb/jpFo7zaR
 bzh79qysil4t+rbn3OTgQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the search button is clicked the focus moves to the
search button. Changing the search text after such a button
press requires an additional click into the edit field.
With this patch this click is not necessary anymore because
the button is configured to not accept the focus.

Signed-off-by: Peter Kümmel <syntheticpp@gmx.net>
---
 scripts/kconfig/qconf.cc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 9d3b04b..750a5ff 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1198,6 +1198,7 @@ ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow* parent, const char *nam
 	layout2->addWidget(editField);
 	searchButton = new QPushButton(_("Search"), this);
 	searchButton->setAutoDefault(FALSE);
+	searchButton->setFocusPolicy(Qt::NoFocus);
 	connect(searchButton, SIGNAL(clicked()), SLOT(search()));
 	layout2->addWidget(searchButton);
 	layout1->addLayout(layout2);
-- 
1.9.1

