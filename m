Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3EIWdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab3EIWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@suse.de>
Subject: [ 70/73] EDAC: Dont give write permission to read-only files
Date: Thu,  9 May 2013 15:32:33 -0700
Message-Id: <20130509222805.430034286@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit c8c64d165ccfd2274058ac84e0c680f9b48c4ec1 upstream.

I get the following warning on boot:

------------[ cut here ]------------
WARNING: at drivers/base/core.c:575 device_create_file+0x9a/0xa0()
Hardware name:  -[8737R2A]-
Write permission without 'store'
...
</snip>

Drilling down, this is related to dynamic channel ce_count attribute
files sporting a S_IWUSR mode without a ->store() function. Looking
around, it appears that they aren't supposed to have a ->store()
function. So remove the bogus write permission to get rid of the
warning.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
[ shorten commit message ]
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc_sysfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -330,17 +330,17 @@ static struct device_attribute *dynamic_
 };
 
 /* possible dynamic channel ce_count attribute files */
-DEVICE_CHANNEL(ch0_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch0_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 0);
-DEVICE_CHANNEL(ch1_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch1_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 1);
-DEVICE_CHANNEL(ch2_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch2_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 2);
-DEVICE_CHANNEL(ch3_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch3_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 3);
-DEVICE_CHANNEL(ch4_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch4_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 4);
-DEVICE_CHANNEL(ch5_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch5_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 5);
 
 /* Total possible dynamic ce_count attribute file table */


