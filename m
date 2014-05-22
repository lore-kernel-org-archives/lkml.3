Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaEVXJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:09:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62673 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753430AbaEVXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:09:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] PM / sleep: Make it possible to change the labeling of sleep states
Date: Fri, 23 May 2014 01:21:16 +0200
Message-ID: <1817539.9KW2IGGbDV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In accordance with the changelog of patch [3/3], there are systems where the
only available sleep state is PM_SUSPEND_FREEZE, so neither "mem" nor "standby"
are present in /sys/power/state.  As a result, some user space frameworks are
unable to use suspend on those systems even though the "freeze" sleep state
is there to use.

To address this issue, patch [3/3] adds a command line argument to switch the
behavior so that sleep states are enumerated from the deepest to the shallowest
available and the deepest one is always "mem".  The default is the current
behavior, of course.

Patches [1-2/3] do some preparatory modifications that I think are better done
separately.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
