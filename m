Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaFDLNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:13:19 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48809 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaFDLNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:13:17 -0400
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 13:13:16 +0200
X-Google-Sender-Auth: 5mdIZz88ONuIUroAt8h5Qp_ljrU
Message-ID: <CAJZ5v0hXVuvKE84DThoH6Vdwn8j24phshyeQ8geGi9E3QZLwbQ@mail.gmail.com>
Subject: [GIT PULL] Final power management fixes for v3.15
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm-3.15-final

to receive final power management fixes for v3.15 with
top-most commit bf8102228a8bf053051f311e5486042fe0542894

  intel_pstate: Improve initial busy calculation

on top of commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014

  Linux 3.15-rc8

These are four stable-candidate intel_pstate fixes, including two
fixes for regressions introduced in 3.14.

Specifics:

 - Taking non-idle time into account when calculating core busy
   time was a mistake and led to a performance regression.  Since
   the problem it was supposed to address is now taken care of in
   a different way, we don't need to do it any more, so drop the
   non-idle time tracking from intel_pstate.  Dirk Brandewie.

 - Changing to fixed point math throughout the busy calculation
   introduced rounding errors that adversely affect the accuracy
   of intel_pstate's computations.  Fix from Dirk Brandewie.

 - The PID controller algorithm used by intel_pstate assumes that
   the time interval between two adjacent samples will always be the
   same which is not the case for deferable timers (used by
   intel_pstate) when the system is idle. This leads to inaccurate
   predictions and artificially increases convergence times for
   the minimum P-state.  Fix from Dirk Brandewie.

 - intel_pstate carries out computations using 32-bit variables
   that may overflow for large enough values of APERF/MPERF.  Switch
   to using 64-bit variables for computations, from Doug Smythies.

Thanks!


---------------

Dirk Brandewie (3):
      intel_pstate: Remove C0 tracking
      intel_pstate: Correct rounding in busy calculation
      intel_pstate: add sample time scaling

Doug Smythies (1):
      intel_pstate: Improve initial busy calculation

---------------

 drivers/cpufreq/intel_pstate.c | 52 +++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)
