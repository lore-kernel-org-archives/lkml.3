Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3I3Of4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:35:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3I3Ofw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:35:52 -0400
Date: Mon, 30 Sep 2013 16:35:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: list@osuosl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org, thomas@m3y3r.de
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to
 memdup
In-Reply-To: <20130927152412.GF6192@mwanda>
Message-ID: <alpine.LNX.2.00.1309301634260.28935@pobox.suse.cz>
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com> <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz> <52432152.3030100@canonical.com>
 <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz> <52459942.3020600@canonical.com> <20130927152412.GF6192@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Dan Carpenter wrote:

> It looks like magicmouse_raw_event() returns 1 on success and 0 on
> failure.

Good catch indeed.

I am not completely sure whether we are going to fix an oops or not by 
this, as I haven't seen the actual oops anywhere in this thread :) But 
definitely this looks like a good fix.

Joseph, could you please test with that? Thanks.



diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 3b43d1c..c211eb9 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -334,7 +334,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 			size - 2 - data[1]);
 		break;
 	default:
-		return 0;
+		return 1;
 	}
 
 	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
@@ -347,7 +347,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 	}
 
 	input_sync(input);
-	return 1;
+	return 0;
 }
 
 static int magicmouse_setup_input(struct input_dev *input, struct hid_device *hdev)

-- 
Jiri Kosina
SUSE Labs
