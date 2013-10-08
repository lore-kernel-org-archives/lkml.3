Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3JHU0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:26:25 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:37130 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3JHU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:26:24 -0400
Subject: [PATCH 2/2] kobject: fix kset sample error path
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Tue, 08 Oct 2013 14:20:24 -0600
Message-ID: <20131008202024.19377.25396.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, example_init() leaked a kset if any of the object creations
failed.  This fixes the leak by calling kset_unregister() in the error
path.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 samples/kobject/kset-example.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index d0c687f..5dce351 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -262,6 +262,7 @@ baz_error:
 bar_error:
 	destroy_foo_obj(foo_obj);
 foo_error:
+	kset_unregister(example_kset);
 	return -EINVAL;
 }
 

