Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3HFROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:14:05 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:60452 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3HFROD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:14:03 -0400
X-AuditID: cbfec37d-b7f036d000004805-f8-52012ed90a13
From: Shuah Khan <shuah.kh@samsung.com>
To: "david-b@pacbell.net" <david-b@pacbell.net>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-topic: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-index: Ac6SyFcWUhE6FBeWT/iSf5cAZjp8ng==
Date: Tue, 06 Aug 2013 17:14:00 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175A08F@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn+5NPcYgg5W3xSxmLP/MZPFrz0cm
	i8u75rBZ3D11lM2if2Evk8WE3xfYHNg8Ps7awO4x++4PRo9Hi1sYPVas/s7u0XSqndXj8ya5
	ALYoLpuU1JzMstQifbsErozzfSIF27gqvvx6ydbAeJqji5GTQ0LARKJx/xFWCFtM4sK99Wxd
	jFwcQgLLGCW+nvzHDuH0Mkm0nvrABOHMZ5T4dGYOC0gLm4C6xOfXO8CqRATeM0p87P/KCJJg
	FnCUeHT5DjOILSxgK9HXvRfMFhFwknh48DQ7hK0n8XjWFKBBHBwsAqoSl47wg4R5Bewlunf9
	YwOxGYFO+n5qDRPESHGJ5tabLBCnCkgs2XOeGcIWlXj5+B8ryBgJAUWJ7autIMq1JNbvPA7V
	qi3x5N0FVojxghI/Jt9jmcAoOgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT01AoTveLE3OLS
	vHS95PzcTYyQuKvdwXj/q80hRgEORiUe3gsSjEFCrIllxZW5hxglOJiVRHh9QEK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYj/LNiDt1ZMP8f9+ESnf93CPdee1Wcx/rjsAsw8ONLoeOOe5RSle+
	J3bkS80qM2XNe2JdV3ZHzNVKj/ga0GyhtaXkbu2sWQlTNvUcqOdUkTnDU3PE+nbFf67sl83+
	6oa7Vk1mmTK9n6fK58KT6eqbNP+b/JLKVVzS+WYu2/n7Z/81pRyuDAmoUmIpzkg01GIuKk4E
	AF6XGMyZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sl811h_suspend() seems to be the odd routine in the way it handles the 
PM_EVENT_PRETHAW state. It treats it same as PM_EVENT_SUSPEND and 
PM_EVENT_HIBERNATE. All other uses I could find treat it same as 
PM_EVENT_FREEZE and PM_EVENT_QUIESCE. Makes sense since PM_EVENT_PRETHAW 
is PM_EVENT_QUIESCE.

#define PM_EVENT_PRETHAW PM_EVENT_QUIESCE

Reference: Commit 185849991d592497e43bcd264c6152af1261ffe2 introduced 
PM_EVENT_PRETHAW state to sl811h_suspend().

Couple of questions?

- Why does sl811h_suspend() treat PM_EVENT_PRETHAW different from 
PM_EVENT_FREEZE?

There is no problem with this code as such, since state is passed in. 
However, this usage conflicts with the rest of the usages and the way 
pm_op() routine maps PM_EVENT_PRETHAW/PM_EVENT_QUIESCE to freeze() pm_ops.

         case PM_EVENT_FREEZE:
         case PM_EVENT_QUIESCE:
                 return ops->freeze;

Assuming the handling PM_EVENT_PRETHAW is correct in this routine, what 
would be the right mapping for this legacy handling to dev_pm_ops?

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
