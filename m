Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaKLB3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaKLB3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robin van der Gracht <robin@protonic.nl>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.17 188/319] iio: st_sensors: Fix buffer copy
Date: Wed, 12 Nov 2014 10:15:26 +0900
Message-Id: <20141112011023.860673836@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin van der Gracht <robin@protonic.nl>

commit 4250c90b30b8bf2a1a21122ba0484f8f351f152d upstream.

Use byte_for_channel as iterator to properly initialize the buffer.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Acked-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/st_sensors/st_sensors_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/st_sensors/st_sensors_buffer.c
+++ b/drivers/iio/common/st_sensors/st_sensors_buffer.c
@@ -71,7 +71,7 @@ int st_sensors_get_buffer_element(struct
 				goto st_sensors_free_memory;
 			}
 
-			for (i = 0; i < n * num_data_channels; i++) {
+			for (i = 0; i < n * byte_for_channel; i++) {
 				if (i < n)
 					buf[i] = rx_array[i];
 				else


