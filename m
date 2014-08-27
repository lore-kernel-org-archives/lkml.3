Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936001AbaH0VcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:32:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935931AbaH0VcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:32:02 -0400
Date: Wed, 27 Aug 2014 23:32:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: picolcd: sanity check report size in raw_event()
 callback
In-Reply-To: <alpine.LNX.2.00.1408271025040.2992@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1408272331250.21233@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz> <alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz> <20140827101311.098f3fd1@pluto> <alpine.LNX.2.00.1408271025040.2992@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Jiri Kosina wrote:

> > Is it worth adding report->id to this hid_warn()?
> > 
> > A valid device is not expected to ever send >64 bytes reports but in
> > case a firmware update would do so it would help to know for which
> > report it was.
> 
> It definitely wouldn't hurt. Pull request with the original patch is now 
> on its way to Linus though, so let's do this as a followup patch on top 
> once this is merged.

I've just queued the below for 3.18.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: picolcd: be more verbose when reporting report size error

picolcd device is not expected to send any report with size larger than 64 
bytes.

If this impossible event happens (sic!), print also a report ID to allow 
for easier debugging.

Suggested-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-picolcd_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 020df3c..c1b29a9 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -351,8 +351,8 @@ static int picolcd_raw_event(struct hid_device *hdev,
 		return 1;
 
 	if (size > 64) {
-		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
-				size);
+		hid_warn(hdev, "invalid size value (%d) for picolcd raw event (%d)\n",
+				size, report->id);
 		return 0;
 	}
 
-- 
Jiri Kosina
SUSE Labs
