Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaJGK6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:58:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaJGK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:58:51 -0400
X-AuditID: cbfee68f-f791c6d000004834-cf-5433c76770f2
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        jenny.tc@intel.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 2/3] power: core: Add variables related temperature to
 power_supply_info.
Date: Tue, 07 Oct 2014 19:58:37 +0900
Message-id: <1412679518-21499-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkSDf9uHGIwY7FchYHt2paTHryntli
	4srJzBZrv/awW3SefcJscXnXHDaLz71HGC3unjrKZnF6d4kDp8eE/k+MHjtn3WX32LxCy2Px
	npdMHptWdbJ59G1ZxeixYvV3do/Pm+QCOKK4bFJSczLLUov07RK4Mi692c5cMJO14sCODcwN
	jOtZuhg5OSQETCQeNNxnhLDFJC7cW8/WxcjFISSwlFHi9JqzTF2MHGBF629aQ8SnM0p0zz8L
	1iwk0MYkcfGgMYjNJqAj8X/fTXYQW0RAQWJz7zNWEJtZYDujxNxPySC2sEC0ROu8dUwgNouA
	qsS76c3MIDavgIdEz5GnrBC7FCTmTLIBCXMKeEo03m6HWuUhsejBW1aQGyQE9rFLnH/ezwgx
	R0Di2+RDLBC9shKbDjBD/CIpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+du
	YgTGw+l/z/p3MN49YH2IUYCDUYmHd4WWcYgQa2JZcWXuIUZToA0TmaVEk/OBUZdXEm9obGZk
	YWpiamxkbmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG6EtbHzCfMrHKW+WX
	2lt5eaOa/vWs5Xmfmy5VLpi/1/Tdw66OGrP2YIuS7ZOfsymLBt2ZNTk10Kyw6HLR+2+8aX+n
	Xtl2T7tei+XcBK8OlyBHma3TT+3xy37Vc0XjumlP7Zzn7V+u5n9ym+xn5H9Wp+fW18db9794
	d8KI0e+W8d2Zr1Uf+K6brMRSnJFoqMVcVJwIANJQDAuCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd3048YhBht6xS0ObtW0mPTkPbPF
	xJWTmS3Wfu1ht+g8+4TZ4vKuOWwWn3uPMFrcPXWUzeL07hIHTo8J/Z8YPXbOusvusXmFlsfi
	PS+ZPDat6mTz6NuyitFjxerv7B6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcy49GY7c8FM1ooDOzYwNzCuZ+li5OCQEDCRWH/TuouRE8gUk7hwbz1bFyMXh5DA
	dEaJ7vlnWUASQgJtTBIXDxqD2GwCOhL/991kB7FFBBQkNvc+YwWxmQW2M0rM/ZQMYgsLREu0
	zlvHBGKzCKhKvJvezAxi8wp4SPQcecoKsVdBYs4kG5Awp4CnROPtdqhVHhKLHrxlncDIu4CR
	YRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLQ9k97BuKrB4hCjAAejEg/vCi3jECHWxLLi
	ytxDjBIczEoivNbHgEK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD0wEeSXxhsYmZkaWRuaG
	FkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGJdwnyjdIhRqlbbrVFOC2aF9a6X7pnlb
	N3vnLLJYpLNccNqpOec/9jS3MP9UmpM978C6l9JdVuxv8nwezX5SdNp7b0LDE6XkuLxznyJk
	r0xb92nJYg97UYXDXkcf6B0N0GO2WB/7lFe/JaVpwoHcPzGzf3194Onz7uPLY789WGfFKMw/
	ama6qkWJpTgj0VCLuag4EQBr1HOZzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To represent thermal limitation of power_supply, it adds 'temperature_max,
temperature_min' to power_supply_info structure.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 include/linux/power_supply.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 99306aa..0c8588c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -241,6 +241,8 @@ struct power_supply_info {
 	int charge_empty_design;
 	int energy_full_design;
 	int energy_empty_design;
+	int temperature_max;
+	int temperature_min;
 	int use_for_apm;
 };
 
-- 
1.7.9.5

