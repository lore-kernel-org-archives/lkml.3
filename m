Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3KVLfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:35:55 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38959 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3KVLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:35:54 -0500
Date: Fri, 22 Nov 2013 13:37:48 +0200
From: Adrian Pop <sultryweather@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for Nov 21 (nouveau)
Message-ID: <20131122113748.GB20300@shodan>
References: <20131121140411.092318822bbd82b7b47e0d53@canb.auug.org.au>
 <528E2BC3.4040007@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <528E2BC3.4040007@infradead.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

> on x86_64:
> 
> CONFIG_HWMON is not enabled.
> 
> drivers/gpu/drm/nouveau/nouveau_hwmon.c: In function 'nouveau_hwmon_init':
> drivers/gpu/drm/nouveau/nouveau_hwmon.c:633:2: error: 'hwmon' undeclared (first use in this function)

I've attached a patch that fixes the build for me when using this
config.


--TRYliJ5NKNqkz5bu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-nouveau-Fixed-the-hwmon-undeclared-build-error.patch"

From: Adrian Pop <sultryweather@gmail.com>
Date: Fri, 22 Nov 2013 12:52:19 +0200
Subject: [PATCH] nouveau: Fixed the 'hwmon' undeclared build error

hwmon is declared inside the #if defined(CONFIG_HWMON)... but is still
referenced outside of it, which results in a build error. By removing
the reference, Linux builds successfully with both code paths.
Two warnings from running checkpatch.pl have been fixed too.

Signed-off-by: Adrian Pop <sultryweather@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_hwmon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_hwmon.c b/drivers/gpu/drm/nouveau/nouveau_hwmon.c
index 38a4db5..21fc8d6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hwmon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_hwmon.c
@@ -357,7 +357,7 @@ nouveau_hwmon_show_fan1_input(struct device *d, struct device_attribute *attr,
 static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, nouveau_hwmon_show_fan1_input,
 			  NULL, 0);
 
- static ssize_t
+static ssize_t
 nouveau_hwmon_get_pwm1_enable(struct device *d,
 			   struct device_attribute *a, char *buf)
 {
@@ -383,7 +383,7 @@ nouveau_hwmon_set_pwm1_enable(struct device *d, struct device_attribute *a,
 	long value;
 	int ret;
 
-	if (strict_strtol(buf, 10, &value) == -EINVAL)
+	if (kstrtol(buf, 10, &value) == -EINVAL)
 		return -EINVAL;
 
 	ret = therm->attr_set(therm, NOUVEAU_THERM_ATTR_FAN_MODE, value);
@@ -630,7 +630,6 @@ error:
 	hwmon->hwmon = NULL;
 	return ret;
 #else
-	hwmon->hwmon = NULL;
 	return 0;
 #endif
 }
-- 
1.8.4.2


--TRYliJ5NKNqkz5bu--
