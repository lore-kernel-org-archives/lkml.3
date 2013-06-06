Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3FFUyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:54:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59556 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab3FFUyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:54:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/8] kobject: sanitize argument for format string
Date: Thu,  6 Jun 2013 13:52:19 -0700
Message-Id: <1370551945-8444-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370551945-8444-1-git-send-email-keescook@chromium.org>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike kobject_set_name(), the kset_create_and_add() interface does not
provide a way to use format strings, so make sure that the interface
cannot be abused accidentally. It looks like all current callers use
static strings, so there's no existing flaw.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index b7e29a6..4a1f33d 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -805,7 +805,7 @@ static struct kset *kset_create(const char *name,
 	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
 	if (!kset)
 		return NULL;
-	retval = kobject_set_name(&kset->kobj, name);
+	retval = kobject_set_name(&kset->kobj, "%s", name);
 	if (retval) {
 		kfree(kset);
 		return NULL;
-- 
1.7.9.5

