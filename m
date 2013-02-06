Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3BFLXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:23:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25241 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3BFLXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:23:04 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-48-51123d1624d8
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] rtc: Modify leap year test for more simpler way
Date: Wed, 06 Feb 2013 20:22:55 +0900
Message-id: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zLV0xW6FAg5mrhC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG9kvNLAXbWSseXVrD3MC4kaWLkZNDQsBEYmtLHzuELSZx4d56
	ti5GLg4hgWWMEtdbfzPBFP2eO4kJIjGdUeLUp8WMEM5SJomZ0xeBjWIT0JH4v+8m2CgRAQWJ
	zb3PWEFsZoFORommKTUgtrCAg8SJt/vAprIIqEq8abwLZvMKeEjsavwItJoDaJuCxJxJNiDz
	JQR2sEm8+r2AGaJeQOLb5EMsEDWyEpsOMEMcJylxcMUNlgmMggsYGVYxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525ihISU9A7GVQ0WhxgFOBiVeHhv6AkGCrEmlhVX5h5ilOBgVhLhjVUQChTi
	TUmsrEotyo8vKs1JLT7EmAy0fCKzlGhyPjDc80riDY0NjA0NLQ3NTC1NDUgTVhLnZTz1JEBI
	ID2xJDU7NbUgtQhmCxMHp1QDo2bWZTsJo0vhG503/C5iaE07sUJv868dP9f11M6fcTXSPUjv
	Z/s7ucBTcpZxK0+Jt2vflxL6tuf9yVeyk7i5pspJX29eu0Xcc0mVRW/64ss/dvO87F986mnC
	e+WKQ/nz/ggkC91aN9vQSqbHmVNqSpTz0byX71b5H+zX/qJwa9nPjt69JZH/NyixFGckGmox
	FxUnAgDv6IKybQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoK6YrVCgwbFPXBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/ulZpaC7awVjy6tYW5g
	3MjSxcjJISFgIvF77iQmCFtM4sK99WxdjFwcQgLTGSVOfVrMCOEsZZKYOX0RWAebgI7E/303
	2UFsEQEFic29z1hBbGaBTkaJpik1ILawgIPEibf7wKayCKhKvGm8C2bzCnhI7Gr8CLSBA2ib
	gsScSTYTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgO2GfSOxhXNVgcYhTgYFTi
	4b2hJxgoxJpYVlyZe4hRgoNZSYQ3VkEoUIg3JbGyKrUoP76oNCe1+BBjMtDyicxSosn5wGjK
	K4k3NDYxM7I0MjM2MTc2Jk1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MxQ4+ySvPbFEL
	V+ycrvls6c5uo8bnC3xPP3TRd53L9X/LKbG59x/x/NnrcEhtc3BHwo2MervqY2nVP45NizK7
	2sCjc8z8td2nC6I9qfPnmom8KN3B3JJ3kGGJi6FVpF619nz9o4bv3DfWBN/itVyjqZIyQ4VR
	Y+ssB4ZFB88dclqwf9+24I1/lFiKMxINtZiLihMBf/Y8SZwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leap year which is multiple of 4, just needed 2 LSB for verifying.
A year with zero for all thease two bits means that it is leap year.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 include/linux/rtc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 9531845..d662b8d 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -181,7 +181,7 @@ void rtc_timer_do_work(struct work_struct *work);
 
 static inline bool is_leap_year(unsigned int year)
 {
-	return (!(year % 4) && (year % 100)) || !(year % 400);
+	return !(year & 0x3);
 }
 
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
-- 
1.7.9.5

