Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbaGCVIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaGCVIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/9] pkcs7: Forward declare struct key in pkcs7.h
Date: Thu,  3 Jul 2014 17:07:13 -0400
Message-Id: <1404421641-12691-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a forward declaration of "struct key" in pkcs.h as one of the functions
takes pointer to struct key as argument.

Otherwise when I include this header file in some other .c file where
key.h is not included, I get following warning later in the series.

In file included from arch/x86/kernel/mscode_parser.c:17:0:
include/crypto/pkcs7.h:30:5: warning: ‘struct key’ declared inside parameter list [enabled by default]
     bool *_trusted);
     ^
include/crypto/pkcs7.h:30:5: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/crypto/pkcs7.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 167f914..4c227e3 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -10,6 +10,7 @@
  */
 
 struct pkcs7_message;
+struct key;
 
 /*
  * pkcs7_parser.c
-- 
1.9.0

