Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611Ab3K0By7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:54:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab3K0A5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qingshuai Tian <qingshuai.tian@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 22/80] ACPI / video: Quirk initial backlight level 0
Date: Tue, 26 Nov 2013 16:56:51 -0800
Message-Id: <20131127005642.478898145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 2c62333a408f5badd2d2ffd7177f95deeccc5ca4 upstream.

Some firmware doesn't initialize initial backlight level to a proper
value and _BQC will return 0 on first time evaluation. We used to be
able to detect such incorrect value with our code logic, as value 0
normally isn't a valid value in _BCL. But with the introduction of Win8,
firmware begins to fill _BCL with values from 0 to 100, now 0 becomes
a valid value but that value will make user's screen black. This patch
test initial _BQC for value 0, if such a value is returned, do not use
it.

References: https://bugzilla.kernel.org/show_bug.cgi?id=64031
References: https://bugzilla.kernel.org/show_bug.cgi?id=61231
References: https://bugzilla.kernel.org/show_bug.cgi?id=63111
Reported-by: Qingshuai Tian <qingshuai.tian@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com> # on "Idealpad u330p"
Reported-and-tested-by: <erno@iki.fi> # on "Acer Aspire V5-573G"
Reported-and-tested-by: Kirill Tkhai <tkhai@yandex.ru> # on "HP 250 G1"
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -846,7 +846,7 @@ acpi_video_init_brightness(struct acpi_v
 		for (i = 2; i < br->count; i++)
 			if (level_old == br->levels[i])
 				break;
-		if (i == br->count)
+		if (i == br->count || !level)
 			level = max_level;
 	}
 


