Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966251Ab3E2OTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:19:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966092Ab3E2OTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:19:52 -0400
Date: Wed, 29 May 2013 16:19:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Daniel Leung <daniel.leung@linux.intel.com>, srinivas.pandruvada@intel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-sensor-hub: do not process feature reports in
 raw_event
In-Reply-To: <516588E2.4030901@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1305291619040.30576@pobox.suse.cz>
References: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com>    <51507136.4020308@linux.intel.com>    <alpine.LNX.2.00.1303271608500.23442@pobox.suse.cz>    <38514.10.7.197.74.1365440092.squirrel@linux.intel.com> <33544.10.7.197.74.1365551736.squirrel@linux.intel.com>
 <516588E2.4030901@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Srinivas Pandruvada wrote:

> I don't know if this should be fixed in client drivers since other drivers may
> have this issue.

Agreed.

Srinivas, how about the patch below, could you please test it in your 
scenario to see whether it actually fixes the issue?

Thanks.


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..65879b9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1293,7 +1293,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 
 	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
 		ret = hdrv->raw_event(hid, report, data, size);
-		if (ret != 0) {
+		if (ret < 0) {
 			ret = ret < 0 ? ret : 0;
 			goto unlock;
 		}
-- 
Jiri Kosina
SUSE Labs
