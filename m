Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbaCUAGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:06:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbaCUAE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 144/149] regulator: core: Change dummy supplies error message to a warning
Date: Thu, 20 Mar 2014 17:05:07 -0700
Message-Id: <20140321000441.949251121@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.kh@samsung.com>

commit acc3d5cec84f82ebea535fa0bd9500ac3df2aee9 upstream.

Change "dummy supplies not allowed" error message to warning instead, as this
is a just warning message with no change to the behavior.

[Added a CC to stable since some other bug fixes cause this to come up
more frequently on PCs which is how it was noticed -- broonie]

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1360,7 +1360,7 @@ static struct regulator *_regulator_get(
 		rdev = dummy_regulator_rdev;
 		goto found;
 	} else {
-		dev_err(dev, "dummy supplies not allowed\n");
+		dev_warn(dev, "dummy supplies not allowed\n");
 	}
 
 	mutex_unlock(&regulator_list_mutex);


