Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaKFMDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:03:44 -0500
Received: from mout.gmx.net ([212.227.17.22]:49220 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaKFMDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:03:41 -0500
From: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
Subject: [PATCH] xconfig: Set keyboard focus to line edit whenever the search dialog opens
Date: Thu,  6 Nov 2014 13:03:03 +0100
Message-Id: <1415275383-15301-4-git-send-email-syntheticpp@gmx.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
References: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:BUyY+ZWNJ6rIhqy+E+l6qy7OxIeSx5ydJ4qCPB6utc51nTeiIeQ
 yCv3r+xBPr6H+JcPjehoepG+SJN1aj24gsod/ySm0pdXMIILW0V0SR28TppibX2OiJBkLDw
 k63iROFTDweW9T9gwFI6qilXQij5L255hl0Vc+wiP6FNB4imjht6I9y/j6yJD9M1oxu+nzM
 IBf8kgRqQOTkMYbPl2Yxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When after a search on a result is clicked the focus jumps to
the result list. So after closing and reopening the dialog the
field does not have the focus any more. This is annoying when
you press Ctrl-F and start typing for a new search because
the text shows not up in the edit field but gets lost. You
have to click additionally into the edit field to move the
focus to this field. With this patch the focus is always set
to the edit field when the dialog opens.

Signed-off-by: Peter Kümmel <syntheticpp@gmx.net>
---
 scripts/kconfig/qconf.cc | 6 ++++++
 scripts/kconfig/qconf.h  | 1 +
 2 files changed, 7 insertions(+)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 9d3b04b..7ef498d 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1235,6 +1235,11 @@ ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow* parent, const char *nam
 	}
 }
 
+void ConfigSearchWindow::setFocusOnLineEdit()
+{
+	editField->setFocus(Qt::OtherFocusReason);
+}
+
 void ConfigSearchWindow::saveSettings(void)
 {
 	if (name()) {
@@ -1506,6 +1511,7 @@ void ConfigMainWindow::searchConfig(void)
 	if (!searchWindow)
 		searchWindow = new ConfigSearchWindow(this, "search");
 	searchWindow->show();
+	searchWindow->setFocusOnLineEdit();
 }
 
 void ConfigMainWindow::changeMenu(struct menu *menu)
diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
index bde0c6b..6f2c4d6 100644
--- a/scripts/kconfig/qconf.h
+++ b/scripts/kconfig/qconf.h
@@ -288,6 +288,7 @@ public:
 public slots:
 	void saveSettings(void);
 	void search(void);
+	void setFocusOnLineEdit(void);
 
 protected:
 	QLineEdit* editField;
-- 
1.9.1

