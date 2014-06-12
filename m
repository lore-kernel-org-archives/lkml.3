Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaFLVBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:01:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50016 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaFLVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:01:20 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 0/2] make kASLR vs hibernation boot-time selectable
Date: Thu, 12 Jun 2014 14:00:31 -0700
Message-Id: <1402606833-9825-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distros want to be able to offer CONFIG_RANDOMIZE_BASE as well as
CONFIG_HIBERNATION in a single kernel. Instead of making kASLR depend on
!HIBERNATION at compile time, allow kaslr to be selectable at boot time
(via "kaslr" kernel command line), which will disable hibernation in the
kernel. In this way the end user can choose which feature they want more
with hibernation continuing to stay enabled by default (no surprises).

This also has the benefit of being able to entirely disable hibernation
from the kernel command line, regardless of kASLR, which is a separately
desired feature as well.

v2:
- rework using kernel command line instead of hibernation_mode (rjw)

