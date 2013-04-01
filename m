Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab3DAIZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:25:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3DAIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:25:04 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-1e-5159445d2c02
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
Date: Mon, 01 Apr 2013 17:24:15 +0900
Message-id: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t8zPd1Yl8hAg7+LTS2eNv1gt7j+5Tmr
	RefZJ8wWZ5vesFu8ebiZ0eLyrjlsFp97jzBarD1yl93iduMKNov+hb1MFjMmv2Rz4Pbo27KK
	0ePR4hZGj8+b5AKYo7hsUlJzMstSi/TtErgyPj0+z1xwQani0ZO7bA2Ml6W6GDk5JARMJBp+
	vmCDsMUkLtxbD2RzcQgJLGOU2LvqGTtMUfu0zVCJ6YwSBw9OY4RwWpgk7p7uYwapYhPQkfi/
	7yZYh4iAqsSWJ//ZQYqYBW4zSRzvP80IkhAWcJT4vfkOK4jNAlT05O1cJhCbV8BD4mxfH1Cc
	A2idgsScSTYgvRIC/ewSGx/fY4KoF5D4NvkQC0SNrMSmA8wQ10lKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpRcZ6xYm5xaV56XrJ+bmbGCHB3L+D8e4B60OMyUDjJjJLiSbnA6MhryTe0NjMyMLU
	xNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MszrXdaofq0955nhW
	JjbGx+zE3tN7/KcmssqGcM6uvLy96XRKyZX3qe98qm5MLrjdzb1Y98TRmyXGC+0+eOctSZBe
	2XhcSz02vO7ym0cb2n5rVpYbPRdiruD9XLtg5V3lawVnmJO8u2Nu3Fy0svjpru877Pz6Ml2f
	yaopGFn7XHhhesUi8T2XEktxRqKhFnNRcSIAIzJlQXwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jQd1Yl8hAg60f9CyeNv1gt7j+5Tmr
	RefZJ8wWZ5vesFu8ebiZ0eLyrjlsFp97jzBarD1yl93iduMKNov+hb1MFjMmv2Rz4Pbo27KK
	0ePR4hZGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOALlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZnx6fJ65
	4IJSxaMnd9kaGC9LdTFyckgImEi0T9vMBmGLSVy4tx7I5uIQEpjOKHHw4DRGCKeFSeLu6T5m
	kCo2AR2J//tusoPYIgKqElue/GcHKWIWuM0kcbz/NCNIQljAUeL35jusIDYLUNGTt3OZQGxe
	AQ+Js319QHEOoHUKEnMm2Uxg5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhWnknt
	YFzZYHGIUYCDUYmHN+JCRKAQa2JZcWXuIUYJDmYlEV6fb0Ah3pTEyqrUovz4otKc1OJDjMlA
	yycyS4km5wPjOK8k3tDYxMzI0sjM2MTc2Jg0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GNM3bLfwKPd/fL57w+nKZ2qWIY/2fvARv6k7R3XqYZtIxq7ZZ3j5Xi7bYtLz7dmk/p0mesrt
	Uz1eJ77RUpoZnpQ+yeNAs2jhlHcd9xpW9+Uqqc6rEv76WzJ6vm2OcZ1p4kq3TLG/Sev3pp1t
	cF4Wr77nJqtR481Z8842Po7cuWzTOu9Gs/x5V5VYijMSDbWYi4oTAUcOFz/ZAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds new cpufreq governor named LAB(Legacy Application
Boost). Basically, this governor is based on ondemand governor.

** Introduce LAB (Legacy Application Boost) governor

<<Purpose>>
 One of the problem of ondemand is that it considers the most busy
cpu only while doesn't care how many cpu is in busy state at the
moment. This may results in unnecessary power consumption, and it'll
be critical for the system having limited power source.

 To get the best energy efficiency, LAB governor considers not only
idle time but also the number of idle cpus. It primarily focuses on
supplying adequate performance to users within the limited resource.
It checks the number of idle cpus then controls the maximum frequency
dynamically. And it also applies different frequency increasing level
depends on that information. In simple terms the less the number of
busy cpus, the better performance will be given.
 In addition, stable system's power consumption in the busy state can
be achieved also with using LAB governor. This will help to manage and
estimate power consumption in certain system.

<<Algorithm>>
- Count the idle cpus :
 Number of idle cpus are determined by historical result. It stores
cpu idle usage derived by dividing cpu idling time with a period
at every time when cpufreq timer is called. And it calculates average
of idle usage from the most recent stored data. It uses cpu state
usage information from per-cpu cpuidle_device. However, because that
cpu state usage information is updated only when cpu exits the state,
so the information may differ with the real one while cpu is in idle
at checking time. To detect whether cpu is idling, it uses timestamps
of cpuidle devices. It needs to re-calculate idle state usage for the
following cases.

The possible 3 cases which cpu is in idle at checking time.
(Shaded section represents staying in idle)

1) During the last period, idle state would be broken more than once.

 |____________|__      _____|_______       |
 |////////////|//|____|/////|//____________|
 t1           t2            @             t4

2) During the last period, there was no idle state entered, current
   idle is the first one.

 |            |     ________|_______       |
 |____________|____|////////|////__________|
 t1           t2            @             t4

3) During the last whole period, the core is in idle state.

 |      ______|_____________|________      |
 |_____|//////|/////////////|////__________|
 t1           t2            @             t4

(@ : Current checking point)

 After calculating idle state usage, it decides whether cpu was idle
in the last period with the idle threshold. If average of idle usage
is bigger than threshold, then it treats the cpu as a idle cpu.
 For the test, I set default threshold value to 90.

- Limitation of maximum frequency :
 With information got from counting the idle cpus phase, it sets maximum
frequency for the next period. By default, it limits the current policy's
maximum frequency by from 0 to 35% depends on the number of idle cpus.

- Setting next frequency
 LAB governor changes the frequency step by step like the conservative
governor. However, in LAB governor, the step is changing dynamically
depending on how many cpus are in idle.

	next_freq = current_freq + current_idle_cpus * increasing_step;

<<To do>>
 The prototype of this feature was developed as a cpuidle driver, so it
it uses cpuidle framework information temporarily. I'd like to use the
data of per-cpu tick_sched variable, it has all information that I want
exactly but it can't be accessed from cpufreq side.


I tested this patch on pegasus qaud board.
Any comments are welcomed.

Jonghwa Lee (2):
  cpuidle: Add idle enter/exit time stamp for notifying current idle
    state.
  cpufreq: Introduce new cpufreq governor, LAB(Legacy Application
    Boost).

 drivers/cpufreq/Kconfig            |   26 ++
 drivers/cpufreq/Makefile           |    1 +
 drivers/cpufreq/cpufreq_governor.h |   14 +
 drivers/cpufreq/cpufreq_lab.c      |  553 ++++++++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle.c          |    8 +-
 include/linux/cpufreq.h            |    3 +
 include/linux/cpuidle.h            |    4 +
 7 files changed, 605 insertions(+), 4 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

-- 
1.7.9.5

