Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaJCWnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:43:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaJCWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 078/143] iio:trigger: modify return value for iio_trigger_get
Date: Fri,  3 Oct 2014 14:34:33 -0700
Message-Id: <20141003213316.852071998@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit f153566570fb9e32c2f59182883f4f66048788fb upstream.

Instead of a void function, return the trigger pointer.

Whilst not in of itself a fix, this makes the following set of
7 fixes cleaner than they would otherwise be.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/iio/trigger.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/iio/trigger.h
+++ b/include/linux/iio/trigger.h
@@ -83,10 +83,12 @@ static inline void iio_trigger_put(struc
 	put_device(&trig->dev);
 }
 
-static inline void iio_trigger_get(struct iio_trigger *trig)
+static inline struct iio_trigger *iio_trigger_get(struct iio_trigger *trig)
 {
 	get_device(&trig->dev);
 	__module_get(trig->ops->owner);
+
+	return trig;
 }
 
 /**


