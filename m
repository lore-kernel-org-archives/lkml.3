Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbaD2OIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaD2OIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:23 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] kbuild: Use relative paths if possible
Date: Tue, 29 Apr 2014 16:08:08 +0200
Message-Id: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series changes the Makefile to use relative paths for $(objtree),
always setting it to '.', and for $(srctree) setting either to '.' or
'..', when building in the source tree or a subdirectory thereof,
respectively. The goal is to make compiler messages and Ooopses more
readable by avoiding the full path to the source/object directory.

Patch 2/5 is just an unrelated cleanup.

Michal

Michal Marek (5):
  firmware: Simplify directory creation
  firmware: Use $(quote) in the Makefile
  kbuild: Use relative path for $(objtree)
  kbuild: Use relative path when building in the source tree
  kbuild: Use relative path when building in a subdir of the source tree

 Makefile                | 14 ++++++++++++--
 firmware/Makefile       | 34 +++++++---------------------------
 scripts/Makefile.fwinst | 24 +++++++++++-------------
 3 files changed, 30 insertions(+), 42 deletions(-)

-- 
1.9.2

