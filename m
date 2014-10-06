Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaJFFJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbaJFFJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:31 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 13/13] Documentation: add a section for /proc/<pid>/ns/
Date: Mon,  6 Oct 2014 01:08:38 -0400
Message-Id: <982503bc4e4c24cbdebd111b27191ed5bee75572.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Documentation/filesystems/proc.txt |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ddc531a..c4bfd6f 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -42,6 +42,7 @@ Table of Contents
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
   3.7   /proc/<pid>/task/<tid>/children - Information about task children
   3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
+  3.9   /proc/<pid>/ns/<ns>{,_snum} - Information about process namespaces
 
   4	Configuring procfs
   4.1	Mount options
@@ -1744,6 +1745,21 @@ pair provide additional information particular to the objects they represent.
 	optional and may be omitted if no marks created yet.
 
 
+3.9	/proc/<pid>/ns/<nstype>{,_snum} - Information about process namespaces
+--------------------------------------------------------------------------
+These files provides information about the namespaces within which the process
+is contained.  The files named only with the namespace type <nstype> contain a
+link that lists the containing namespace' inode number in its proc filesystem.
+The files with suffix _snum contain a link that lists the containing
+namespace' instance serial number, unique per kernel since boot.  The
+namespace types are self-describing.
+
+The output format of the inode links is:
+	<nstype>:[<inode_number>]
+The output format of the serial number links is:
+	<nstype>_snum:[<serial_number>]
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
-- 
1.7.1

