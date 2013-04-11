Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019Ab3DKN1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab3DKN1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:27:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 01/26] procfs: Mark create_proc_read_entry deprecated [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:27:47 +0100
Message-ID: <20130411132747.32763.6464.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark create_proc_read_entry deprecated.  proc_create[_data]() should be used
instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/proc_fs.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 2781e49..8175b49 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -155,7 +155,8 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 	return proc_create_data(name, mode, parent, proc_fops, NULL);
 }
 
-extern struct proc_dir_entry *create_proc_read_entry(const char *name,
+extern __deprecated
+struct proc_dir_entry *create_proc_read_entry(const char *name,
 	umode_t mode, struct proc_dir_entry *base, 
 	read_proc_t *read_proc, void *data);
  
@@ -191,7 +192,8 @@ static inline struct proc_dir_entry *proc_mkdir(const char *name,
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
 
-static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
+static inline __deprecated
+struct proc_dir_entry *create_proc_read_entry(const char *name,
 	umode_t mode, struct proc_dir_entry *base, 
 	read_proc_t *read_proc, void * data) { return NULL; }
 

