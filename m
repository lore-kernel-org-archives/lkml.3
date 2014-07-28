Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaG1LN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:13:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38017 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1LNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:13:52 -0400
Date: Mon, 28 Jul 2014 13:13:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCHv3] Documentation: laptops: freefall.c: simplify to avoid
 null-termination problems
Message-ID: <20140728111351.GB17250@amd.pavel.ucw.cz>
References: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53D58550.6040205@infradead.org>
 <20140728102040.GA16495@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728102040.GA16495@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Copying to local variable is actually not neccessary, if all we need
to do is snprintf(). This also removes problem where devname could be
missing zero termination.

Reported-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
index aab2ff0..5e44b20 100644
--- a/Documentation/laptops/freefall.c
+++ b/Documentation/laptops/freefall.c
@@ -29,15 +29,12 @@ static const char app_name[] = "FREE FALL";
 
 static int set_unload_heads_path(char *device)
 {
-	char devname[64];
-
 	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
-	strncpy(devname, device + 5, sizeof(devname) - 1);
 	strncpy(device_path, device, sizeof(device_path) - 1);
 
 	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
-				"/sys/block/%s/device/unload_heads", devname);
+				"/sys/block/%s/device/unload_heads", device+5);
 	return 0;
 }
 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
