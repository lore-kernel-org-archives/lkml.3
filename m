Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3IWJiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:38:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28142 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3IWJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:38:15 -0400
X-AuditID: cbfee68e-b7f756d000004512-be-52400bfd0865
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 00/15] rtc: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:38:04 +0900
Message-id: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3A==
Content-language: ko
x-cr-hashedpuzzle: DYAB FZbv FfAr JxIW KJnJ LPGE N8RY OeZe Qzwo YeVo khbs k7YH
 nS5Z oygX spGa
 2CRc;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{6D214FCE-ABAA-4037-9FCE-DFF7EC665066};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 23 Sep 2013 09:37:56
 GMT;WwBQAEEAVABDAEgAIAAwADAALwAxADUAXQAgAHIAdABjADoAIAB1AHMAZQAgAGQAZQB2AF8AZwBlAHQAXwBwAGwAYQB0AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {6D214FCE-ABAA-4037-9FCE-DFF7EC665066}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfd2/3A5BBie+M1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0XVoMXvBTfaKCe8esTcwLmXtYuTkkBAwkfi2dTEThC0mceHeerYuRi4OIYFljBKv
	Xl5kgyl60jwNrEFIYBGjxJROCYiiX4wSE2efZgRJsAmoSXz5cpi9i5GDQ0RAX6KtRQOkhlmg
	l1HiTO9udpAaYQEjiVNdk8DqWQRUJV7t+AM2lFfAVuLNx/dsELagxI/J91hAbGYBLYnN25pY
	IWx5ic1r3jKDzJcQUJd49FcXJCwioCex+1orO0SJiMS+F+8YQfZKCKxhlZhw6iEjxAOmEp97
	vzJBJB6xS1yceZUV4ggBiW+TD7FADJWV2HSAGaJeUuLgihssExglZiE5aRaSk2YhOWkWkt0L
	GFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoTEat8OxpsHrA8xJgOtn8gsJZqcD4z1vJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwrjhQ/kRv
	0fWnnzycLGJca3TPJcws5ps837zg6tbZu5ovCz7RS1y0SuhkfPu34652ttnBE1p6ZiU5XE91
	uNG7XsbhhPZEyb2/njLfkeZ5F/5A8HFcX0us3vQnK3c9vVvpu8ir4p7atpdzHGxWvThuefHJ
	lzDZo7Lbolf8dgtY9jIm0HDNS+86FyWW4oxEQy3mouJEAKzawILrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd0/3A5BBnteWVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNF1aDF7wU32ignvHrE3MC5l7WLk5JAQMJF4
	0jwNyhaTuHBvPRuILSSwiFFiSqdEFyMXkP2LUWLi7NOMIAk2ATWJL18Os3cxcnCICOhLtLVo
	gNQwC/QySpzp3c0OUiMsYCRxqmsSWD2LgKrEqx1/wBbwCthKvPn4ng3CFpT4MfkeC4jNLKAl
	sXlbEyuELS+xec1bZpD5EgLqEo/+6oKERQT0JHZfa2WHKBGR2PfiHSPIXgmBNawSE049ZIR4
	wFTic+9XpgmMQrOQrJiFZMUsJCtmIZm1gJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	IngmtYNxZYPFIUYBDkYlHt6IRPsgIdbEsuLK3EOMEhzMSiK8fqwOQUK8KYmVValF+fFFpTmp
	xYcYk4EhMJFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBMfXbUoes9wYyMR/mCatotfRua5TtbDBh2jZplf7LsJWO1ve8s+99iUxtvxJ56FpP
	YKzaHr7JG2VlwyRWHn91fePXFyt+1+5w0jAxzylaXym1TS87VIy/88iBez+PMG1jyNG7qCf+
	98EcARthzfr75z62rP3/iuvVgZryyzwXbRqe/l94rumBgBJLcUaioRZzUXEiAKDRmVxIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

---
 drivers/rtc/rtc-88pm80x.c         |    8 ++++----
 drivers/rtc/rtc-88pm860x.c        |    2 +-
 drivers/rtc/rtc-cmos.c            |    2 +-
 drivers/rtc/rtc-da9055.c          |    2 +-
 drivers/rtc/rtc-ds1305.c          |    2 +-
 drivers/rtc/rtc-ds1307.c          |    2 +-
 drivers/rtc/rtc-ds2404.c          |    2 +-
 drivers/rtc/rtc-ep93xx.c          |    6 +++---
 drivers/rtc/rtc-hid-sensor-time.c |    4 ++--
 drivers/rtc/rtc-m48t59.c          |   20 ++++++++++----------
 drivers/rtc/rtc-m48t86.c          |    8 ++++----
 drivers/rtc/rtc-pcf2123.c         |    2 +-
 drivers/rtc/rtc-rs5c348.c         |    4 ++--
 drivers/rtc/rtc-sh.c              |    5 +++--
 drivers/rtc/rtc-v3020.c           |    2 +-
 15 files changed, 36 insertions(+), 35 deletions(-)

