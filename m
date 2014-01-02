Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaABSb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:31:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27945 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaABSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:24 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-94-52c5b0798191
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: [PATCH 0/3] Deferrable timers support for timerfd API
Date: Thu, 02 Jan 2014 22:30:45 +0400
Message-id: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xq7pVG44GGSxit5h79zyLxZz1a9gs
	Dm7VtDjzW9fibNMbdovLu+awObB5TOj/xOhx59oeNo8TM36zePRtWcXo8XmTXABrFJdNSmpO
	Zllqkb5dAlfGmZlHGQvOcFX8fvKBrYFxG0cXIyeHhICJxOnTU5ghbDGJC/fWs3UxcnEICSxl
	lFi5aBYrhDODSeLEooXsXYwcHGwCBhL77tmCNIgIWEjcefWfFcRmFqiQeNi8nwnEFhawk1je
	+ZcRxGYRUJV4NH02mM0r4C7xf+dhFpAxEgIKEnMm2Uxg5F7AyLCKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyQkvu5gXHrM6hCjAAejEg/vh7qjQUKsiWXFlbmHGCU4mJVEePVnAoV4UxIr
	q1KL8uOLSnNSiw8xMnFwSjUwaq7zW3Lsp17DCse1T7VfR2b/sAltk3209kUIR4rzPdXsicpO
	VzRSuKQfNrAklzncvhIaPzv3i97/JzqTE3e37Ds5++qPotf14txP1qVbm5umRnIu/uu9zHV/
	C8+RinUC535tSl006YjX2/NZOzcIbswwfMNS83zf/AsWn0Uy7yw8yfJmZrAlkxJLcUaioRZz
	UXEiAMIhlDPnAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello dear community.

This is reworked patch set of original Anton's Vorontsov
proposal regarding unified deferrable timers in user space.
http://lwn.net/Articles/514707/


I decided to resubmit it due we found it usefull for us too.

timerfd was modified since Anton's commit, Alarm support was added.
This isn't only rebase. Anton's previous version used deferrable timer
in couple with hrtimer. This version uses only deferrable timer. It
mean the behaviour of overrun number is different.
e.g. if you don't poll one second timer for a 10 seconds - you'll get
10 overruns with hrtimer, but in deferrable only version you'll get
only one overrun.

This version introduces new clockid (CLOCK_DEFERRABLE) , for timerfd_create, instead of
new flag (TFD_TIMER_DEFERRABLE) for timerfd_settime introduced in previous version.


Anton Vorontsov (3):
  kernel/time: Add new helpers to convert ktime to/from jiffies
  timerfd: Factor out timer-type unspecific timerfd_expire()
  timerfd: Add support for deferrable timers

 fs/timerfd.c              |   97 ++++++++++++++++++++++++++++++++++-----------
 include/linux/jiffies.h   |    4 +-
 include/linux/ktime.h     |    3 +-
 include/uapi/linux/time.h |    1 +
 kernel/time.c             |   23 +++++++++++
 5 files changed, 102 insertions(+), 26 deletions(-)

-- 
1.7.9.5

