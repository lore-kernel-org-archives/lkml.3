Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaKLBYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaKLBYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pingc@wacom.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.17 103/319] HID: input: Fix TransducerSerialNumber implementation
Date: Wed, 12 Nov 2014 10:14:01 +0900
Message-Id: <20141112011009.633499522@linuxfoundation.org>
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

From: Jason Gerecke <killertofu@gmail.com>

commit 5989a55a4c9aafba8b152c6bf52244510c2b88b9 upstream.

The commit which introduced TransducerSerialNumber (368c966) is missing
two crucial implementation details. Firstly, the commit does not set the
type/code/bit/max fields as expected later down the code which can cause
the driver to crash when a tablet with this usage is connected. Secondly,
the call to 'set_bit' causes MSC_PULSELED to be sent instead of the
expected MSC_SERIAL. This commit addreses both issues.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -689,7 +689,10 @@ static void hidinput_configure_usage(str
 			break;
 
 		case 0x5b: /* TransducerSerialNumber */
-			set_bit(MSC_SERIAL, input->mscbit);
+			usage->type = EV_MSC;
+			usage->code = MSC_SERIAL;
+			bit = input->mscbit;
+			max = MSC_MAX;
 			break;
 
 		default:  goto unknown;


