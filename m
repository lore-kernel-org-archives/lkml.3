Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaJEWPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:15:17 -0400
Received: from mail-wg0-f68.google.com ([74.125.82.68]:64029 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaJEWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:15:13 -0400
MIME-Version: 1.0
From: Jason Noakes <jjnoakes@gmail.com>
Date: Sun, 5 Oct 2014 18:14:52 -0400
Message-ID: <CAN2+FELU6ZprSLOU5GYXHq1-jQDHBKaDC98fRuqBWwQkPXmtwA@mail.gmail.com>
Subject: [PATCH] Add zero-object requirement to kobject documentation
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly document the requirement that the memory passed to
kobject_init() must be zero-initialized beforehand.

Signed-off-by: Jason J. Noakes <jjnoakes@gmail.com>

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index f87241d..1b38727 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -113,8 +113,14 @@ question.  That macro is subsequently invoked with:

 Initialization of kobjects

-Code which creates a kobject must, of course, initialize that object. Some
-of the internal fields are setup with a (mandatory) call to kobject_init():
+Code which creates a kobject must, of course, initialize that object.
+
+First, ensure the memory for the kobject is initialized to zero; this is
+typically accomplished by obtaining the memory for the kobject (and the
+structure it is embedded in) from a call to kzalloc().
+
+Then, some of the internal fields must be setup with a (mandatory) call
+to kobject_init():

     void kobject_init(struct kobject *kobj, struct kobj_type *ktype);

diff --git a/lib/kobject.c b/lib/kobject.c
index 58751bb..46fc865 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -307,6 +307,8 @@ EXPORT_SYMBOL(kobject_set_name);
  * This function will properly initialize a kobject such that it can then
  * be passed to the kobject_add() call.
  *
+ * The kobject must be initialized to zero prior to calling this function.
+ *
  * After this function is called, the kobject MUST be cleaned up by a call
  * to kobject_put(), not by a call to kfree directly to ensure that all of
  * the memory is cleaned up properly.
