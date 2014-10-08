Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaJHHuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:50:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40724 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJHHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:49:27 -0400
From: Mike Turquette <mturquette@linaro.org>
To: viresh.kumar@linaro.org
Cc: thomas.petazzoni@free-electrons.com, rjw@rjwysocki.net,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        shawn.guo@linaro.org, sboyd@codeaurora.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        pramod.gurav@smartplayin.com, rob.herring@linaro.org,
        ezequiel.garcia@free-electrons.com, tawfik@marvell.com,
        nadavh@marvell.com, alior@marvell.com, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com, vincent.guittot@linaro.org,
        nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/2] allow cpufreq drivers to export flags
Date: Wed,  8 Oct 2014 00:48:52 -0700
Message-Id: <1412754534-14068-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
References: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is partially in response to a discussion around DT bindings
for CPUfreq drivers [0], but it is also needed for on-going work to
integrate CPUfreq with the scheduler. In particular a scheduler-driven
cpu frequency scaling policy would be well served to know if the
underlying CPUfreq driver .target callback might sleep or block for a
long time.

[0] http://lkml.kernel.org/r/<fcb88cd21f31a467d2d49911c2505082837f72ea.1410323179.git.viresh.kumar@linaro.org>

Mike Turquette (2):
  cpufreq: add driver flag for sleepable transitions
  cpufreq: new function to query driver for flags

 drivers/cpufreq/cpufreq.c |  9 +++++++++
 include/linux/cpufreq.h   | 13 +++++++++++++
 2 files changed, 22 insertions(+)

-- 
1.8.3.2

