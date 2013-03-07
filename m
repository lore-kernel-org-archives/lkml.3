Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab3CGPGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:06:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3CGPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:06:41 -0500
Message-ID: <5138ACFE.30701@canonical.com>
Date: Thu, 07 Mar 2013 16:06:38 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] efivarfs: loosen restriction on valid names
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da27a2438 (efivarfs: guid part of filenames are case-insensitive) fails to boot,
because the kernel creates files in the form of dump-type-x-y-z-GUID. Since the kernel already
created files in this form, these type of files obviously exist, so the right course of action
is to relax the restriction in efivarfs_valid_name.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: stable@vger.kernel.org [3.8]
---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8bcb595..3ee1882 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -921,8 +921,8 @@ static bool efivarfs_valid_name(const char *str, int len)
 	if (len < GUID_LEN + 2)
 		return false;
 
-	/* GUID should be right after the first '-' */
-	if (s - 1 != strchr(str, '-'))
+	/* GUID should be prefixed with - */
+	if (s[-1] != '-')
 		return false;
 
 	/*

