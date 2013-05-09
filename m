Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3EIRJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:09:22 -0400
Received: from nm27.access.bullet.mail.sp2.yahoo.com ([98.139.44.154]:34373
	"EHLO nm27.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3EIRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:09:21 -0400
X-Yahoo-Newman-Id: 893009.96955.bm@smtp101.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pB9mKVgVM1kvk7wfHK9MKJPbBmcCf2WGIyHXQIR25jNa9Ac
 BYc6ufQLh_apoE0Z76EEatba3QfLwPYUQoVDFMrcgpr6TaXFzA7_k9q7QLqC
 CtVQ0mjHl8hXYL202RFaloI.Uxer7O4NqWr5gjIWlyp7oMcy8Leiic3HSMZ8
 RH5sIWdqtGiQ1I4qqcI01jgVtmtzobwQGKJrjdc35Gvs2sz9m2iyRH4SzeDX
 X_n_JPxAqakjbIs.CUd4G5sexw.OGw02H9RFHkEZNTDzfKfMKuFr81AW6QEk
 nrchr9ZGk.FBYZEmtqlAsB8St.g2O68ahevrTHZ.pcYkOCPBp5c8pqtUilvR
 5LLzLUwDx_0yk8CjGJM8ZF4cnluDEHXnrElBHV.8GnyLlNK0mGRVzyyJBy1M
 ChY1HRmUN9JOMcuXwNqhdS5LBFoxBu1CQ.uUU6PyGj6r6VSPyJti.Jc4uMDx
 LoNZoHcQrANv89oa0nL1VN30TnSvQI1oj_hU-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp101.sbc.mail.gq1.yahoo.com with SMTP; 09 May 2013 10:09:20 -0700 PDT
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/3] pm: Introduce __pm to mark power management code
Date: Thu,  9 May 2013 10:09:23 -0700
Message-Id: <1368119366-8716-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series introduces a marker for power management functions
and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
can be removed from most of the code. This ensures that the conditional code
still compiles but is not included in the object file.

As a side effect, drivers declaring struct dev_pm_ops unconditionally
get a bit smaller if CONFIG_PM_SLEEP is not configured.

The first patch in the series introduces the marker, the following
two patches introduce the marker in two drivers to demonstrate its use.

The patch series depends on the "PM: Add pm_ops_ptr() macro" patch
submitted by Jingoo Han.
