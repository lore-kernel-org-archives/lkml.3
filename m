Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaEIMwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:52:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaEIMwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:52:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 0/5] kbuild: Use relative paths if possible
Date: Fri,  9 May 2014 14:52:19 +0200
Message-Id: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series changes the Makefile to use relative paths for $(objtree),
always setting it to '.', and for $(srctree) setting either to '.' or
'..', when building in the source tree or a subdirectory thereof,
respectively. The goal is to make compiler messages and Oopses more
readable by avoiding the full path to the source/object directory.

Patch 2/5 is just an unrelated cleanup.

v1->v2: Fix the 'build' and 'source' symlinks in /lib/modules

Michal Marek (5):
  firmware: Simplify directory creation
  firmware: Use $(quote) in the Makefile
  kbuild: Use relative path for $(objtree)
  kbuild: Use relative path when building in the source tree
  kbuild: Use relative path when building in a subdir of the source tree

 Makefile                | 18 ++++++++++++++----
 firmware/Makefile       | 34 +++++++---------------------------
 scripts/Makefile.fwinst | 24 +++++++++++-------------
 3 files changed, 32 insertions(+), 44 deletions(-)

-- 
1.8.4.5

