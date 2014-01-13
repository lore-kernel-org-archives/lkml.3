Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaAMKoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:44:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38655 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAMKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:44:53 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-24-52d3c3a264ae
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: [PATCH v2 0/3] Deferrable timers support for timerfd API
Date: Mon, 13 Jan 2014 14:43:52 +0400
Message-id: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJMWRmVeSWpSXmKPExsVy+t/xa7qLDl8OMtg7RdZi7t3zLBZz1q9h
	szi4VdPi+pfnrBZnfutanG16w25xedccNgd2jwn9nxg97lzbw+ZxYsZvFo++LasYPT5vkgtg
	jeKySUnNySxLLdK3S+DKeL/hL0tBD2fF0f/ODYyz2LsYOTkkBEwkelYdZYWwxSQu3FvP1sXI
	xSEksJRRYmLPLShnBpPEncv7mLoYOTjYBAwk9t2zBWkQEbCQuPPqPytIDbNAP6NE95znbCAJ
	YQFHiY07NzKC1LMIqEr03zIACfMKuEvs6+xhBwlLCChIzJlkM4GRewEjwypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MkOD4uoNx6TGrQ4wCHIxKPLw7hC4HCbEmlhVX5h5ilOBgVhLh5dwJ
	FOJNSaysSi3Kjy8qzUktPsTIxMEp1cDIGpNV+r5oXf+7vIb44pVnfpW4ChboOtxevajCMJPf
	evb9H5k/VJepKd6ariVqVTctoK5wbZH/wVNdoa7zZ7usuj1LztusoC/aVany8mKd+Ec2vK8e
	tT1tEX+/XWqREuM6OT/XXz8sXykIvNrBrZ5Y2SAdfCbGWDRiXsnpEJGg6Vy3NggqsiuxFGck
	GmoxFxUnAgC2LiH27AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello dear community.

This is reworked patch set of original Anton's Vorontsov
proposal regarding unified deferrable timers in the user space.
http://lwn.net/Articles/514707/


I decided to resubmit it due we found it usefull for us too.

timerfd was modified since Anton's commit, Alarm support was added.
This isn't only rebase. Anton's previous version used deferrable timer
in couple with hrtimer. This version uses only deferrable timer. It
mean the behaviour of overrun number is different.
e.g. if you don't poll one second timer for a 10 seconds - you'll get
10 overruns with hrtimer, but for deferrable timer it could be another value.

Anton Vorontsov (3):
  kernel/time: Add new helpers to convert ktime to/from jiffies
  timerfd: Factor out timer-type unspecific timerfd_expire()
  timerfd: Add support for deferrable timers

 fs/timerfd.c            |  127 +++++++++++++++++++++++++++++++++++------------
 include/linux/jiffies.h |    4 +-
 include/linux/ktime.h   |    3 +-
 include/linux/timerfd.h |    4 +-
 kernel/time.c           |   23 +++++++++
 5 files changed, 126 insertions(+), 35 deletions(-)

-- 
1.7.9.5

