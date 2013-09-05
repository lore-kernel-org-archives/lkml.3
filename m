Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3IEUee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:34:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab3IEU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 05/14] regmap: silence GCC warning
Date: Thu,  5 Sep 2013 13:28:16 -0700
Message-Id: <20130905202615.040292775@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
References: <20130905202614.354156084@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit a8f28cfad8cd44d7c34b166d0e5ace1125dbee1f upstream.

Building regmap.o triggers this GCC warning:
    drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
    drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Long story short: Jakub Jelinek pointed out that there is a type
mismatch between 'num' in regmap_volatile_range() and 'val_count' in
regmap_raw_read(). And indeed, converting 'num' to the type of
'val_count' (ie, size_t) makes this warning go away.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -69,7 +69,7 @@ bool regmap_precious(struct regmap *map,
 }
 
 static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
-	unsigned int num)
+	size_t num)
 {
 	unsigned int i;
 


