Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3CDXjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:39:21 -0500
Received: from nm14.bullet.mail.ird.yahoo.com ([77.238.189.67]:21614 "HELO
	nm14.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753742Ab3CDXjU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:39:20 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 18:39:19 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 512741.84457.bm@omp1027.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yJv0mMRSQE8MOzpHIdx2bgER/mjWlLvuygB+/R093+aKVALfHLM3v3epQpuu/CVcQ5ScNfJu5iXHavaZ3YLXijnsYTeqaSE3m3pJTM8g8wuJ784mx2W+0d6LRIIoeuZTKq9CJXtNxZxjJ0m8oJrzjV+LRqIpBk575LvCu1sMpfU=;
X-YMail-OSG: C53OMXUVM1lcvYyDu7r7SXPDDinoUukE5gWuerrGJQnIaym
 .7Ia75Fl79gdgbi.2nKDgXgHiqFh3q6RRJHEara7AcumB0t7T2QxSs24wGaD
 NTt5QDTPa9rqvqU_0SsAhpQfZkBr8_IbRhwN5NxP3eOIMDamxcB18VdL4Zq7
 SJcMlYwBdx6u_ZihPch.pYQ4X1.YSAKvWxJTvf8J03FHAfot3dacNNjygA1v
 0GyOkfmfwFJZL3zbBn0Dkalh3mnJ0cFWPpSOQPnidMILD3K6KHDaRFB5wNBw
 qgffqowb1t2UuhFFVotBn6glR_WSXRg2XXUDYuOqr6sdkKbELf9KfxlUDPxO
 XDwlXAji1tVVeU3HSQKo6EbBAQwIia1_Iuj_P4jUvUvdWe2xVLel6RNO2Xpa
 MatPTYo1NOc5fxFqGOCKpj8oCYOsvfb0-
X-Rocket-MIMEInfo: 001.001,Rml4ZXMgdGhlIGxhZyB3aGVuIHJlYWRpbmcgYW5kIHdyaXRpbmcgaG90a2V5cyBmb3IgYmFja2xpZ2h0IGNvbnRyb2wgb24gaWRlYXBhZCBsYXB0b3BzIGJ5IG1pbmltaXppbmcgdGhlIHRpbWVvdXQuCgpBcHBsaWVzIHRvIGxpbnV4LTMuOC4yCgpUaGFua3MsCgpTaWduZWQtb2ZmLWJ5OiBIYW1lZCBBQkRFTExJIDxhYmRlbGxpLmhhbWVkQHlhaG9vLmZyPgoKLS0tIGxpbnV4LTMuOC4yL2RyaXZlcnMvcGxhdGZvcm0veDg2L2lkZWFwYWQtbGFwdG9wLmMub3JpZyDCoCDCoCDCoDIwMTMtMDMtMDQgMjM6Mzg6MDkBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.135.514
Message-ID: <1362439987.98158.YahooMailNeo@web171602.mail.ir2.yahoo.com>
Date: Mon, 4 Mar 2013 23:33:07 +0000 (GMT)
From: Hamed Abdelli <abdelli.hamed@yahoo.fr>
Reply-To: Hamed Abdelli <abdelli.hamed@yahoo.fr>
Subject: [PATCH] x86: fix the delay when controlling brightness using hotkeys on ideapad laptops
To: "dwmw2@infradead.org" <dwmw2@infradead.org>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the lag when reading and writing hotkeys for backlight control on ideapad laptops by minimizing the timeout.

Applies to linux-3.8.2

Thanks,

Signed-off-by: Hamed ABDELLI <abdelli.hamed@yahoo.fr>

--- linux-3.8.2/drivers/platform/x86/ideapad-laptop.c.orig      2013-03-04 23:38:09.291989270 +0100
+++ linux-3.8.2/drivers/platform/x86/ideapad-laptop.c   2013-03-04 23:38:47.272988333 +0100
@@ -90,7 +90,7 @@ MODULE_PARM_DESC(no_bt_rfkill, "No rfkil
 /*
  * ACPI Helpers
  */
-#define IDEAPAD_EC_TIMEOUT (100) /* in ms */
+#define IDEAPAD_EC_TIMEOUT (1) /* in ms */

 static int read_method_int(acpi_handle handle, const char *method, int *val)
 {
@@ -157,7 +157,7 @@ static int read_ec_data(acpi_handle hand
        if (method_vpcw(handle, 1, cmd))
                return -1;

-       for (end_jiffies = jiffies+(HZ)*IDEAPAD_EC_TIMEOUT/1000+1;
+       for (end_jiffies = jiffies+(HZ)*IDEAPAD_EC_TIMEOUT/10000+1;
             time_before(jiffies, end_jiffies);) {
                schedule();
                if (method_vpcr(handle, 1, &val))
@@ -183,7 +183,7 @@ static int write_ec_cmd(acpi_handle hand
        if (method_vpcw(handle, 1, cmd))
                return -1;

-       for (end_jiffies = jiffies+(HZ)*IDEAPAD_EC_TIMEOUT/1000+1;
+       for (end_jiffies = jiffies+(HZ)*IDEAPAD_EC_TIMEOUT/10000+1;
             time_before(jiffies, end_jiffies);) {
                schedule();
                if (method_vpcr(handle, 1, &val))
