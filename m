Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaGaLfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:35:05 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:41531 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaGaLfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:35:03 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, joe@perches.com, dan.carpenter@oracle.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v2] Staging: android: timed_gpio.c: improved logic of gpio_get_time()
Date: Thu, 31 Jul 2014 08:34:11 -0300
Message-Id: <1406806451-8210-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140731082521.GM4856@mwanda>
References: <20140731082521.GM4856@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the logic of gpio_get_time() and, thereafter,
makes checkpatch.pl happy.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---

Thanks for reviweing my patch, Dan.  I think I got the proper way
without using option --scissors in git-am.

What about this new commit message?

 drivers/staging/android/timed_gpio.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index 180c209..8fa4758 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -45,16 +45,17 @@ static enum hrtimer_restart gpio_timer_func(struct hrtimer *timer)

 static int gpio_get_time(struct timed_output_dev *dev)
 {
-	struct timed_gpio_data	*data =
-		container_of(dev, struct timed_gpio_data, dev);
+	struct timed_gpio_data *data;
+	struct timeval t;

-	if (hrtimer_active(&data->timer)) {
-		ktime_t r = hrtimer_get_remaining(&data->timer);
-		struct timeval t = ktime_to_timeval(r);
+	data = container_of(dev, struct timed_gpio_data, dev);

-		return t.tv_sec * 1000 + t.tv_usec / 1000;
-	} else
+	if (!hrtimer_active(&data->timer))
 		return 0;
+
+	t = ktime_to_timeval(hrtimer_get_remaining(&data->timer));
+
+	return t.tv_sec * 1000 + t.tv_usec / 1000;
 }

 static void gpio_enable(struct timed_output_dev *dev, int value)
--
1.7.10.4
