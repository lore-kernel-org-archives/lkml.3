Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaJCVpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbaJCVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Pointner <johannes.pointner@br-automation.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.16 229/357] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
Date: Fri,  3 Oct 2014 14:30:15 -0700
Message-Id: <20141003212940.392508782@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Pointner <johannes.pointner@gmail.com>

commit 872687f626e033b4ddfaec1e410057cfc6636d77 upstream.

Fixes: a2c12493ed7e ('iio: of_iio_channel_get_by_name() returns non-null pointers for error legs')

which improperly assumes that of_iio_channel_get_by_name must always
return NULL and thus now hides -EPROBE_DEFER.

Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -178,7 +178,7 @@ static struct iio_channel *of_iio_channe
 			index = of_property_match_string(np, "io-channel-names",
 							 name);
 		chan = of_iio_channel_get(np, index);
-		if (!IS_ERR(chan))
+		if (!IS_ERR(chan) || PTR_ERR(chan) == -EPROBE_DEFER)
 			break;
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",


